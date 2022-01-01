//
//  textModifierView.swift
//  teleprom-ios
//
//  Created by Tigran Arsenyan on 1/1/22.
//

import UIKit

class TextModifierView: BaseCustomView {

    @IBOutlet private weak var conetentView: UIView!
    @IBOutlet private weak var changeFontButton: UIButton!
    
    override func getXibName() -> String {
        return "\(TextModifierView.self)"
    }
    
    override func getContentView() -> UIView {
        return conetentView
    }
    
    override func commonInit() {
        super.commonInit()
        
        changeFontButton.layer.borderWidth = 0.5
        changeFontButton.layer.borderColor = UIColor.white.cgColor
        
    }
    
    @IBAction func boldAction(_ sender: UIButton) {
    }
    @IBAction func underlineAction(_ sender: UIButton) {
    }
    @IBAction func italicAction(_ sender: UIButton) {
    }
    @IBAction func changeFontAction(_ sender: UIButton) {
        print("change font asd")
    }
    @IBAction func leftAlignAction(_ sender: UIButton) {
    }
    @IBAction func centerAlignAction(_ sender: UIButton) {
    }
    @IBAction func rightCenterAction(_ sender: UIButton) {
    }
}
