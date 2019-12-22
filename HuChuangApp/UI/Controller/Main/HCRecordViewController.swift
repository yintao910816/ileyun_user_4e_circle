//
//  HCRecordViewController.swift
//  HuChuangApp
//
//  Created by yintao on 2019/9/28.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit

class HCRecordViewController: BaseViewController {
    
    private var viewModel: HCRecordViewModel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func setupUI() {
        collectionView.register(HCRecordUserInfoReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: HCRecordUserInfoReusableView_identifier)
        collectionView.register(HCRecordSuggestReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: HCRecordSuggestReusableView_identifier)
        collectionView.register(HCExchangeReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: HCExchangeReusableView_identifier)
        collectionView.register(UINib.init(nibName: "HCRecordActionItemCell", bundle: nil),
                                forCellWithReuseIdentifier: HCRecordActionItemCell_identifier)
        collectionView.register(HCCurveCell.self, forCellWithReuseIdentifier: HCCurveCell_identifier)
    }
    
    override func rxBind() {
        viewModel = HCRecordViewModel()
//        viewModel.listDatasource.asDriver()
//            .drive(onNext: { [weak self] in self?.contentView.reloadData(data: $0) })
//            .disposed(by: disposeBag)
        
        viewModel.reloadUISubject
            .subscribe(onNext: { [weak self] data in
                self?.collectionView.reloadData()
            })
            .disposed(by: disposeBag)

        viewModel.reloadSubject.onNext(Void())
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
//        contentView.frame = view.bounds
    }
}

extension HCRecordViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.datasource[section].count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.datasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let model = viewModel.datasource[indexPath.section][indexPath.row]
        return .init(width: model.width, height: model.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = viewModel.datasource[indexPath.section][indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: model.cellIdentifier, for: indexPath) as! HCBaseRecordCell
        cell.model = model
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let identifier = viewModel.supplementaryIdentifier(for: indexPath.section)
            
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                         withReuseIdentifier: identifier,
                                                                         for: indexPath)
            
            if identifier == HCRecordUserInfoReusableView_identifier {
                (header as! HCRecordUserInfoReusableView).exchangeCallBack = { [weak self] in
                    self?.viewModel.exchangeUISubject.onNext(Void())
                }
            }else if identifier == HCRecordSuggestReusableView_identifier {

            }else if identifier == HCExchangeReusableView_identifier {
                (header as! HCExchangeReusableView).exchangeCallBack = { [weak self] in
                    self?.viewModel.exchangeUISubject.onNext(Void())
                }
            }else {
                return UICollectionReusableView()
            }
            
            return header
        }
        
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return viewModel.referenceSize(forHeader: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return viewModel.inset(section)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return viewModel.minimumLineSpacing(section)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return viewModel.minimumInteritemSpacing(section)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = viewModel.datasource[indexPath.section][indexPath.row]
        if let actionModel = model as? HCCellActionItem {
            if actionModel.opType == .temperature {
                let picker = HCPickerController()
                picker.titleDes = "基础体温"
                picker.sectionModel = HCPickerSectionData.createTemperature()
                addChildViewController(picker)

                picker.finishSelected = { [weak self] content in
                    self?.viewModel.commitChangeSubject.onNext((actionModel.opType, content))
                }
            }else {
                let datePicker = HCDatePickerViewController()
                datePicker.titleDes = actionModel.title
                addChildViewController(datePicker)

                datePicker.finishSelected = { [weak self] date in
                    self?.viewModel.commitChangeSubject.onNext((actionModel.opType, date))
                }
            }
        }
    }
}
