//
//  ViewController.swift
//  FineNotifications
//
//  Created by Marin Todorov on 4/29/16.
//  Copyright © 2016 Realm Inc. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let repos: Results<Repo> = {
        let realm = try! Realm()
        return realm.objects(Repo).sorted("pushedAt", ascending: false)
    }()
    var token: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        token = repos.addNotificationBlock {[weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }

            switch changes {
            case .Initial:
                tableView.reloadData()
                break
            case .Update(let results, let deletions, let insertions, let modifications):
                
                tableView.beginUpdates()
                
                //re-order repos when new pushes happen
                tableView.insertRowsAtIndexPaths(insertions.map { NSIndexPath(forRow: $0, inSection: 0) },
                    withRowAnimation: .Automatic)
                tableView.deleteRowsAtIndexPaths(deletions.map { NSIndexPath(forRow: $0, inSection: 0) },
                    withRowAnimation: .Automatic)

                //flash cells when repo gets more stars
                for row in modifications {
                    let indexPath = NSIndexPath(forRow: row, inSection: 0)
                    let repo = results[indexPath.row]
                    let cell = tableView.cellForRowAtIndexPath(indexPath) as! RepoCell
                    cell.configureWith(repo)
                    cell.flashBackground()
                }
                
                tableView.endUpdates()
                break
            case .Error(let error):
                print(error)
                break
            }
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repos.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let repo = repos[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("RepoCell") as! RepoCell
        cell.configureWith(repo)
        return cell
    }
}