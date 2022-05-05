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
            // Thu May 05 19:24:27 +0800 2022
            // EEE MMM dd HH mm ss zzz yyyy
            timeLabel.text = viewModel?.status.created_at
//            let df = DateFormatter()
//            df.locale = Locale(identifier: "en")
//            df.dateFormat = "EEE MMM dd HH:mm:ss zzz yyyy"
//            let date = df.date(from: timeLabel.text!)
//            print(df.locale)
//            print(date)
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
        
        let stepView = UIView()
        stepView.backgroundColor = UIColor.lightGray
        addSubview(stepView)
        
        stepView.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top)
            make.left.equalTo(self.snp.left)
            make.right.equalTo(self.snp.right)
            make.height.equalTo(StatusCellMargin)
        }
        
        iconView.snp.makeConstraints { make in
            make.top.equalTo(stepView.snp.bottom).offset(StatusCellMargin)
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
