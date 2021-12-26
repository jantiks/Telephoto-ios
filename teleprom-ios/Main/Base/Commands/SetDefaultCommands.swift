//
//  SetDefaultCommands.swift
//  teleprom-ios
//
//  Created by Tigran Arsenyan on 12/26/21.
//

import Foundation

struct SetDefaultCommands: CommonCommand {
    func execute() {
        if !UserDefaults.standard.bool(forKey: "HasOppenedAppBefore") {
            SetVideoSettingsCommand(.hd_1080p).execute()
            UserDefaults.standard.set(true, forKey: "HasOppenedAppBefore")
        }
    }
}
