//
//  Repo.swift
//  FineNotifications
//
//  Created by Marin Todorov on 4/29/16.
//  Copyright © 2016 Realm Inc. All rights reserved.
//

import Foundation
import RealmSwift

class Repo: Object {
    
    //MARK: properties
    dynamic var name = ""
    dynamic var id: Int = 0
    dynamic var stars = 0
    dynamic var pushedAt: TimeInterval = 0
    
    //MARK: meta
    override class func primaryKey() -> String? { return "id" }
}
