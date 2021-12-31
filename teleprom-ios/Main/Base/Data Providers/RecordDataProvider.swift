//
//  RecordDataProvider.swift
//  teleprom-ios
//
//  Created by Tigran Arsenyan on 12/30/21.
//

import RealmSwift

class RecordDataProvider {
    
    static var shared = RecordDataProvider()
    
    private var reloadCommands: [CommonCommand] = []
    
    private init() {}
    
    func addRecord(_ record: Record) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(record, update: .all)
        }
        reloadCommands.forEach({ $0.execute() })
    }
    
    func getRecords() -> [Record] {
        let realm = try! Realm()
        
        return realm.objects(Record.self).map({ $0 })
    }
    
    func recordsUpdated() {
        reloadCommands.forEach({ $0.execute() })
    }
    
    func addReloadCommands(_ commands: [CommonCommand]) {
        reloadCommands.append(contentsOf: commands)
    }
}
