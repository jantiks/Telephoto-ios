//
//  Record.swift
//  teleprom-ios
//
//  Created by Tigran Arsenyan on 12/28/21.
//

import RealmSwift

class Record: BaseRealmObject {
    
    @objc dynamic var title: String?
    @objc dynamic var text: String?
    
    func setTitle(_ title: String) {
        self.title = title
    }
    
    func getTitle() -> String? {
        return title
    }
    
    func setText(_ text: String) {
        self.text = text
    }
    
    func getText() -> String? {
        return text
    }
}
