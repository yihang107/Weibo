//
//  StatusNormalCell.swift
//  Weibo
//
//  Created by 狗身狗面狗 on 2022/4/26.
//

import UIKit

class StatusNormalCell: StatusCell {
    /// 微博视图模型
    override var viewModel: StatusViewModel? {
        didSet {
            pictureView.snp.updateConstraints { make in
                // 根据配图视图 决定视图的顶部间距
                let offset = viewModel?.thumbnailUrls?.count ?? 0 > 0 ? StatusCellMargin : 0
                make.top.equalTo(contentLabel.snp.bottom).offset(offset)
            }
        }
    }
    
    override func setupUI() {
        super.setupUI()
        pictureView.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(StatusCellMargin)
            make.left.equalTo(contentLabel.snp.left)
            make.width.equalTo(300)
            make.height.equalTo(90)
        }
    }
}
