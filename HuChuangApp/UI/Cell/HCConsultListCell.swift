//
//  HCConsultListCell.swift
//  HuChuangApp
//
//  Created by sw on 2019/9/25.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit

public let HCConsultListCell_idetifier = "HCConsultListCell"
public let HCConsultListCell_Height: CGFloat = 160

class HCConsultListCell: UITableViewCell {
    
    private var coverImgV: UIImageView!
    private var titleLabel: UILabel!
    private var subTitleLabel: UILabel!
    private var infoLabel: UILabel!
    private var priceLabel: UILabel!
    private var countLabel: UILabel!
    private var consultButton:UIButton!
    private var sepLine: UIView!
    
    public var consultCallBack: ((HCDoctorItemModel)->())?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        setupUI()
    }

    private func setupUI() {
        selectionStyle = .none
        
        coverImgV = UIImageView()
        coverImgV.backgroundColor = RGB(245, 245, 245)
        coverImgV.contentMode = .scaleAspectFill
        coverImgV.clipsToBounds = true
        
        titleLabel = UILabel()
        titleLabel.textColor = RGB(51, 51, 51)
        titleLabel.font = .font(fontSize: 15, fontName: .PingFSemibold)
        
        subTitleLabel = UILabel()
        subTitleLabel.textColor = RGB(102, 102, 102)
        subTitleLabel.font = .font(fontSize: 13, fontName: .PingFRegular)

        infoLabel = UILabel()
        infoLabel.textColor = RGB(153, 153, 153)
        infoLabel.numberOfLines = 2
        infoLabel.font = .font(fontSize: 11, fontName: .PingFSemibold)

        priceLabel = UILabel()
        priceLabel.textColor = HC_MAIN_COLOR
        priceLabel.font = .font(fontSize: 18, fontName: .PingFSemibold)

        countLabel = UILabel()
        countLabel.textColor = RGB(153, 153, 153)
        countLabel.font = .font(fontSize: 10, fontName: .PingFRegular)

        consultButton = UIButton()
        consultButton.backgroundColor = HC_MAIN_COLOR
        consultButton.layer.cornerRadius = 12.5
        consultButton.clipsToBounds = true
        consultButton.setTitleColor(.white, for: .normal)
        consultButton.titleLabel?.font = .font(fontSize: 12, fontName: .PingFRegular)
        consultButton.setTitle("图文咨询", for: .normal)
        consultButton.addTarget(self, action: #selector(consultAction), for: .touchUpInside)
        
        sepLine = UIView()
        sepLine.backgroundColor = RGB(249, 249, 249)
        
        contentView.addSubview(coverImgV)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(infoLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(countLabel)
        contentView.addSubview(consultButton)
        contentView.addSubview(sepLine)

        coverImgV.snp.makeConstraints {
            $0.left.top.equalTo(15)
            $0.bottom.equalTo(-15)
            $0.width.equalTo(100)
        }
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(coverImgV.snp.right).offset(15)
            $0.right.equalTo(-15)
            $0.top.equalTo(coverImgV.snp.top).offset(7)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.left.equalTo(titleLabel.snp.left)
            $0.right.equalTo(titleLabel.snp.right)
            $0.top.equalTo(titleLabel.snp.bottom).offset(11)
        }

        infoLabel.snp.makeConstraints {
            $0.left.equalTo(titleLabel.snp.left)
            $0.right.equalTo(titleLabel.snp.right)
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(10)
        }

        consultButton.snp.makeConstraints {
            $0.right.equalTo(titleLabel.snp.right)
            $0.top.equalTo(infoLabel.snp.bottom).offset(14)
            $0.size.equalTo(CGSize.init(width: 100, height: 25))
        }

        priceLabel.snp.makeConstraints {
            $0.left.equalTo(titleLabel.snp.left)
            $0.bottom.equalTo(consultButton.snp.bottom)
        }

        countLabel.snp.makeConstraints {
            $0.left.equalTo(priceLabel.snp.right).offset(14)
            $0.centerY.equalTo(priceLabel.snp.centerY)
        }
        
        sepLine.snp.makeConstraints {
            $0.left.equalTo(coverImgV.snp.left)
            $0.right.equalTo(titleLabel.snp.right)
            $0.bottom.equalTo(0)
            $0.height.equalTo(1)
        }
    }
    
    @objc private func consultAction() {
        consultCallBack?(model)
    }
    
    var model: HCDoctorItemModel! {
        didSet {
            coverImgV.setImage(model.headPath)
            titleLabel.text = model.titleText
            subTitleLabel.text = "妇产科·北京协和医院"
            infoLabel.text = "擅长：不孕不育不孕不育不孕不育不孕不育不孕不育不孕不育不孕不育"
            priceLabel.attributedText = model.priceAttText
            countLabel.text = model.askNumText
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        

    }
}
