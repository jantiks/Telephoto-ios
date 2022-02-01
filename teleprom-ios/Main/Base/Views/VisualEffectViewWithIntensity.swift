//
//  VisualEffectViewWithIntensity.swift
//  teleprom-ios
//
//  Created by Tigran Arsenyan on 1/2/22.
//

import UIKit

class VisualEffectWithIntensityView: UIVisualEffectView {
    private var animator: UIViewPropertyAnimator!
    
    init(effect: UIVisualEffect, intensity: CGFloat) {
        super.init(effect: nil)
        animator = UIViewPropertyAnimator(duration: 1, curve: .linear) { [weak self] in
            self?.effect = effect }
        animator.fractionComplete = intensity
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
