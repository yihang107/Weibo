//
//  UIButton+Extension.swift
//  Weibo
//
//  Created by 狗身狗面狗 on 2022/4/22.
//

import Foundation
import UIKit

extension UIButton {
    // 便利构造函数
    convenience init(imageName: String, bgImageName: String?) {
        self.init()
        
        setImage(UIImage(named: imageName), for: UIControl.State.normal)
        setImage(UIImage(named: imageName + "_highlighted"), for: UIControl.State.highlighted)
        if let bgImageName = bgImageName {
            setBackgroundImage(UIImage(named: bgImageName), for: UIControl.State.normal)
            setBackgroundImage(UIImage(named: bgImageName + "_highlighted"), for: UIControl.State.highlighted)
        }
        sizeToFit()
    }
    
    convenience init(title: String, color: UIColor) {
        self.init()
        setTitle(title, for: UIControl.State.normal)
        setTitleColor(color, for: UIControl.State.normal)
        backgroundColor = UIColor.white
        layer.cornerRadius = 10
    }
    
    
    convenience init(title: String, color: UIColor, imageName: String, fontSize: CGFloat) {
        self.init()
        
        setTitle(title, for: UIControl.State.normal)
        setTitleColor(color, for: UIControl.State.normal)
        setImage(UIImage(named: imageName), for: UIControl.State.normal)
        titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        sizeToFit()
    }
}
