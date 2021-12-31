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
        realm?.beginWrite()
        self.title = title
        try! realm?.commitWrite()
        RecordDataProvider.shared.recordsUpdated()
    }
    
    func getTitle() -> String? {
        return title
    }
    
    func setText(_ text: String) {
        realm?.beginWrite()
        self.text = text
        try! realm?.commitWrite()
        RecordDataProvider.shared.recordsUpdated()
    }
    
    func getText() -> String? {
        return text
    }
}
