//
//  SaveVideoCommand.swift
//  teleprom-ios
//
//  Created by Tigran Arsenyan on 1/6/22.
//

import UIKit

class SaveVideoCommand: NSObject, CommonCommand {
    
    private let videoUrl: URL
    private let savedAction: (() -> ())
    private let failedAction: (() -> ())
    
    init(_ videoUrl: URL, savedAction: @escaping (() -> ()), failedAction: @escaping (() -> ())) {
        self.videoUrl = videoUrl
        self.savedAction = savedAction
        self.failedAction = failedAction
    }
    
    @objc private func video(_ video: String, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print(error.localizedDescription)
            failedAction()
        } else {
            savedAction()
        }
    }
    
    func execute() {
        UISaveVideoAtPathToSavedPhotosAlbum(videoUrl.path, self, #selector(video(_:didFinishSavingWithError:contextInfo:)), nil)
    }
}
