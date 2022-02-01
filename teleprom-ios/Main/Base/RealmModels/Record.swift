//
//  Record.swift
//  teleprom-ios
//
//  Created by Tigran Arsenyan on 12/28/21.
//

import RealmSwift
import Foundation

class Record: BaseRealmObject {
    
    @objc dynamic var title: String?
    @objc dynamic var textData: Data?
    
    func setTitle(_ title: String?) {
        realm?.beginWrite()
        self.title = title
        try! realm?.commitWrite()
        RecordDataProvider.shared.recordsUpdated()
    }
    
    func getTitle() -> String? {
        return title
    }
    
    func setText(_ attributedString: NSAttributedString) {
        realm?.beginWrite()
        textData = try! NSKeyedArchiver.archivedData(withRootObject: attributedString, requiringSecureCoding: false)
        try! realm?.commitWrite()
        RecordDataProvider.shared.recordsUpdated()
    }
    
    func getText() -> NSAttributedString? {
        if let textData = textData {
            return try! NSKeyedUnarchiver.unarchivedObject(ofClass: NSAttributedString.self, from: textData)
        } else {
            return nil
        }
    }
    
    func pull(from record: Record) -> Record {
        setTitle(record.getTitle())
        setText(record.getText() ?? NSAttributedString(string: ""))
        
        return self
    }
}
