//
//  StatusCellBottomView.swift
//  Weibo
//
//  Created by 狗身狗面狗 on 2022/4/25.
//

import UIKit

/// 底部视图
class StatusCellBottomView: UIView {
    /// 微博视图模型
    var viewModel: StatusViewModel? {
        didSet {
//            retweetedButton.titleLabel?.text = "转发 " + String((viewModel?.status.reposts_count)!)
            retweetedButton.setTitle("转发 " + String((viewModel?.status.reposts_count)!), for: UIControl.State.normal)
            commentButton.setTitle("评论 " + String((viewModel?.status.comments_count)!), for:UIControl.State.normal)
            likeButton.setTitle(" 赞 " + String((viewModel?.status.attitudes_count)!), for: UIControl.State.normal)
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
    /// 转发按钮
    private lazy var retweetedButton = UIButton(title: "转发", color: UIColor.darkGray, imageName:"status_post" , fontSize: 12)
    
    /// 评论按钮
    private lazy var commentButton = UIButton(title: "评论", color: UIColor.darkGray, imageName:"status_comment" , fontSize: 12)
    
    /// 点赞按钮
    private lazy var likeButton = UIButton(title: "赞", color: UIColor.darkGray, imageName:"status_attitude" , fontSize: 12)
    
    
}

extension StatusCellBottomView {
    private func setupUI() {
        addSubview(retweetedButton)
        addSubview(commentButton)
        addSubview(likeButton)
        
        retweetedButton.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top)
            make.left.equalTo(self.snp.left)
            make.bottom.equalTo(self.snp.bottom)
        }
        
        commentButton.snp.makeConstraints { make in
            make.top.equalTo(retweetedButton.snp.top)
            make.left.equalTo(retweetedButton.snp.right)
            make.height.equalTo(retweetedButton.snp.height)
            make.width.equalTo(retweetedButton.snp.width)
        }
        
        likeButton.snp.makeConstraints { make in
            make.top.equalTo(commentButton.snp.top)
            make.left.equalTo(commentButton.snp.right)
            make.height.equalTo(retweetedButton.snp.height)
            make.width.equalTo(retweetedButton.snp.width)
            make.right.equalTo(self.snp.right)
        }
        
        // 分隔视图
        let step1 = stepView()
        let step2 = stepView()
        addSubview(step1)
        addSubview(step2)
        let w = 1
        let scale = 0.4
        step1.snp.makeConstraints { make in
            make.left.equalTo(retweetedButton.snp.right)
            make.centerY.equalTo(retweetedButton.snp.centerY)
            make.width.equalTo(w)
            make.height.equalTo(retweetedButton.snp.height).multipliedBy(scale)
        }
        
        step2.snp.makeConstraints { make in
            make.left.equalTo(commentButton.snp.right)
            make.centerY.equalTo(retweetedButton.snp.centerY)
            make.width.equalTo(w)
            make.height.equalTo(retweetedButton.snp.height).multipliedBy(scale)
        }
    }
    
    private func stepView()-> UIView {
        let v = UIView()
        v.backgroundColor = UIColor.lightGray
        return v
    }
}
