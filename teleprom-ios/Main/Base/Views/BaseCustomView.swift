//
//  BaseCustomView.swift
//  teleprom-ios
//
//  Created by Tigran Arsenyan on 12/24/21.
//

import UIKit

class BaseCustomView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle(for: BaseCustomView.self).loadNibNamed(getXibName(), owner: self, options: nil)
        getContentView().fixInView(self)
    }
    
    func getContentView() -> UIView {
        return UIView(frame: .init())
    }
    
    func getXibName() -> String {
        return ""
    }
    
    deinit {
        print("deinit \(self)")
    }
}

extension UIView {
    
    func fixInView(_ container: UIView) -> Void{
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        container.addSubview(self);
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
}
