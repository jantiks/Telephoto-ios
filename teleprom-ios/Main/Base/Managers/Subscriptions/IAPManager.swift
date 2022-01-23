//
//  IAPManager.swift
//  teleprom-ios
//
//  Created by Tigran Arsenyan on 1/23/22.
//

import Foundation
import Qonversion

class IAPManager {
    
    static let shared = IAPManager()
    private let projectKey = "Pkh75cl1zUr-SZoTtT9ci_IhQJshH83M"
    
    private init() {}
    
    func configure() {
        Qonversion.launch(withKey: projectKey) { result, error in
            guard error == nil else {
                print("Error to launch qonversion")
                return
            }

            print("QONVERSION ID: \(result.uid)")
        }
    }
    
    func checkPermissions(_ completion: @escaping ((Bool) -> Void) = { _ in }) {
        Qonversion.checkPermissions { result, error in
            guard error == nil else {
                completion(false)
                return
            }
            
            #warning("should be changed if the amount of subsriptions increases")
            if result.isEmpty {
                print("HAS NOT")
                completion(false)
            } else {
                print("HAS")
                completion(true)
            }
        }
    }
    
    func purchase(product: SubscriptionType, _ completion: @escaping ((Bool) -> Void) = { _ in }) {
        Qonversion.purchase(product.rawValue) { result, error, canceled in
            guard error == nil else {
                print("Error purchasing product")
                completion(false)
                return
            }
            
            guard !canceled else {
                print("purchase canceled")
                completion(false)
                return
            }
            
            completion(true)
            print("Purchase completed")
        }
    }
    
    func restore(_ completion: @escaping ((Bool) -> Void) = { _ in }) {
        Qonversion.restore { result, error in
            guard error == nil else {
                print("Restore error")
                completion(false)
                return
            }
            
            completion(true)
            print("Restored: \(result)")
        }
    }
}
