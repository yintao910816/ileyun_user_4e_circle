//
//  HCHomeViewController.swift
//  HuChuangApp
//
//  Created by sw on 02/02/2019.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit
import RxDataSources
import RxCocoa

class HCHomeViewController: BaseViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private var viewModel: HomeViewModel!
    
    private var searchBar: TYSearchBar!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
        if viewModel != nil { viewModel.refreshUnreadPublish.onNext(Void()) }
    }
    
    override func setupUI() {
        if #available(iOS 11, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        }
        
        searchBar = TYSearchBar.init(frame: .init(x: 0, y: 0, width: view.width, height: TYSearchBar.baseHeight))
        searchBar.searchPlaceholder = "搜索症状/疾病/药品/医生/科室"
        searchBar.rightItemIcon = "nav_notice"
        view.addSubview(searchBar)
        
        searchBar.tapInputCallBack = { [unowned self] in
            self.navigationController?.pushViewController(HCSearchViewController(), animated: true)
        }
        
        collectionView.register(UINib.init(nibName: "HCHomeFuncItemCell", bundle: Bundle.main),
                                forCellWithReuseIdentifier: HCHomeFuncItemCell_identifier)
        collectionView.register(UINib.init(nibName: "HCHomeAdvCell", bundle: Bundle.main),
                                forCellWithReuseIdentifier: HCHomeAdvCell_identifier)
        collectionView.register(UINib.init(nibName: "HCHomeConsultingVolumeCell", bundle: Bundle.main),
                                forCellWithReuseIdentifier: HCHomeConsultingVolumeCell_idenfiter)
        collectionView.register(UINib.init(nibName: "HCHomePreparePregnantCell", bundle: Bundle.main),
                                forCellWithReuseIdentifier: HCHomePreparePregnantCell_identifier)
        collectionView.register(UINib.init(nibName: "HCHomeGoodNewsCell", bundle: Bundle.main),
                                forCellWithReuseIdentifier: HCHomeGoodNewsCell_identifier)
        collectionView.register(UINib.init(nibName: "HCHomePregnancyClassroomCell", bundle: Bundle.main),
                                forCellWithReuseIdentifier: HCHomePregnancyClassroomCell_identifier)
        collectionView.register(UINib.init(nibName: "HCHomeBabyTuinaClassroomCell", bundle: Bundle.main),
                                forCellWithReuseIdentifier: HCHomeBabyTuinaClassroomCell_identifier)

        collectionView.register(HCHomeCollectionHeaderReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: HCHomeCollectionHeaderReusableView_identifier)
        collectionView.register(HCHomeConsultingVolumeReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: HCHomeConsultingVolumeReusableView_identifier)
        collectionView.register(HCHomePreparePregnantReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: HCHomePreparePregnantReusableView_identifier)
        collectionView.register(HCHomeGoodNewsReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: HCHomeGoodNewsReusableView_idenfitier)
        collectionView.register(HCHomePregnancyClassroomReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: HCHomePregnancyClassroomReusableView_identifier)
        collectionView.register(HCHomeBabyTuinaClassroomReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: HCHomeBabyTuinaClassroomReusableView_identifier)

        let layout = UICollectionViewFlowLayout.init()
        collectionView.collectionViewLayout = layout
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func rxBind() {
        viewModel = HomeViewModel()
        
        // 需要修改列表刷新逻辑
        viewModel.functionModelsObser.asDriver()
            .drive(onNext: { [weak self] datas in
                self?.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
                
        viewModel.reloadSubject.onNext(Void())
        
        collectionView.rx.contentOffset.asDriver()
            .drive(onNext: { [unowned self] offset in
                let alph = 1 - offset.y / self.searchBar.height
                self.searchBar.alpha = alph < 0 ? 0 : alph
            })
            .disposed(by: disposeBag)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if #available(iOS 11.0, *) {
            searchBar.frame = .init(x: 0, y: 0, width: view.width, height: TYSearchBar.baseHeight + view.safeAreaInsets.top)
            searchBar.safeArea = view.safeAreaInsets
        } else {
            searchBar.frame = .init(x: 0, y: 0, width: view.width, height: TYSearchBar.baseHeight + 20)
            searchBar.safeArea = .init(top: 20, left: 0, bottom: 0, right: 0)
        }
    }
}

extension HCHomeViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            let itemW = (collectionView.width - 20 * 5) / 4.0
            return .init(width: itemW, height: 70)
        case 1:
            return .init(width: collectionView.width - 20 * 2, height: 90)
        case 3:
            let itemW = (collectionView.width - 10 * 3) / 2.0
            return .init(width: itemW, height: 75)
        case 4:
            return .init(width: view.width, height: 140)
        case 5:
            return .init(width: view.width, height: 195)
        case 6:
            return .init(width: view.width, height: HCHomePregnancyClassroomCell.itemHeight)
        case 7:
            return .init(width: (view.width - 30) / 2.0, height: HCHomeBabyTuinaClassroomCell.itemHeight)
        default:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch section {
        case 0:
            return .init(width: view.width, height: view.width * 1935.0 / 2250.0)
        case 2:
            return .init(width: view.width, height: 40)
        case 4:
            return .init(width: view.width, height: 40)
        case 5:
            return .init(width: view.width, height: 40)
        case 6: // 孕柚课堂
            return .init(width: view.width, height: 40)
        case 7: // 婴儿推拿
            return .init(width: view.width, height: 80)
        default:
            return .zero
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return viewModel.functionModelsObser.value.count
        case 1, 4, 5, 6:
            return 1
        case 3:
            return 2
        case 7:
            return 5
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: HCHomeFuncItemCell_identifier, for: indexPath) as! HCHomeFuncItemCell)
            cell.model = viewModel.functionModelsObser.value[indexPath.row]
            return cell
        case 1:
            let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: HCHomeAdvCell_identifier, for: indexPath) as! HCHomeAdvCell)
            return cell
        case 3:
            let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: HCHomeConsultingVolumeCell_idenfiter, for: indexPath) as! HCHomeConsultingVolumeCell)
            return cell
        case 4:
            let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: HCHomePreparePregnantCell_identifier, for: indexPath) as! HCHomePreparePregnantCell)
            return cell
        case 5:
            let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: HCHomeGoodNewsCell_identifier, for: indexPath) as! HCHomeGoodNewsCell)
            return cell
        case 6:
            let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: HCHomePregnancyClassroomCell_identifier, for: indexPath) as! HCHomePregnancyClassroomCell)
            cell.menuDatas = viewModel.pregnancyClassroomData
            return cell
        case 7:
            let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: HCHomeBabyTuinaClassroomCell_identifier, for: indexPath) as! HCHomeBabyTuinaClassroomCell)
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            switch indexPath.section {
            case 0:
                let header = (collectionView.dequeueReusableSupplementaryView(ofKind:  UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: HCHomeCollectionHeaderReusableView_identifier,
                for: indexPath) as! HCHomeCollectionHeaderReusableView)
                
                viewModel.bannerModelObser.asObservable()
                    .bind(to: header.bannerObser)
                    .disposed(by: disposeBag)

                return header
            case 2:
                let header = collectionView.dequeueReusableSupplementaryView(ofKind:  UICollectionView.elementKindSectionHeader,
                                                                             withReuseIdentifier: HCHomeConsultingVolumeReusableView_identifier,
                                                                             for: indexPath)
                return header
            case 4:
                let header = collectionView.dequeueReusableSupplementaryView(ofKind:  UICollectionView.elementKindSectionHeader,
                                                                             withReuseIdentifier: HCHomePreparePregnantReusableView_identifier,
                                                                             for: indexPath)
                return header
            case 5:
                let header = collectionView.dequeueReusableSupplementaryView(ofKind:  UICollectionView.elementKindSectionHeader,
                                                                             withReuseIdentifier: HCHomeGoodNewsReusableView_idenfitier,
                                                                             for: indexPath)
                return header
            case 6:
                let header = collectionView.dequeueReusableSupplementaryView(ofKind:  UICollectionView.elementKindSectionHeader,
                                                                             withReuseIdentifier: HCHomePregnancyClassroomReusableView_identifier,
                                                                             for: indexPath)
                return header
            case 7:
                let header = collectionView.dequeueReusableSupplementaryView(ofKind:  UICollectionView.elementKindSectionHeader,
                                                                             withReuseIdentifier: HCHomeBabyTuinaClassroomReusableView_identifier,
                                                                             for: indexPath)
                return header
            default:
                return UICollectionReusableView()
            }
        }
        
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch section {
        case 0:
            return .init(top: 27, left: 20, bottom: 0, right: 20)
        case 1:
            return .init(top: 20, left: 10, bottom: 10, right: 10)
        case 3:
            return .init(top: 10, left: 10, bottom: 0, right: 10)
        case 4:
            // 备孕建档
            return .init(top: 0, left: 0, bottom: 0, right: 0)
        case 5:
            // 传好孕
            return .init(top: 0, left: 0, bottom: 0, right: 0)
        case 6:
            // 孕柚课堂
            return .init(top: 0, left: 0, bottom: 18, right: 0)
        case 7:
            // 婴儿推拿
            return .init(top: 20, left: 10, bottom: 0, right: 10)
        default:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch section {
        case 0:
            return 19
        case 7:
            return 20
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        switch section {
        case 0, 1:
            return 20
        case 3:
            return 10
        case 7:
            return 10
        default:
            return 0
        }
    }
}
