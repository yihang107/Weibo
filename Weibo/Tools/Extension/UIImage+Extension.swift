//
//  UIImage+Extension.swift
//  Weibo
//
//  Created by 狗身狗面狗 on 2022/5/3.
//

import Foundation
import UIKit

extension UIImage {
    /// 将图像缩放到指定宽度
    func scaleToWidth(width: CGFloat) -> UIImage {
        if width > size.width {
            return self
        }
        
        let height: CGFloat = size.height / size.width * width
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        
        UIGraphicsBeginImageContext(rect.size)
        self.draw(in: rect)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return result ?? self
    }
}
