//
//  UIColor+Extension.swift
//  Weibo
//
//  Created by 狗身狗面狗 on 2022/5/3.
//

import Foundation
import UIKit

extension UIColor {
    class func randomColor() -> UIColor{
        let r = CGFloat(arc4random() % 256) / 255.0
        let g = CGFloat(arc4random() % 256) / 255.0
        let b = CGFloat(arc4random() % 256) / 255.0
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
}
