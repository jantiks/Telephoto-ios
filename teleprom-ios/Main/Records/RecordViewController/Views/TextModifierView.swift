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
    @IBOutlet private var alignmentButtons: [UIButton]!
    @IBOutlet private weak var boldButton: UIButton!
    @IBOutlet private weak var italicButton: UIButton!
    
    private weak var textView: UITextView?
    
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
        alignmentButtons.first?.isSelected = true
    }
    
    func setTextView(_ textView: UITextView) {
        self.textView = textView
    }
    
    private func setAlignmentButtonSelected(selected button: UIButton) {
        alignmentButtons.forEach({ $0.isSelected = false })
        button.isSelected = true
    }
    
    private func setTextAlignment(_ alignment: NSTextAlignment) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment
        
        textView?.textStorage.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, textView!.text.count))
        textView?.typingAttributes[NSAttributedString.Key.paragraphStyle] = paragraphStyle
    }
    
    private func setTypingAttributes(_ attributes: [NSAttributedString.Key: Any]) {
        for key in attributes.keys {
            if let value = attributes[key] {
                textView?.typingAttributes[key] = value
            }
        }
    }
        
    @IBAction func boldAction(_ sender: UIButton) {
        sender.isSelected.toggle()
        italicButton.isSelected = false
        
        sender.isSelected ?
        setTypingAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: textView!.font!.pointSize)]) : setTypingAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: textView!.font!.pointSize)])
    }
    
    @IBAction func underlineAction(_ sender: UIButton) {
        sender.isSelected.toggle()
        
        if sender.isSelected {
            setTypingAttributes([NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue])
        } else {
            textView?.typingAttributes[NSAttributedString.Key.underlineStyle] = nil
        }
    }
    
    @IBAction func italicAction(_ sender: UIButton) {
        sender.isSelected.toggle()
        boldButton.isSelected = false
        
        sender.isSelected ?
        setTypingAttributes([NSAttributedString.Key.font: UIFont.italicSystemFont(ofSize: textView!.font!.pointSize)]) : setTypingAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: textView!.font!.pointSize)])
    }
    
    @IBAction func changeFontAction(_ sender: UIButton) {
        print("change font asd")
    }
    
    @IBAction func leftAlignAction(_ sender: UIButton) {
        setAlignmentButtonSelected(selected: sender)
        setTextAlignment(.left)
    }
    
    @IBAction func centerAlignAction(_ sender: UIButton) {
        setAlignmentButtonSelected(selected: sender)
        setTextAlignment(.center)
    }
    
    @IBAction func rightCenterAction(_ sender: UIButton) {
        setAlignmentButtonSelected(selected: sender)
        setTextAlignment(.right)
    }
}
