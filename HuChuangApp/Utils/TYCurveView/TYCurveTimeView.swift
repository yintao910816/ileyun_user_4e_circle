//
//  TYCurveTimeView.swift
//  HuChuangApp
//
//  Created by sw on 2019/12/21.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit

class TYCurveTimeView: UIView {

    private var collectionView: UICollectionView!
    
    public var itemSize: CGSize = .zero
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupUI()
    }
    
    public var itemModels: [TYLineItemModel] = [] {
        didSet {
            var itemCount: Int = 0
            for pointItem in itemModels {
                itemCount += pointItem.pointDatas.count
            }
            
//            itemSize = .init(width: width / CGFloat(itemCount), height: height)
            
            collectionView.reloadData()
        }
    }
    
    private func setupUI() {
        let layout = UICollectionViewFlowLayout.init()
        layout.sectionInset = .zero
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        collectionView = UICollectionView.init(frame: bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        addSubview(collectionView)
        
        collectionView.register(TYCurveTimeCell.self, forCellWithReuseIdentifier: "TYCurveTimeCell")
    }
    
    private func calculateIdx(indexPath: IndexPath) ->Int {
        var count: Int = indexPath.row + 1
        if indexPath.section > 0 {
            for section in 0..<indexPath.section {
                count += itemModels[section].pointDatas.count
            }
        }
        return count
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        collectionView.frame = bounds
    }
}

extension TYCurveTimeView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return itemModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        itemModels[section].pointDatas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TYCurveTimeCell", for: indexPath) as! TYCurveTimeCell
        cell.configData(model: itemModels[indexPath.section].pointDatas[indexPath.row],
                        idx: calculateIdx(indexPath: indexPath))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return itemSize
    }
}

class TYCurveTimeCell: UICollectionViewCell {
    
    private var contentLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentLabel = UILabel.init(frame: bounds)
        contentLabel.textAlignment = .center
        contentLabel.font = .font(fontSize: 12)
        contentLabel.numberOfLines = 2
        contentLabel.textColor = RGB(153, 153, 153)
        addSubview(contentLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configData(model: TYPointItemModel, idx: Int) {
        contentLabel.text = "\(model.time)\n\(idx)"
    }
}
