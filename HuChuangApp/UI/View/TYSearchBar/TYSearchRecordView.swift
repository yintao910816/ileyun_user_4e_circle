//
//  TYSearchRecordView.swift
//  HuChuangApp
//
//  Created by sw on 2019/10/9.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit

class TYSearchRecordView: UIView {

    private var collectionView: UICollectionView!
    
    public var recordDatasource: [TYSearchSectionModel] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        let layout = TYSearchRecordLayout()
        layout.layoutDelegate = self
        
        collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        addSubview(collectionView)
        
        collectionView.register(TYSearchRecordCell.self, forCellWithReuseIdentifier: TYSearchRecordCell_identifier)
        collectionView.register(TYSearchRecordReusableViewHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: TYSearchRecordReusableViewHeader_identifier)
        
        collectionView.snp.makeConstraints { $0.edges.equalTo(UIEdgeInsets.zero) }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension TYSearchRecordView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return recordDatasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recordDatasource[section].recordDatas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return recordDatasource[indexPath.section].recordDatas[indexPath.row].contentSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: width, height: 44)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: TYSearchRecordCell_identifier, for: indexPath) as! TYSearchRecordCell)
        cell.model = recordDatasource[indexPath.section].recordDatas[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = (collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                          withReuseIdentifier: TYSearchRecordReusableViewHeader_identifier,
                                                                          for: indexPath) as! TYSearchRecordReusableViewHeader)
            let sectionModel = recordDatasource[indexPath.section]
            header.configContent(title: sectionModel.sectionTitle, showDelete: sectionModel.showDelete)
            return header
        }
        return UICollectionReusableView()
    }
}

extension TYSearchRecordView: TYSearchRecordLayoutDelegate {
    
    func itemSize(for indexPath: IndexPath, layout: TYSearchRecordLayout) -> CGSize {
        return recordDatasource[indexPath.section].recordDatas[indexPath.row].contentSize
    }
    
    func referenceSize(forHeader insSection: Int, layout: TYSearchRecordLayout) -> CGSize {
        return .init(width: collectionView.width, height: 44)
    }
    
    func minimumLineSpacing(in section: Int, layout: TYSearchRecordLayout) -> CGFloat {
        return 12
    }
    
    func minimumInterSpacing(in section: Int, layout: TYSearchRecordLayout) -> CGFloat {
        return 7
    }
    
    func sectionInset(in section: Int, layout: TYSearchRecordLayout) -> UIEdgeInsets {
        return .init(top: 12, left: 10, bottom: 0, right: 10)
    }
    
}

//MARK: -- TYSearchRecordCell
public let TYSearchRecordCell_identifier = "TYSearchRecordCell"
class TYSearchRecordCell: UICollectionViewCell {
    
    private var contentLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentLabel = UILabel()
        contentLabel.font = .font(fontSize: 12, fontName: .PingFMedium)
        contentLabel.textColor = RGB(153, 153, 153)
        contentLabel.clipsToBounds = true
        
        contentLabel.layer.borderColor = RGB(153, 153, 153).cgColor
        contentLabel.layer.borderWidth = 1
        
        contentView.addSubview(contentLabel)
        
        contentLabel.snp.makeConstraints { $0.edges.equalTo(UIEdgeInsets.zero) }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var model: TYSearchRecordModel! {
        didSet {
            contentLabel.text = model.keyWord
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentLabel.layer.cornerRadius = contentLabel.height / 2.0
    }
}

//MARK: -- TYSearchRecordReusableViewHeader
public let TYSearchRecordReusableViewHeader_identifier = "TYSearchRecordReusableViewHeader"
class TYSearchRecordReusableViewHeader: UICollectionReusableView {
    private var titleLabel: UILabel!
    private var deleteButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel = UILabel()
        titleLabel.font = .font(fontSize: 14, fontName: .PingFMedium)
        titleLabel.textColor = RGB(51, 51, 51)
        
        deleteButton = UIButton()
        deleteButton.backgroundColor = .orange
        deleteButton.addTarget(self, action: #selector(deleteAction), for: .touchUpInside)
        
        addSubview(titleLabel)
        addSubview(deleteButton)
        
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(10)
            $0.centerY.equalTo(snp.centerY)
        }
        
        deleteButton.snp.makeConstraints {
            $0.right.equalTo(-10)
            $0.centerY.equalTo(snp.centerY)
        }
    }
    
    public func configContent(title: String, showDelete: Bool) {
        titleLabel.text = title
        deleteButton.isHidden = !showDelete
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func deleteAction() {
        
    }
}
