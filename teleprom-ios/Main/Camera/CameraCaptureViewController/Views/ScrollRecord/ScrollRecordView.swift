//
//  ScrollRecordView.swift
//  teleprom-ios
//
//  Created by Tigran Arsenyan on 1/9/22.
//

import UIKit

class ScrollRecordView: BaseCustomView {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var textViewContainer: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var expandButton: UIButton!
    
    private var record: Record?
    
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
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        guard let touchPoint = (event?.allTouches?.first?.location(in: self)) else { return }
        print("touch point \(touchPoint)")
//        let frameForTouch = CGRect(x: sliderButton.frame.origin.x - 25, y: sliderButton.frame.origin.y, width: sliderButton.frame.width + 25, height: sliderButton.frame.height)
//
//        if frameForTouch.contains(touchPoint) {
//            isDragging = true
//            playerView?.pause()
//        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        guard let touchPoint = event?.allTouches?.first?.location(in: self) else { return }
                
//        if (isDragging) {
//            updateSliderPosition(touchPoint.x)
//        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
//        if isDragging {
//            playerView?.play()
//            isDragging = false
//        }
    }
    
    func setBackgroundOpacity(_ opacity: Double) {
        textViewContainer.backgroundColor = UIColor.darkGray.withAlphaComponent(opacity)
    }
    
    private func recordSelectedAction(_ record: Record) {
        self.record = record
        
        textView.attributedText = record.getText()
        selectButton.isHidden = true
    }
    
    @IBAction func selectAction(_ sender: UIButton) {
        let vc = SelectRecordViewController()
        vc.recordSelected = recordSelectedAction(_:)
        AppDelegate.getController()?.present(vc, animated: true)
    }
}
