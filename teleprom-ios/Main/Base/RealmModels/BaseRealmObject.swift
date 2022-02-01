//
//  BaseRealmObject.swift
//  teleprom-ios
//
//  Created by Tigran Arsenyan on 12/28/21.
//

import RealmSwift

class BaseRealmObject: Object {
    
    @objc dynamic var id: String = UUID().uuidString
    
    required convenience init(_ id: String) {
        self.init()
        self.id = id
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    func getId() -> String {
        return id
    }
}
