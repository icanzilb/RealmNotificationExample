//
//  RepoCell.swift
//  FineNotifications
//
//  Created by Marin Todorov on 4/29/16.
//  Copyright © 2016 Realm Inc. All rights reserved.
//

import UIKit

class RepoCell: UITableViewCell {

    static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var stars: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
    
    func configureWith(_ repo: Repo) {
        textLabel!.text = repo.name
        let lastPush = RepoCell.formatter.string(from: Date(timeIntervalSinceReferenceDate: repo.pushedAt))
        detailTextLabel!.text = "\(repo.stars)🌟 pushed: \(lastPush)"
    }
    
    func flashBackground() {
        backgroundView = UIView()
        backgroundView!.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 0.7, alpha: 1.0)
        UIView.animate(withDuration: 2.0, animations: {
            self.backgroundView!.backgroundColor = UIColor.white
        })
    }
}
