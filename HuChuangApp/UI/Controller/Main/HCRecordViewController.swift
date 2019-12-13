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
        return section == 0 ? 1 : viewModel.cellItemDatasource.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let model = viewModel.cellItemDatasource[indexPath.row]
        if indexPath.section == 1 {
            return .init(width: model.width, height: model.height)
        }
        
        return .init(width: collectionView.width, height: HCCurveCell_height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HCRecordActionItemCell_identifier, for: indexPath) as! HCRecordActionItemCell
            cell.model = viewModel.cellItemDatasource[indexPath.row]
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HCCurveCell_identifier, for: indexPath) as! HCCurveCell
        cell.setData(probabilityDatas: viewModel.prepareProbabilityDatas, titmesDatas: viewModel.prepareTimesDatas)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            if indexPath.section == 0 {
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                             withReuseIdentifier: HCRecordUserInfoReusableView_identifier,
                                                                             for: indexPath)
                return header
            }else if indexPath.section == 1 {
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                             withReuseIdentifier: HCRecordSuggestReusableView_identifier,
                                                                             for: indexPath)
                return header
            }
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return section == 0 ? .init(width: collectionView.width, height: HCRecordUserInfoReusableView_height) : .init(width: collectionView.width, height: HCRecordSuggestReusableView_height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return section == 0 ? .init(top: 0, left: 0, bottom: 0, right: 0) : .init(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return section == 0 ? 0 : 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return section == 0 ? 0 : 30
    }
}
