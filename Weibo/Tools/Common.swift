//
//  Common.swift
//  Weibo
//
//  Created by 狗身狗面狗 on 2022/4/22.
//

// 提供全局共享属性或方法
import Foundation
import UIKit

/// 全局通知定义
let WBSwitchRootViewControllerNotification = "WBSwitchRootViewControllerNotification"

/// 全局外观渲染颜色
let WBAppearanceTintColor =  UIColor.orange


// MARK: -全局函数，可直接使用

/// 延迟 在主线程执行函数
func delay(delata: Double, callFunc: @escaping ()->()) {
    DispatchQueue.main.asyncAfter(deadline:  DispatchTime.init(uptimeNanoseconds: NSEC_PER_SEC * UInt64(delata)), execute: callFunc)
}
