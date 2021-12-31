//
//  RecordsViewController.swift
//  teleprom-ios
//
//  Created by Tigran Arsenyan on 12/27/21.
//

import UIKit

class RecordsListViewController: BaseViewController {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var recordsCollectionView: UICollectionView!
    @IBOutlet private weak var selectButton: UIButton!
    @IBOutlet private weak var selectionActionsView: UIView!

    
    private var recordsConfigs: [RecordCellConfig] = []
    private var mode: RecordsListMode = .add
    private var interItemSpace: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCells()
        setDelegates()
        initUI()
        
        LanguageManager.shared.addReloadCommands([DoneCommand({ [weak self] in
            self?.reloadData()
        })])
        
        RecordDataProvider.shared.addReloadCommands([DoneCommand({ [weak self] in
            self?.reloadData()
        })])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }

    private func registerCells() {
        recordsCollectionView.register(UINib(nibName: "\(AddRecordCell.self)", bundle: nil), forCellWithReuseIdentifier: "addCell")
        recordsCollectionView.register(UINib(nibName: "\(RecordCell.self)", bundle: nil), forCellWithReuseIdentifier: "recordCell")
    }
    
    private func setDelegates() {
        recordsCollectionView.delegate = self
        recordsCollectionView.dataSource = self
    }
    
    private func initUI() {
        interItemSpace = view.bounds.width * 0.05
        selectionActionsView.backgroundColor = .tabBarGray
        updateViewsForCurrentSelectionMode()
        
        let flow = recordsCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flow.sectionInset = UIEdgeInsets(top: 0, left: interItemSpace, bottom: 0, right: interItemSpace)
    }
    
    private func reloadData() {
        recordsConfigs = RecordDataProvider.shared.getAll().reversed().map({ RecordCellConfig(record: $0, mode: mode) })
        recordsCollectionView.reloadData()
        languageConfigure()
    }
    
    private func toggleSelectionMode() {
        mode.toggle()
        updateViewsForCurrentSelectionMode()
    }
    
    private func updateViewsForCurrentSelectionMode() {
        selectButton.setTitleColor(mode == .add ? .telepromPink : .white, for: .normal)
        selectionActionsView.isHidden = mode == .select ? false : true
        tabBarController?.tabBar.isHidden = !selectionActionsView.isHidden
        
        reloadData()
        languageConfigure()
    }
    
    private func languageConfigure() {
        let buttonTitle = mode == .add ? "records.mode.select.button.title".localized : "records.mode.cancel.button.title".localized
        let title = mode == .add ? "main.tab.records.your.records".localized : "main.tab.records.select.record".localized
        
        selectButton.setTitle(buttonTitle, for: .normal)
        titleLabel.text = title
    }
    
    @IBAction func selectAction(_ sender: UIButton) {
        toggleSelectionMode()
    }
    
    @IBAction func dublicateAction(_ sender: UIButton) {
        guard let record = recordsConfigs.first(where: { $0.isSelected })?.record else { return }
        
        let dublicatedRecord = Record().pull(from: record)
        dublicatedRecord.setTitle("record.dublicate".localized + " " + (dublicatedRecord.getTitle() ?? ""))
        RecordDataProvider.shared.add(dublicatedRecord)
    }
    
    @IBAction func deleteAction(_ sender: UIButton) {
        let alertTitle = recordsConfigs.contains(where: { $0.isSelected }) ? "record.delete.popup.single".localized : "record.delete.popup.all".localized
        let deleteTitle = recordsConfigs.contains(where: { $0.isSelected }) ? "alert.delete".localized : "alert.delete.all".localized
        
        let ac = UIAlertController(title: alertTitle, message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "alert.cancel".localized, style: .default, handler: nil))
        ac.addAction(UIAlertAction(title: deleteTitle, style: .destructive, handler: { [weak self] action in
            if let record = self?.recordsConfigs.first(where: { $0.isSelected })?.record {
                RecordDataProvider.shared.delete(record)
            } else {
                RecordDataProvider.shared.deleteAll()
            }
        }))
        
        present(ac, animated: true)
    }
}

extension RecordsListViewController: UICollectionViewDelegate {
    
}

extension RecordsListViewController: UICollectionViewDelegateFlowLayout {
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

extension RecordsListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mode == .add ? recordsConfigs.count + 1 : recordsConfigs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if mode == .add {
            if indexPath.item == 0 {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addCell", for: indexPath) as? AddRecordCell else { fatalError("couldn't load addCell") }
                
                return cell
                
            } else {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recordCell", for: indexPath) as? RecordCell else { fatalError("couldn't load recordCell") }
                
                cell.configure(recordsConfigs[indexPath.item - 1])
                
                return cell
            }
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recordCell", for: indexPath) as? RecordCell else { fatalError("couldn't load recordCell") }

            cell.configure(recordsConfigs[indexPath.item])
            cell.setSelectedCommand = DoneCommand({ [weak self] in
                guard let self = self else { return }
                guard let selectedCellConfigIndex = self.recordsConfigs.firstIndex(where: { $0.isSelected }), selectedCellConfigIndex != indexPath.item else { return }

                self.recordsConfigs[selectedCellConfigIndex].isSelected = false
                self.recordsCollectionView.reloadItems(at: [IndexPath(item: selectedCellConfigIndex, section: 0)])
            })
            
            return cell
        }
    }
}
