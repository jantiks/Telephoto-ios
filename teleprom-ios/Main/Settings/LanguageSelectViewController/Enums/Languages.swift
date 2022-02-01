//
//  Languages.swift
//  teleprom-ios
//
//  Created by Tigran Arsenyan on 12/26/21.
//

import Foundation

enum Languages: String, CaseIterable {
    
    case english = "en"
    case russian = "ru"
    
    var name: String {
        get {
            switch self {
            case .english:
                return "English"
            case .russian:
                return "Русский язык"
            }
        }
    }
    
    static func getAppCurrentLanguage() -> String {
        if UserDefaults.standard.object(forKey: "currentLanguge") != nil {
            return UserDefaults.standard.string(forKey: "currentLanguge")!
        } else {
            let deviceLanguage = Languages.getDeviceLanguageCode()
            return (allCases.first(where: { $0.rawValue == deviceLanguage }) ?? Languages.english).rawValue
        }
    }
    
    private static func getDeviceLanguageCode() -> String {
        return String((UserDefaults.standard.value(forKey: "AppleLocale") as! String).prefix(2))
    }
    
    static func setAppLanguage(code: String) {
        UserDefaults.standard.set(code, forKey: "currentLanguge")
    }
}
