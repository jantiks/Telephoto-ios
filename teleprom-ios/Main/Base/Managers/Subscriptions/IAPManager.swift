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
    private var reloadCommands: [CommonCommand] = []

    private init() {}

    func addReloadCommands(_ commands: [CommonCommand]) {
        reloadCommands.append(contentsOf: commands)
    }
    
    func configure() {
        Qonversion.launch(withKey: projectKey) { [weak self] result, error in
            guard error == nil else {
                print("Error to launch qonversion")
                return
            }
            
            self?.checkPermissions()
            print("QONVERSION ID: \(result.uid)")
        }
    }

    func checkPermissions(_ completion: @escaping ((Bool) -> Void) = { _ in }) {
        Qonversion.checkPermissions { [weak self] result, error in
            guard error == nil else {
                self?.setLastSubscribedState(isSubscribed: false)
                completion(false)
                return
            }

            #warning("should be changed if the amount of subsriptions increases")
            if result.isEmpty {
                print("HAS NOT \(result)")
                self?.setLastSubscribedState(isSubscribed: false)
                completion(false)
            } else {
                print("HAS \(result)")
                self?.setLastSubscribedState(isSubscribed: true)
                completion(true)
            }
        }
    }

    func purchase(product: SubscriptionType, _ completion: @escaping ((Bool) -> Void) = { _ in }) {
        Qonversion.purchase(product.rawValue) { [weak self] result, error, canceled in
            guard error == nil else {
                print("Error purchasing product")
                self?.setLastSubscribedState(isSubscribed: false)
                completion(false)
                return
            }

            guard !canceled else {
                print("purchase canceled")
                self?.setLastSubscribedState(isSubscribed: false)
                completion(false)
                return
            }
            
            self?.reloadCommands.forEach({ $0.execute() })
            self?.setLastSubscribedState(isSubscribed: true)
            completion(true)
            print("Purchase completed")
        }
    }

    func restore(_ completion: @escaping ((Bool) -> Void) = { _ in }) {
        Qonversion.restore { [weak self] result, error in
            guard error == nil else {
                print("Restore error")
                completion(false)
                return
            }

            self?.reloadCommands.forEach({ $0.execute() })
            self?.setLastSubscribedState(isSubscribed: true)
            completion(true)
            print("Restored: \(result)")
        }
    }
    
    func getLastSubscribedState() -> Bool {
        return  UserDefaults.standard.bool(forKey: "lastSubscribedState")
    }
    
    private func setLastSubscribedState(isSubscribed: Bool) {
        UserDefaults.standard.set(isSubscribed, forKey: "lastSubscribedState")
    }
}
