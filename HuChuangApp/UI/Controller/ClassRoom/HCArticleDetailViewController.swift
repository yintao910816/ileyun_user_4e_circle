//
//  HCArticleDetailViewController.swift
//  HuChuangApp
//
//  Created by yintao on 2019/12/19.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit

class HCArticleDetailViewController: BaseWebViewController {

    private var viewModel: HCArticleDetailViewModel!
    private var articleModel: HCArticleItemModel!
    
    private var storeButton: UIButton!
    private var shareButton: UIButton!

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        navBarColor = HC_MAIN_COLOR
        (navigationController as? BaseNavigationController)?.backItemInterface = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupUI() {
        super.setupUI()
        
        title = articleModel.title
        
        storeButton = UIButton()
        storeButton.setImage(UIImage(named: "button_collect_sel"), for: .selected)
        storeButton.setImage(UIImage(named: "button_collect_unsel"), for: .normal)
        storeButton.titleLabel?.font = .font(fontSize: 10)
        storeButton.imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 10)
        storeButton.showsTouchWhenHighlighted = false
        storeButton.sizeToFit()
        
        shareButton = UIButton()
        shareButton.setImage(UIImage(named: "button_share"), for: .normal)
        shareButton.sizeToFit()

        navigationItem.rightBarButtonItems = [UIBarButtonItem.init(customView: shareButton),
                                              UIBarButtonItem.init(customView: storeButton)]
    }
    
    override func rxBind() {
        super.rxBind()
        
        let storeDriver = storeButton.rx.tap.asDriver()
            .map{ [unowned self] in !self.storeButton.isSelected }
        
        viewModel = HCArticleDetailViewModel.init(articleModel: articleModel,
                                                  tap: (storeDriver: storeDriver,
                                                        shareDriver: shareButton.rx.tap.asDriver()))
        
        viewModel.storeEnable.asDriver()
            .drive(storeButton.rx.enabled)
            .disposed(by: disposeBag)
        
        viewModel.articleStatusObser.asDriver()
            .skip(0)
            .drive(onNext: { [weak self] data in
                self?.storeButton.isSelected = data.status
                self?.storeButton.setTitle("\(data.store)", for: .normal)
            })
            .disposed(by: disposeBag)
        
        viewModel.reloadSubject.onNext(Void())
    }
    
    override func prepare(parameters: [String : Any]?) {
        articleModel = (parameters!["model"] as! HCArticleItemModel)

        super.prepare(parameters: ["url": articleModel.hrefUrl])
    }
}

extension HCArticleDetailViewController {
    
    public class func preprare(model: HCArticleItemModel) ->[String: HCArticleItemModel] {
        return ["model": model]
    }
}
