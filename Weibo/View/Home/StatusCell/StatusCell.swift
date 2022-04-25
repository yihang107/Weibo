//
//  StatusCellTableViewCell.swift
//  Weibo
//
//  Created by 狗身狗面狗 on 2022/4/25.
//

import UIKit

/// 微博Cell中控件的间距
let StatusCellMargin: CGFloat = 12
/// 微博头像的宽度
let StatusCellIconWidth: CGFloat = 35

/// 微博cell
class StatusCell: UITableViewCell {
    /// 微博视图模型
    var viewModel: StatusViewModel? {
        didSet {
            topView.viewModel = viewModel
            bottomView.viewModel = viewModel
            contentLabel.text = viewModel?.status.text
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 懒加载控件
    
    /// 顶部视图
    private lazy var topView: StatusCellTopView = StatusCellTopView()
    /// 微博正文标签
    private lazy var contentLabel: UILabel = UILabel(title: "微博正文", fontSize: 15)
    /// 底部视图
    private lazy var bottomView: StatusCellBottomView = StatusCellBottomView()
    
    
}


extension StatusCell {
    private func setupUI() {
        contentView.addSubview(topView)
        contentView.addSubview(contentLabel)
        contentView.addSubview(bottomView)
        
        topView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top)
            make.left.equalTo(contentView.snp.left)
            make.right.equalTo(contentView.snp.right)
            make.height.equalTo(StatusCellMargin * 2 + StatusCellIconWidth)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom).offset(StatusCellMargin)
            make.left.equalTo(contentView.snp.left).offset(StatusCellMargin)
            make.right.equalTo(contentView.snp.right).offset(-StatusCellMargin)
        }
        
        bottomView.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(StatusCellMargin)
            make.left.equalTo(contentView.snp.left)
            make.right.equalTo(contentView.snp.right)
            make.height.equalTo(44)
            
            make.bottom.equalTo(contentView.snp.bottom)
        }
        
        contentLabel.textAlignment = NSTextAlignment.left
        // 不设置的话计算行高会出现问题
        contentLabel.preferredMaxLayoutWidth =  UIScreen.main.bounds.width - 2 * StatusCellMargin
    }
}
