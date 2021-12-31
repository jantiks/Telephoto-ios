//
//  HelpViewController.swift
//  teleprom-ios
//
//  Created by Tigran Arsenyan on 12/26/21.
//

import UIKit

class HelpViewController: BaseViewController {

    @IBOutlet private weak var explanationLabel: UILabel!
    @IBOutlet private weak var copyButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func initUI() {
        copyButton.setTitleColor(.telepromPink, for: .normal)
        copyButton.setTitle("settings.help.copy".localized, for: .normal)
        explanationLabel.text = "settings.help.explanation".localized
        title = "settings.help".localized
    }
    
    @IBAction func copyAction(_ sender: UIButton) {
        UIPasteboard.general.string = "Teleporter_punch@gmail.com"
        
        let label = UILabel(frame: CGRect(x: view.bounds.width / 2 - 80, y: view.bounds.height / 2 - 100, width: 160, height: 50))
        label.backgroundColor = .tableBgGray
        label.text = "settings.help.copied".localized
        label.textAlignment = .center
        label.textColor = .white
        label.cornerRadius = 10
                
        view.addSubview(label)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak label] in
            label?.removeFromSuperview()
        }
    }
}
