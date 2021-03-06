//
//  VisitorView.swift
//  Weibo
//
//  Created by 狗身狗面狗 on 2022/4/22.
//

import UIKit
import SnapKit

// 代理 block NSNotification KVO target
/// 访客视图的协议
protocol VisitorViewDelegate: NSObjectProtocol {
    /// 注册
    func visitorViewRegisterClick()
    /// 登录
    func visitorViewLoginClick()
}


/// 访客视图 - 处理用户未登陆的界面显示
class VisitorView: UIView {
    /// 代理
    weak var delegate: VisitorViewDelegate?
    
    // MARK: 监听方法
    @objc private func clickLogin() {
        delegate?.visitorViewLoginClick()
    }
    
    @objc private func clickRegister() {
        delegate?.visitorViewRegisterClick()
    }
    // MARK: 设置视图信息
    func setupInfo(imageName: String?, title: String) {
        messageLabel.text = title
        // 如果图片为nil 说明是首页
        guard let imgName = imageName else {
            startRoll()
            return
        }
        
        iconView.image = UIImage.init(named: imgName)
        loadRoundView.isHidden = true
    }
    
    /// 开启转轮动画
    private func startRoll() {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.toValue = 2 * Double.pi
        animation.repeatCount = MAXFLOAT
        animation.duration = 10
        // 不断重复 切换到桌面 切换到其他界面
        // 动画绑定的图层对应的视图被销毁 动画会自动销毁
        animation.isRemovedOnCompletion = false
        // 添加到图层
        loadRoundView.layer.add(animation, forKey: nil)
    }
    // MARK: 构造函数
    // initWithFrame是UIView的制定构造函数
    // 纯代码开发使用
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    // 使用SB或者XIB开发加载的函数
    // 使用sb开发的入口
    required init?(coder: NSCoder) {
        // 如果使用sb开发 调用这个视图会崩溃 阻止SB自定义当前视图
        // 如果希望当前视图只被纯代码加载 可以使用fatalError
//        fatalError("init(coder:) has not been implemented")
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: 懒加载控件
    private lazy var iconView: UIImageView = UIImageView(imgName: "visitor_home_house")
    private lazy var loadRoundView: UIImageView = UIImageView(imgName:"visitor_round")
//    private lazy var iconView: UIImageView = UIImageView(image: UIImage(named: "visitor_home_house"))
//    private lazy var loadRoundView: UIImageView = UIImageView(image: UIImage(named: "visitor_round"))
    private lazy var messageLabel: UILabel = UILabel(title: "关注一些人,回这里看看有什么事")
//    private lazy var messageLabel: UILabel = {
//        let label = UILabel()
//        label.text = "关注一些人, 回这里看看有什么事"
//        label.textColor = UIColor.darkGray
//        label.font = UIFont.systemFont(ofSize: 14)
//        label.numberOfLines = 0
//        label.textAlignment = NSTextAlignment.center
//        return label
//    } ()
    private lazy var registerButton: UIButton = UIButton(title: "注册", color: UIColor.orange)
    private lazy var loginButon: UIButton = UIButton(title: "登录", color: UIColor.gray)
//    private lazy var registerButton: UIButton = {
//        let button = UIButton()
//        button.setTitle(" 注册 ", for: UIControl.State.normal)
//        button.setTitleColor(UIColor.orange, for: UIControl.State.normal)
//        button.backgroundColor = UIColor.white
//        button.layer.cornerRadius = 10
//        return button
//    } ()
//    private lazy var loginButon: UIButton = {
//        let button = UIButton()
//        button.setTitle(" 登录 ", for: UIControl.State.normal)
//        button.setTitleColor(UIColor.gray, for: UIControl.State.normal)
//        button.backgroundColor = UIColor.white
//        button.layer.cornerRadius = 10
//        return button
//    } ()

}

extension VisitorView {
    /// 设置界面
    private func setupUI() {
        // 灰度图 R = G = B 纯白到纯黑 安全色
        backgroundColor = UIColor(white: 237.0/255.0, alpha: 1.0)
        // 添加控件
        addSubview(iconView)
        addSubview(loadRoundView)
        addSubview(messageLabel)
        addSubview(registerButton)
        addSubview(loginButon)
        // 设置自动布局
        // snapkit的方式
        iconView.snp.makeConstraints { make in
            make.centerX.equalTo(self.snp.centerX)
            make.centerY.equalTo(self.snp.centerY).offset(-60)
        }
        
        loadRoundView.snp.makeConstraints { make in
            make.centerX.equalTo(self.snp.centerX)
            make.centerY.equalTo(self.snp.centerY).offset(-60)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(loadRoundView.snp.bottom).offset(16)
            make.width.equalTo(224)
            make.height.equalTo(36)
        }
        
        registerButton.snp.makeConstraints { make in
            make.left.equalTo(messageLabel.snp.left)
            make.top.equalTo(messageLabel.snp.bottom).offset(20)
            make.width.equalTo(60)
            make.height.equalTo(40)
        }
        
        loginButon.snp.makeConstraints { make in
            make.right.equalTo(messageLabel.snp.right)
            make.top.equalTo(messageLabel.snp.bottom).offset(20)
            make.width.equalTo(60)
            make.height.equalTo(40)
        }
        
        /*
         添加约束需要添加到父视图上
         建议子视图有一个统一的参照物
         */
        //  true 支持使用setFrame的方式设置控件位置
        // false支持使用自动布局方式设置
//        for v in subviews {
//            v.translatesAutoresizingMaskIntoConstraints = false
//        }
//
//        // 图标
//        addConstraint(NSLayoutConstraint(item: iconView, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1.0, constant: 0))
//        addConstraint(NSLayoutConstraint(item: iconView, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1.0, constant: 0))
//        // 转轮
//        addConstraint(NSLayoutConstraint(item: loadRoundView, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1.0, constant: 0))
//        addConstraint(NSLayoutConstraint(item: loadRoundView, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1.0, constant: 0))
//        // 消息文字
//        addConstraint(NSLayoutConstraint(item: messageLabel, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1.0, constant: 0))
//        addConstraint(NSLayoutConstraint(item: messageLabel, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: loadRoundView, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: 16))
//        addConstraint(NSLayoutConstraint(item: messageLabel, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1.0, constant: 224))
//        addConstraint(NSLayoutConstraint(item: messageLabel, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1.0, constant: 36))
//        // 注册按钮
//        addConstraint(NSLayoutConstraint(item: registerButton, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: messageLabel, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1.0, constant: 0))
//        addConstraint(NSLayoutConstraint(item: registerButton, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: messageLabel, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: 20))
//        addConstraint(NSLayoutConstraint(item: registerButton, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1.0, constant: 60))
//        addConstraint(NSLayoutConstraint(item: registerButton, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1.0, constant: 30))
//
//        // 登录按钮
//        addConstraint(NSLayoutConstraint(item: loginButon, attribute: NSLayoutConstraint.Attribute.right, relatedBy: NSLayoutConstraint.Relation.equal, toItem: messageLabel, attribute: NSLayoutConstraint.Attribute.right, multiplier: 1.0, constant: 0))
//        addConstraint(NSLayoutConstraint(item: loginButon, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: messageLabel, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: 20))
//        addConstraint(NSLayoutConstraint(item: loginButon, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1.0, constant: 60))
//        addConstraint(NSLayoutConstraint(item: loginButon, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1.0, constant: 30))
        // 通过VFL设置
//        addConstraint(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[login]-0-|", options: [], metrics: nil, views: ["login": loginButon ]))
        
        // 添加监听方法
        registerButton.addTarget(self, action: #selector(self.clickRegister), for: UIControl.Event.touchUpInside)
        loginButon.addTarget(self, action: #selector(self.clickLogin), for: UIControl.Event.touchUpInside)
    }
}
