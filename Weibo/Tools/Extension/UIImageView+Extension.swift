//
//  UIImageView+Extension.swift
//  Weibo
//
//  Created by 狗身狗面狗 on 2022/4/22.
//

import Foundation
import UIKit

extension UIImageView {
    convenience init(imgName: String) {
        self.init(image: UIImage(named: imgName))
    }
}
