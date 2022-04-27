//
//  WBRefreshControl.swift
//  Weibo
//
//  Created by 狗身狗面狗 on 2022/4/26.
//

import UIKit

private let WBRefreshControlOffset: CGFloat = -60

class WBRefreshControl: UIRefreshControl {
    // MARK: 重写
    override func endRefreshing() {
        super.endRefreshing()
        refreshView.stopAnimtaion()
    }
    
    /// 主动开始刷新动画
    override func beginRefreshing() {
        super.beginRefreshing()
        refreshView.startAnimation()
    }
    
    // MARK: KVO 监听方法
    /*
     始终呆在屏幕上 下拉的时候 Y值绝对值变大 一直变小
     默认起点的Y是0
     */
    /// 箭头旋转标记
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        print(frame)
        
        if frame.origin.y > 0 {
            return
        }
        
        if isRefreshing {
            refreshView.startAnimation()
            return
        }
        
        if frame.origin.y < WBRefreshControlOffset && !refreshView.rotateFalg {
            print("翻过来")
            refreshView.rotateFalg = true
        } else if (frame.origin.y > WBRefreshControlOffset && refreshView.rotateFalg){
            print("翻过去")
            refreshView.rotateFalg = false
        }
    }
    
    override init() {
        super.init()
        setupUI()
    }
    
    // MARK: 构造函数
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        tintColor = UIColor.clear
        // 添加控件
        addSubview(refreshView)
        
        // 自动布局 从xib加载的控件 需要指定大小约束
        refreshView.snp.makeConstraints { make in
            make.centerX.equalTo(self.snp.centerX)
            make.centerY.equalTo(self.snp.centerY)
            make.size.equalTo(refreshView.bounds.size)
        }
        
        // 使用KVO监听位置变化  主线程有任务不调度 异步但是顺序执行
        // 当前Runloop所有代码执行完毕后 运行循环结束前 开始监听
        // 方法会在下一次循环开始
        DispatchQueue.main.async {
            self.addObserver(self, forKeyPath: "frame", options: [], context: nil)
        }
    }
 
    // MARK: - 懒加载控件
    private lazy var refreshView = WBRefreshView.refreshView()
    
    deinit {
        self.removeObserver(self, forKeyPath: "frame")
    }
}


/// 刷新视图 - 负责处理
//@objcMembers
class WBRefreshView: UIView {
    var rotateFalg = false {
        didSet {
            self.rotateArrowIcon()
        }
    }
    
    @IBOutlet weak var rollIconView: UIImageView!
    @IBOutlet weak var arrowIconView: UIImageView!
    @IBOutlet weak var tipView: UIView!
    
    class func refreshView() -> WBRefreshView {
        let nib = UINib(nibName: "WBRefreshVIew", bundle: nil)
        return nib.instantiate(withOwner: nil, options: nil)[0] as! WBRefreshView
    }
    
    /// 旋转箭头
    private func rotateArrowIcon() {
//        self.arrowIconView.transform = CGAffineTransform.identity
//        var angle = CGFloat(Double.pi)
//        angle += rotateFalg ? -0.00001 : 0.00001
        
        // 旋转就近原则
        UIView.animate(withDuration: 0.5) {
            if self.rotateFalg {
                self.arrowIconView.transform = CGAffineTransform(rotationAngle: Double.pi)
            } else {
                self.arrowIconView.transform = CGAffineTransform.identity
            }
        }
    }
    
    /// 播放加载动画
    func startAnimation() {
        tipView.alpha = 0
        
        // 判断动画是否已经添加
        let key = "transform.rotation"
        if rollIconView.layer.animation(forKey: key) != nil {
            return
        }
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.toValue = 2 * Double.pi
        animation.repeatCount = MAXFLOAT
        animation.duration = 2
        animation.isRemovedOnCompletion = false
        rollIconView.layer.add(animation, forKey: key)
    }
    
    /// 停止加载动画
    func stopAnimtaion() {
        tipView.alpha = 1
        rollIconView.layer.removeAllAnimations()
    }
  }
