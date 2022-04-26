//
//  StatusRetweetedCell.swift
//  Weibo
//
//  Created by 狗身狗面狗 on 2022/4/26.
//

import UIKit

class StatusRetweetedCell: StatusCell {
    
    /// 如果继承父类的属性 需要 override 不需要super 先执行父类的didset 再执行子类的didset
    override var viewModel: StatusViewModel? {
        didSet {
            // 子类的相关设置
            // 转发微博的文字
            retweetedLabel.text = viewModel?.retweetedText
            pictureView.snp.updateConstraints { make in
                // 根据配图视图 决定视图的顶部间距
                let offset = viewModel?.thumbnailUrls?.count ?? 0 > 0 ? StatusCellMargin : 0
                make.top.equalTo(retweetedLabel.snp.bottom).offset(offset)
            }
        }
    }

    // MARK： -懒加载控件
    /// 背景按钮
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(white: 0.95, alpha: 1)
//        button.backgroundColor = UIColor.red
        return button
    }()
    
    /// 转发微博
    private lazy var retweetedLabel: UILabel = UILabel(title: "转发微博转发微博转发微博转发微博转发微博转发微博转发微博转发微博转发微博转发微博转发微博转发微博转发微博转发微博转发微博转发微博", fontSize: 14, color: UIColor.darkGray)

}

extension StatusRetweetedCell {
    override func setupUI() {
        super.setupUI()
        
        contentView.insertSubview(backButton, belowSubview: pictureView)
        contentView.insertSubview(retweetedLabel, aboveSubview: backButton)
        
        backButton.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(StatusCellMargin)
            make.left.equalTo(contentView.snp.left)
            make.right.equalTo(contentView.snp.right)
            make.bottom.equalTo(bottomView.snp.top)
        }
        
        retweetedLabel.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.top).offset(StatusCellMargin)
            make.left.equalTo(backButton.snp.left).offset(StatusCellMargin)
        }
        
        pictureView.snp.makeConstraints { make in
            make.top.equalTo(retweetedLabel.snp.bottom).offset(StatusCellMargin)
            make.left.equalTo(retweetedLabel.snp.left)
            make.width.equalTo(300)
            make.height.equalTo(90)
        }
        
        retweetedLabel.textAlignment = NSTextAlignment.left
        // 不设置的话计算行高会出现问题
        retweetedLabel.preferredMaxLayoutWidth =  UIScreen.main.bounds.width - 2 * StatusCellMargin
    }
}
