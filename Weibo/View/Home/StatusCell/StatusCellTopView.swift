//
//  StatusCellTopView.swift
//  Weibo
//
//  Created by 狗身狗面狗 on 2022/4/25.
//

import UIKit




/// 顶部视图
class StatusCellTopView: UIView {
    /// 微博视图模型
    var viewModel: StatusViewModel? {
        didSet {
            namelabel.text = viewModel?.status.user?.screen_name
            iconView.sd_setImage(with: viewModel?.userProfileUrl, placeholderImage: viewModel?.userDefaultIconView)
            timeLabel.text = viewModel?.status.created_at
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -懒加载控件
    /// 头像
    private lazy var iconView: UIImageView = UIImageView(imgName: "welcome_head")
    /// 姓名
    private lazy var namelabel: UILabel = UILabel(title: "王老五", fontSize: 14)
    /// 时间
    private lazy var timeLabel: UILabel = UILabel(title: "现在", fontSize: 11)
}


extension StatusCellTopView {
    private func setupUI() {
//        backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        
        addSubview(iconView)
        addSubview(namelabel)
        addSubview(timeLabel)
        
        iconView.snp.makeConstraints { make in
            make.centerY.equalTo(self.snp.centerY)
            make.left.equalTo(self.snp.left).offset(StatusCellMargin)
            make.width.equalTo(StatusCellIconWidth)
            make.height.equalTo(StatusCellIconWidth)
        }
        iconView.layer.cornerRadius = StatusCellIconWidth/2
        iconView.layer.masksToBounds = true
//
        namelabel.snp.makeConstraints { make in
            make.top.equalTo(iconView.snp.top)
            make.left.equalTo(iconView.snp.right).offset(StatusCellMargin)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.bottom.equalTo(iconView.snp.bottom)
            make.right.equalTo(self.snp.right).offset(-StatusCellMargin)
        }
    }
}