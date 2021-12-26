//
//  StringExtension.swift
//  teleprom-ios
//
//  Created by Tigran Arsenyan on 12/25/21.
//

import Foundation

extension String {
    
    var localized: String {
        let langCode = Languages.getAppCurrentLanguage()
        guard let bundlePath = Bundle.main.path(forResource: langCode, ofType: "lproj"), let bundle = Bundle(path: bundlePath) else {
            return NSLocalizedString(self, comment: "")
        }
        return NSLocalizedString(self, tableName: nil, bundle: bundle, comment: "")
    }
}
