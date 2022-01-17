//
//  ScrollRecordView.swift
//  teleprom-ios
//
//  Created by Tigran Arsenyan on 1/9/22.
//

import UIKit

class ScrollRecordView: BaseCustomView, UITextViewDelegate {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var textViewContainer: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var selectButton: UIButton!
    
    private var record: Record?
    private var scrollingTimer: Timer?
    private var scrollingUnit: Float = 2
    
    override func getContentView() -> UIView {
        return contentView
    }
    
    override func getXibName() -> String {
        return "\(ScrollRecordView.self)"
    }
    
    override func commonInit() {
        super.commonInit()
        
        selectButton.setTitle("main.tab.records.select.record".localized, for: .normal)
        setBackgroundOpacity(0.4)
        textView.delegate = self
    }
    
    func setBackgroundOpacity(_ opacity: Double) {
        textViewContainer.backgroundColor = UIColor.controllerGray.withAlphaComponent(opacity)
    }
    
    func startScrolling() {
        scrollingTimer?.invalidate()
        scrollingTimer = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(scrollTextView), userInfo: nil, repeats: true)
    }
    
    func stopScrolling() {
        scrollingTimer?.invalidate()
    }
    
    func speedScrolling(by: Float) {
        scrollingUnit = by
    }
    
    private func recordSelectedAction(_ record: Record) {
        self.record = record
        
        textView.attributedText = record.getText()
        selectButton.isHidden = true
    }
    
    @objc private func scrollTextView() {
        if textView.contentSize.height > textView.contentOffset.y && !textView.text.isEmpty {
            UIView.animate(withDuration: 0.02) { [unowned self] in
                self.textView.contentOffset = CGPoint(x: self.textView.contentOffset.x, y: self.textView.contentOffset.y + CGFloat(self.scrollingUnit))
            }
        }
    }
    
    @IBAction func selectAction(_ sender: UIButton) {
        let vc = SelectRecordViewController()
        vc.recordSelected = recordSelectedAction(_:)
        AppDelegate.getController()?.present(vc, animated: true)
    }
}
