//
//  ComposeViewController.swift
//  Weibo
//
//  Created by 狗身狗面狗 on 2022/4/27.
//

import UIKit

// MARK: 写微博控制器
class ComposeViewController: UIViewController {
    // MARK: 监听方法
    /// 关闭
    @objc private func close() {
        textView.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }
    
    /// 发布微博
    @objc private func postStatus() {
        print("发布微博")
        let text = textView.text
        
        YYHNetworkTools.sharedTools.sendStatus(status: text!) { result, error in
            if error != nil {
//                print(error)
                self.dismiss(animated: true, completion: nil)
                return
            }
            
//            print(result)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    /// 选择图片
    @objc private func selectImage() {
        print("选择图片")
    }
    
    @objc private func keyboardChanged(n: Notification) {
        print(n)
        // 获取目标rect
        let rect = (n.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        // 获取动画时长
        let duration = (n.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        print(rect)
        var offset = -(UIScreen.main.bounds.height - rect.origin.y)
        if offset == 0 {
            offset = -20
        }
        
//        placeHolderLabel.isHidden = !placeHolderLabel.isHidden
        toolbar.snp.updateConstraints { make in
            make.bottom.equalTo(view.snp.bottom).offset(offset)
        }
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: 视图生命周期
    override func loadView() {
        view = UIView()
        setupUI()
    }
    
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardChanged(n:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        textView.becomeFirstResponder()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    // MARK: 懒加载控件
    /// 工具条
    private lazy var toolbar = UIToolbar()
    
    /// 文本视图
    private lazy var textView: UITextView = {
        let tv = UITextView()
        tv.textColor = UIColor.darkGray
        tv.font = UIFont.systemFont(ofSize: 15)
        tv.alwaysBounceVertical = true
        tv.keyboardDismissMode = .onDrag
        return tv
    }()
    
    /// 占位文本
    private lazy var placeHolderLabel: UILabel = UILabel(title: "分享新鲜事", fontSize: 15, color: UIColor.lightGray)
}

// MARK: 设置UI
private extension ComposeViewController {
    func setupUI() {
        view.backgroundColor = UIColor.white
        prepareNavigationbar()
        prepareToolbar()
        prepareTextView()
//        textView.inputAccessoryView = toolbar
    }
    
    /// 设置导航栏
    private func prepareNavigationbar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(self.close))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发布", style: .plain, target: self, action: #selector(self.postStatus))
        
        let titleView  = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 32))
//        titleView.backgroundColor = UIColor.red
        navigationItem.titleView =  titleView
        
        let titleLabel = UILabel(title: "发微博", fontSize: 14, color: UIColor.black)
        let nameLabel = UILabel(title: UserAccountViewModel.sharedUserAccount.account?.screen_name ?? "", fontSize: 13, color: UIColor.lightGray)
        titleView .addSubview(titleLabel)
        titleView.addSubview(nameLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(titleView.snp.centerX)
            make.top.equalTo(titleView.snp.top)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalTo(titleView.snp.centerX)
            make.bottom.equalTo(titleView.snp.bottom)
        }
    }
    
    /// 准备文本视图
    private func prepareTextView() {
        view.addSubview(textView)
//        view.addSubview(placeHolderLabel)
        textView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(40)
            make.left.equalTo(view.snp.left).offset(10)
            make.right.equalTo(view.snp.right).offset(-10)
            make.bottom.equalTo(toolbar.snp.top)
//            make.bottom.equalTo(view.snp.bottom)
        }
        textView.text = "分享新鲜事"
//        placeHolderLabel.snp.makeConstraints { make in
//            make.top.equalTo(textView.snp.top).offset(25)
//            make.left.equalTo(textView.snp.left).offset(5)
//        }
    }
    
    /// 设置工具条
    private func prepareToolbar() {
        view.addSubview(toolbar)
        
        // 自动布局
        toolbar.snp.makeConstraints { make in
            make.bottom.equalTo(view.snp.bottom).offset(-20)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.height.equalTo(44)
        }
        
        let itemNames = [ "compose_image", "compose_at", "compose_jin","compose_smile", "compose_add"]
        var items = [UIBarButtonItem]()
        for name in itemNames {
            let button = UIButton(imageName: name, bgImageName: nil)
//            switch name {
//            case "compose_image":
//                button.addTarget(self, action: #selector(self.selectImage)
//                                 , for: UIControl.Event.touchUpInside)
//            default:
//                print("nothing")
//            }
            if name == "compose_image" {
                button.addTarget(self, action: #selector(self.selectImage)
                                 , for: UIControl.Event.touchUpInside)
            }
            let item = UIBarButtonItem(customView: button)
            items.append(item)
            items.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil))
        }
        items.removeLast()
        toolbar.items = items
    }
}
