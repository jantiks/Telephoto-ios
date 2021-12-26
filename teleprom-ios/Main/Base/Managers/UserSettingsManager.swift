//
//  UserSettingsManager.swift
//  teleprom-ios
//
//  Created by Tigran Arsenyan on 12/26/21.
//

import Foundation

class UserSettingsManager {
    
    static var shared = UserSettingsManager()
    
    private init() {}
    
    func setVideoSetting(_ setting: VideoSetting) {
        SetVideoSettingsCommand(setting).execute()
    }
    
    func getVideoSetting() -> VideoSetting {
        let rawValue = UserDefaults.standard.integer(forKey: "VideoSettings")
        print("getting settings \(VideoSetting(rawValue).title)")
        return VideoSetting(rawValue)
    }
}
