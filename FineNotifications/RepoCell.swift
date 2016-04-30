//
//  RepoCell.swift
//  FineNotifications
//
//  Created by Marin Todorov on 4/29/16.
//  Copyright © 2016 Realm Inc. All rights reserved.
//

import UIKit

class RepoCell: UITableViewCell {

    static let formatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .NoStyle
        return formatter
    }()
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var stars: UILabel!
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
    
    func configureWith(repo: Repo) {
        textLabel!.text = repo.name
        let lastPush = RepoCell.formatter.stringFromDate(NSDate(timeIntervalSinceReferenceDate: repo.pushedAt))
        detailTextLabel!.text = "\(repo.stars)🌟 pushed: \(lastPush)"
    }
    
    func flashBackground() {
        backgroundView = UIView()
        backgroundView!.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 0.7, alpha: 1.0)
        UIView.animateWithDuration(2.0, animations: {
            self.backgroundView!.backgroundColor = UIColor.whiteColor()
        })
    }
}