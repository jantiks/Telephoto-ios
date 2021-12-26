//
//  SetVideoSettingsCommand.swift
//  teleprom-ios
//
//  Created by Tigran Arsenyan on 12/26/21.
//

import Foundation

struct SetVideoSettingsCommand: CommonCommand {
    
    private var setting: VideoSetting
    
    init(_ setting: VideoSetting) {
        self.setting = setting
    }
    
    func execute() {
        UserDefaults.standard.set(setting.rawValue, forKey: "VideoSettings")
    }
}
