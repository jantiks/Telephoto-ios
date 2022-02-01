//
//  SKStoreReviewControllerExtension.swift
//  teleprom-ios
//
//  Created by Tigran Arsenyan on 12/26/21.
//

import StoreKit

extension SKStoreReviewController {
    
    static func requestReviewFromScene() {
        if #available(iOS 14.0, *) {
            if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                SKStoreReviewController.requestReview(in: scene)
            }
        } else if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        }
    }
}
