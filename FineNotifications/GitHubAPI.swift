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

typealias JSONObject = [String: AnyObject]

let username = "realm"

class GitHubAPI {
    
    let repoUrl = URL(string: "https://api.github.com/users/\(username)/repos?sort=pushed&direction=desc&type=owner")!
    
    func startFetching() {
        DispatchQueue.global(qos: .background).async {[weak self] in
            guard let this = self else { return }
            
            URLSession.shared.dataTask(with: this.repoUrl, completionHandler: { data, response, error in
                print("updated")
                if let data = data, let json = try! JSONSerialization.jsonObject(with: data, options: []) as? Array<JSONObject> {
                    this.persistRepos(json)
                }
                delay(seconds: 10, completion: this.startFetching)
            }).resume()
        }
    }
    
    func persistRepos(_ json: Array<[String: AnyObject]>) {
        let realm = try! Realm()
        try! realm.write {
            for jsonRepo in json {
                guard let id = jsonRepo["id"] as? Int,
                    let stars = jsonRepo["stargazers_count"] as? Int,
                    let name = jsonRepo["name"] as? String,
                    let pushedAt = jsonRepo["pushed_at"] as? String else {
                        break
                }
                
                if let repo = realm.object(ofType: Repo.self, forPrimaryKey: id) {
                    //update
                    let lastPushDate = Date(fromString: pushedAt, format: .iso8601(.DateTimeSec))
                    if repo.pushedAt.distance(to: lastPushDate.timeIntervalSinceReferenceDate) > 1e-16 {
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
                    repo.pushedAt = Date(fromString: pushedAt, format: .iso8601(.DateTimeSec)).timeIntervalSinceReferenceDate
                    realm.add(repo)
                }
            }
        }
    }
}
