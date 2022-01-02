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
    @IBOutlet private weak var selectFontTableView: UITableView!
    @IBOutlet private weak var actionViews: UIStackView!
    @IBOutlet private weak var underlineButton: UIButton!
    @IBOutlet private weak var bgTapButton: UIButton!
    
    private weak var textView: UITextView?
    private var selectionFontTableBg: VisualEffectWithIntensityView?
    private let selectFontTableData = [20, 24, 28, 36, 42, 48, 56, 62, 68, 74]
    private var currentFont: UIFont = UIFont.systemFont(ofSize: 24)
    
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
        setSelectFontTableView()
        setActionViewsBg()
        setSelectFontTableBg()
    }
    
    func setTextView(_ textView: UITextView) {
        self.textView = textView
    }
    
    func textViewDidChange() {
        currentFont = textView?.typingAttributes[NSAttributedString.Key.font] as? UIFont ?? UIFont.systemFont(ofSize: 24)
        boldButton.isSelected = currentFont.fontName == ".SFUI-Semibold"
        italicButton.isSelected = currentFont.fontName == ".SFUI-RegularItalic"
        underlineButton.isSelected = textView?.typingAttributes[NSAttributedString.Key.underlineStyle] as? Int == NSUnderlineStyle.single.rawValue
        changeFontButton.setTitle("\(Int(currentFont.pointSize))", for: .normal)
    }
 
    private func setHeightConstraint(_ constant: CGFloat) {
        constraints.first(where: { $0.firstAttribute == .height })?.constant = constant
    }
    
    private func setActionViewsBg() {
        let effectView = VisualEffectWithIntensityView(effect:  UIBlurEffect(style: .light), intensity: 0.4)
        insertSubview(effectView, at: 0)
        effectView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: effectView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: effectView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: effectView, attribute: .top, relatedBy: .equal, toItem: actionViews, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: effectView, attribute: .bottom, relatedBy: .equal, toItem: actionViews, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
    
    private func setSelectFontTableBg() {
        selectionFontTableBg = VisualEffectWithIntensityView(effect:  UIBlurEffect(style: .light), intensity: 0.4)
        insertSubview(selectionFontTableBg!, at: 0)
        selectionFontTableBg?.cornerRadius = selectFontTableView.cornerRadius
        selectionFontTableBg?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: selectionFontTableBg!, attribute: .leading, relatedBy: .equal, toItem: selectFontTableView, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: selectionFontTableBg!, attribute: .trailing, relatedBy: .equal, toItem: selectFontTableView, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: selectionFontTableBg!, attribute: .top, relatedBy: .equal, toItem: selectFontTableView, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: selectionFontTableBg!, attribute: .bottom, relatedBy: .equal, toItem: selectFontTableView, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
        
        selectionFontTableBg?.isHidden = selectFontTableView.isHidden
    }
    
    private func setSelectFontTableView() {
        selectFontTableView.delegate = self
        selectFontTableView.dataSource = self
        selectFontTableView.register(UITableViewCell.self, forCellReuseIdentifier: "selectFontCell")
        selectFontTableView.showsVerticalScrollIndicator = false
        selectFontTableView.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
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
                
        if let selectedRange = textView?.selectedRange, selectedRange.length != 0 {
            sender.isSelected ?
            textView?.textStorage.addAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: textView!.font!.pointSize)], range: selectedRange) : textView?.textStorage.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: textView!.font!.pointSize)], range: selectedRange)
        } else {
            sender.isSelected ?
            setTypingAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: textView!.font!.pointSize)]) : setTypingAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: textView!.font!.pointSize)])
        }
        
        currentFont = sender.isSelected ? UIFont.boldSystemFont(ofSize: textView!.font!.pointSize) : UIFont.systemFont(ofSize: textView!.font!.pointSize)
    }
    
    @IBAction func underlineAction(_ sender: UIButton) {
        sender.isSelected.toggle()
        
        if let selectedRange = textView?.selectedRange, selectedRange.length != 0 {
            sender.isSelected ?
            textView?.textStorage.addAttributes([NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue], range: selectedRange) :
            textView?.textStorage.removeAttribute(NSAttributedString.Key.underlineStyle, range: selectedRange)
        } else {
            if sender.isSelected {
                setTypingAttributes([NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue])
            } else {
                textView?.typingAttributes[NSAttributedString.Key.underlineStyle] = nil
            }
        }
    }
    
    @IBAction func italicAction(_ sender: UIButton) {
        sender.isSelected.toggle()
        boldButton.isSelected = false
        
        if let selectedRange = textView?.selectedRange, selectedRange.length != 0 {
            sender.isSelected ?
            textView?.textStorage.addAttributes([NSAttributedString.Key.font: UIFont.italicSystemFont(ofSize: textView!.font!.pointSize)], range: selectedRange) : textView?.textStorage.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: textView!.font!.pointSize)], range: selectedRange)
        } else {
            sender.isSelected ?
            setTypingAttributes([NSAttributedString.Key.font: UIFont.italicSystemFont(ofSize: textView!.font!.pointSize)]) : setTypingAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: textView!.font!.pointSize)])
        }
        
        currentFont = sender.isSelected ? UIFont.italicSystemFont(ofSize: textView!.font!.pointSize) : UIFont.systemFont(ofSize: textView!.font!.pointSize)
    }
    
    @IBAction func changeFontAction(_ sender: UIButton) {
        sender.isSelected.toggle()
        
        selectFontTableView.isHidden = !sender.isSelected
        selectionFontTableBg?.isHidden = selectFontTableView.isHidden
        setHeightConstraint(selectFontTableView.isHidden ? 60 : 220)
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
    
    @IBAction func hideSelectFontTableAction(_ sender: UIButton) {
        selectFontTableView.isHidden = true
        selectionFontTableBg?.isHidden = true
        setHeightConstraint(60)
        changeFontButton.isSelected = false
    }
}

extension TextModifierView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let fontSize = selectFontTableData[indexPath.row]
        
        if let selectedRange = textView?.selectedRange, selectedRange.length != 0 {
            textView?.textStorage.addAttributes([NSAttributedString.Key.font: currentFont.withSize(CGFloat(fontSize))], range: selectedRange)
        } else {
            setTypingAttributes([NSAttributedString.Key.font: currentFont.withSize(CGFloat(fontSize))])
        }
        
        changeFontButton.setTitle("\(fontSize)", for: .normal)
    }
}

extension TextModifierView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectFontTableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "selectFontCell") else { fatalError() }
        cell.backgroundColor = .clear
        cell.textLabel?.text = "\(selectFontTableData[indexPath.row])"
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.font = cell.textLabel?.font.withSize(19)
        cell.textLabel?.textColor = .white
        cell.selectedBackgroundView?.tintColor = .red
        cell.selectionStyle = .none
        
        return cell
    }
}
