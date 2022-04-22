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
    convenience init(imageName: String, bgImageName: String) {
        self.init()
        
        setImage(UIImage(named: imageName), for: UIControl.State.normal)
        setImage(UIImage(named: imageName + "_highlighted"), for: UIControl.State.highlighted)
        setBackgroundImage(UIImage(named: bgImageName), for: UIControl.State.normal)
        setBackgroundImage(UIImage(named: bgImageName + "_highlighted"), for: UIControl.State.highlighted)
        sizeToFit()
    }
}