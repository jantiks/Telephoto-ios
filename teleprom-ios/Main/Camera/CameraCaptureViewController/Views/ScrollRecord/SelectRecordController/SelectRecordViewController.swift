//
//  SelectRecordViewController.swift
//  teleprom-ios
//
//  Created by Tigran Arsenyan on 1/9/22.
//

import UIKit

class SelectRecordViewController: BaseViewController {
    
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var recordsCollectionView: UICollectionView!
    
    private var recordsConfigs: [RecordCellConfig] = []
    private var interItemSpace: CGFloat = 0
    
    var recordSelected: ((Record) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCells()
        setDelegates()
        reloadData()
        initUI()
    }
    
    private func registerCells() {
        recordsCollectionView.register(UINib(nibName: "\(RecordCell.self)", bundle: nil), forCellWithReuseIdentifier: "recordCell")
    }
    
    private func setDelegates() {
        recordsCollectionView.delegate = self
        recordsCollectionView.dataSource = self
    }
    
    private func reloadData() {
        recordsConfigs = RecordDataProvider.shared.getAll().reversed().map({ RecordCellConfig(record: $0, mode: .select) })
        recordsCollectionView.reloadData()
        languageConfigure()
    }
    
    private func initUI() {
        interItemSpace = view.bounds.width * 0.05
        
        languageConfigure()
        
        let flow = recordsCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flow.sectionInset = UIEdgeInsets(top: 0, left: interItemSpace, bottom: 0, right: interItemSpace)
    }
    
    private func languageConfigure() {
        titleLabel.text =  "main.tab.records.your.records".localized
        setSelectButtonText()
    }
    
    private func setSelectButtonText() {
        print("select button text \(hasSelectedRecord())")
        if hasSelectedRecord() {
            let selectButtonTitle = "records.mode.select.button.title".localized
            selectButton.setTitle(selectButtonTitle, for: .normal)
            selectButton.setTitleColor(.telepromPink, for: .normal)
        } else {
            let selectButtonTitle = "records.mode.cancel.button.title".localized
            selectButton.setTitle(selectButtonTitle, for: .normal)
            selectButton.setTitleColor(.white, for: .normal)
        }
    }
    
    private func hasSelectedRecord() -> Bool {
        return recordsConfigs.contains(where: { $0.isSelected == true })
    }
    
    @IBAction func selectCancelAction(_ sender: UIButton) {
        if hasSelectedRecord() {
            guard let record = recordsConfigs.first(where: { $0.isSelected == true }) else { return }
            recordSelected?(record.record)
            dismiss(animated: true)
        } else {
            dismiss(animated: true)
        }
    }
}


extension SelectRecordViewController: UICollectionViewDelegate {
    
}

extension SelectRecordViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.bounds.width / 2 - interItemSpace * 1.5
        return CGSize(width: width, height: width * 1.2)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return interItemSpace / 2
    }

    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return interItemSpace
    }
}

extension SelectRecordViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recordsConfigs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recordCell", for: indexPath) as? RecordCell else { fatalError("couldn't load recordCell") }
        
        cell.configure(recordsConfigs[indexPath.item])
        cell.setSelectedCommand = DoneCommand({ [weak self] in
            guard let self = self else { return }
            if let selectedCellConfigIndex = self.recordsConfigs.firstIndex(where: { $0.isSelected }), selectedCellConfigIndex != indexPath.item {
                self.recordsConfigs[selectedCellConfigIndex].isSelected = false
                self.recordsCollectionView.reloadItems(at: [IndexPath(item: selectedCellConfigIndex, section: 0)])
            }
            
            self.recordsConfigs[indexPath.item].isSelected.toggle()
            self.setSelectButtonText()
        })
        
        return cell
    }
}
