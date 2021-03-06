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
    @IBOutlet private weak var bottomSafeAreaView: UIView!
    @IBOutlet private weak var selectionActionsViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var dublicateButton: UIButton!
    @IBOutlet private weak var deletButton: UIButton!
    @IBOutlet private weak var subscribeButton: UIButton!
    @IBOutlet private weak var subscriptionView: UIView!
    
    private var recordsConfigs: [RecordCellConfig] = []
    private var mode: RecordsListMode = .add
    private var interItemSpace: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCells()
        setDelegates()
        initUI()
        checkSubscriptionState()
        setReloadCommands()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    private func setReloadCommands() {
        LanguageManager.shared.addReloadCommands([DoneCommand({ [weak self] in
            self?.reloadData()
        })])
        
        RecordDataProvider.shared.addReloadCommands([DoneCommand({ [weak self] in
            self?.reloadData()
        })])
        
        IAPManager.shared.addReloadCommands([DoneCommand({ [weak self]  in
            self?.subscriptionView.isHidden = true
        })])
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
        bottomSafeAreaView.backgroundColor = .tabBarGray
        selectButton.setTitleColor(.telepromPink.withAlphaComponent(0.3), for: .disabled)
        
        updateViewsForCurrentSelectionMode()
        
        let flow = recordsCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flow.sectionInset = UIEdgeInsets(top: 0, left: interItemSpace, bottom: 0, right: interItemSpace)
    }
    
    private func checkSubscriptionState() {
        subscriptionView.isHidden = IAPManager.shared.getLastSubscribedState()
        IAPManager.shared.checkPermissions { [weak self] hasPermisison in
            self?.subscriptionView.isHidden = hasPermisison
        }
    }
    
    private func reloadData() {
        recordsConfigs = RecordDataProvider.shared.getAll().reversed().map({ RecordCellConfig(record: $0, mode: mode) })
        recordsCollectionView.reloadData()
        languageConfigure()
        
        selectButton.isEnabled = !recordsConfigs.isEmpty
    }
    
    private func setSelectionMode(_ mode: RecordsListMode) {
        self.mode = mode
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
        let selectButtonTitle = mode == .add ? "records.mode.select.button.title".localized : "records.mode.cancel.button.title".localized
        let dublicateButtonTitle = "records.dublicate".localized
        let deleteButtonTitle = "records.delete.all".localized
        let title = mode == .add ? "main.tab.records.your.records".localized : "main.tab.records.select.record".localized
        
        subscribeButton.setTitle("continue.with.premium".localized, for: .normal)
        selectButton.setTitle(selectButtonTitle, for: .normal)
        dublicateButton.setTitle(dublicateButtonTitle, for: .normal)
        deletButton.setTitle(deleteButtonTitle, for: .normal)
        deletButton.alignVertical()
        dublicateButton.alignVertical()
        
        titleLabel.text = title
    }
    
    @IBAction func selectAction(_ sender: UIButton) {
        let newMode = self.mode == .add ? RecordsListMode.select : RecordsListMode.add
        setSelectionMode(newMode)
    }
    
    @IBAction func subscribeAction(_ sender: UIButton) {
        let vc = SubscriptionViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
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
            if let records = self?.recordsConfigs.filter({ $0.isSelected }) {
                if records.isEmpty {
                    // if no records is selected, delete all records
                    RecordDataProvider.shared.deleteAll()
                    self?.setSelectionMode(.add)
                    return
                }
                
                records.forEach({ RecordDataProvider.shared.delete($0.record) })
                
                if self?.recordsConfigs.isEmpty == true {
                    self?.setSelectionMode(.add)
                }
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
                
                self.recordsConfigs[indexPath.item].isSelected.toggle()
            })
            
            return cell
        }
    }
}
