//
//  GitHubAPI.swift
//  FineNotifications
//
//  Created by Marin Todorov on 4/29/16.
//  Copyright © 2016 Realm Inc. All rights reserved.
//

import Foundation
import RealmSwift
import AFDateHelper

let username = "realm"

class GitHubAPI {
    
    let repoUrl = NSURL(string: "https://api.github.com/users/\(username)/repos?sort=pushed&direction=desc&type=owner")!
    
    func startFetching() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {[weak self] in
            guard let `self` = self else {return}
            
            NSURLSession.sharedSession().dataTaskWithURL(self.repoUrl, completionHandler: { data, response, error in
                print("updated")
                if let data = data, let json = try! NSJSONSerialization.JSONObjectWithData(data, options: []) as? Array<[String: AnyObject]> {
                    self.persistRepos(json)
                }
                delay(seconds: 10, completion: self.startFetching)
            }).resume()
        }
    }
    
    func persistRepos(json: Array<[String: AnyObject]>) {
        let realm = try! Realm()
        try! realm.write {
            for jsonRepo in json {
                guard let id = jsonRepo["id"] as? Int,
                    let stars = jsonRepo["stargazers_count"] as? Int,
                    let name = jsonRepo["name"] as? String,
                    let pushedAt = jsonRepo["pushed_at"] as? String else {
                        break
                }
                
                if let repo = realm.objectForPrimaryKey(Repo.self, key: id) {
                    //update
                    let lastPushDate = NSDate(fromString: pushedAt, format: .ISO8601(.DateTimeSec))
                    if repo.pushedAt.distanceTo(lastPushDate.timeIntervalSinceReferenceDate) > 1e-16 {
                        repo.pushedAt = lastPushDate.timeIntervalSinceReferenceDate
                    }
                    if repo.stars != stars {
                        repo.stars = stars
                    }
                } else {
                    //insert
                    let repo = Repo()
                    repo.name = name
                    repo.stars = stars
                    repo.id = id
                    repo.pushedAt = NSDate(fromString: pushedAt, format: .ISO8601(.DateTimeSec)).timeIntervalSinceReferenceDate
                    realm.add(repo)
                }
            }
        }
    }
}