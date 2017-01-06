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
        return realm.objects(Repo.self).sorted(byProperty: "pushedAt", ascending: false)
    }()
    var token: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        token = repos.addNotificationBlock {[weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }

            switch changes {
            case .initial:
                tableView.reloadData()
                break
            case .update(let results, let deletions, let insertions, let modifications):
                
                tableView.beginUpdates()
                
                //re-order repos when new pushes happen
                tableView.insertRows(at: insertions.map { IndexPath(row: $0, section: 0) },
                                     with: .automatic)
                tableView.deleteRows(at: deletions.map { IndexPath(row: $0, section: 0) },
                                     with: .automatic)

                //flash cells when repo gets more stars
                for row in modifications {
                    let indexPath = IndexPath(row: row, section: 0)
                    let repo = results[indexPath.row]
                    let cell = tableView.cellForRow(at: indexPath) as! RepoCell
                    cell.configureWith(repo)
                    cell.flashBackground()
                }
                
                tableView.endUpdates()
                break
            case .error(let error):
                print(error)
                break
            }
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let repo = repos[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepoCell") as! RepoCell
        cell.configureWith(repo)
        return cell
    }
}
