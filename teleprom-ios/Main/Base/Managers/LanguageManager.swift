//
//  LanguageManager.swift
//  teleprom-ios
//
//  Created by Tigran Arsenyan on 12/26/21.
//

import Foundation

class LanguageManager {
    
    static let shared = LanguageManager()
    private var reloadCommands: [CommonCommand] = []
    
    private init() {}
    
    func addReloadCommands(_ commands: [CommonCommand]) {
        reloadCommands.append(contentsOf: commands)
    }
    
    func languageChanged() {
        reloadCommands.forEach({ $0.execute() })
    }
}
