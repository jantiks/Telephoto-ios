//
//  DoneCommand.swift
//  teleprom-ios
//
//  Created by Tigran Arsenyan on 12/26/21.
//

import Foundation

struct DoneCommand: CommonCommand {
    
    private let action: () -> (Void)
    
    init(_ action: @escaping () -> (Void)) {
        self.action = action
    }
    
    func execute() {
        action()
    }
}
