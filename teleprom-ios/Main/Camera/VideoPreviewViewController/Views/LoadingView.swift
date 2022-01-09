//
//  LoadingView.swift
//  teleprom-ios
//
//  Created by Tigran Arsenyan on 1/9/22.
//

import UIKit

class LoadingView: BaseCustomView {
    
    @IBOutlet weak var conetentView: UIView!
    @IBOutlet weak var loadingStackView: UIStackView!
    @IBOutlet weak var doneStackView: UIStackView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var doneLabel: UILabel!
    
    override func getContentView() -> UIView {
        return conetentView
    }
    
    override func getXibName() -> String {
        return "\(LoadingView.self)"
    }
    
    override func commonInit() {
        super.commonInit()
        
        doneStackView.isHidden = true
        loadingLabel.text = "loading.text".localized
        doneLabel.text = "done.text".localized
        isHidden = true
    }
    
    func startLoading() {
        isHidden = false
        doneStackView.isHidden = true
        loadingStackView.isHidden = false
        
        indicatorView.startAnimating()
    }
    
    func stopLoading() {
        loadingStackView.isHidden = true
        doneStackView.isHidden = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.isHidden = true
        }
    }
}
