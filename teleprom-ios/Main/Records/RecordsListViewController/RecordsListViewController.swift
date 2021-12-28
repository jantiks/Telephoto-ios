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
    
    private var interItemSpace: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCells()
        setDelegates()
        initUI()
        
        LanguageManager.shared.addReloadCommands([DoneCommand({ [weak self] in
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
        selectButton.setTitleColor(.telepromPink, for: .normal)
        reloadData()
        
        let flow = recordsCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flow.sectionInset = UIEdgeInsets(top: 0, left: interItemSpace, bottom: 0, right: interItemSpace)
    }
    
    private func reloadData() {
        recordsCollectionView.reloadData()
        titleLabel.text = "main.tab.new.records".localized
        selectButton.setTitle("records.select.button.title".localized, for: .normal)
    }
    
    @IBAction func selectAction(_ sender: UIButton) {
    }
}

extension RecordsListViewController: UICollectionViewDelegate {
    
}

extension RecordsListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if indexPath.item == 0 {
//            return CGSize(width: view.bounds.width / 2 - view.bounds.width * 0.1, height: 150)
//        }
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
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addCell", for: indexPath) as? AddRecordCell else { fatalError("couldn't load addCell") }
            cell.cornerRadius = 20
            cell.backgroundColor = .tableBgGray
            cell.addRecordCommand = DoneCommand({ [weak self] in
                let vc = RecordViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            })
            return cell
            
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recordCell", for: indexPath) as? RecordCell else { fatalError("couldn't load recordCell") }
            let record = Record()
            record.text = "Hello sdsdsdsd sddfdfdfdf sdsdsdsdsd dsddfdfdfdf sdsdsdsdsd dfdfdfdf sdsdsdsdsd dfdfdfdf sdsdsdsdsdd fdfdfdf sdsdsdsds ddfd fdfdf sdsdsdsdsdd fdfdfdf"
            record.title = "Hello record dfdf dfdfdf dfdfdf dfd fd fdfdf"
            cell.cornerRadius = 20
            cell.backgroundColor = .tableBgGray
            cell.setRecord(record)
            
            return cell
        }
    }
}
