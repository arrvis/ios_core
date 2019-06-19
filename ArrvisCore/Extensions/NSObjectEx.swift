//
//  NSObjectEx.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2018/02/05.
//  Copyright © 2018年 Arrvis Co., Ltd. All rights reserved.
//

import Foundation

extension NSObject {

    /// クラス名取得
    @nonobjc public static var className: String {
        return NSStringFromClass(self).components(separatedBy: ".").last! as String
    }

    /// クラス名取得
    @nonobjc public var className: String {
        return type(of: self).className
    }

    /// 遅延実行
    /// - parameter delayMSec: 遅延時間(milliseconds)
    /// - parameter closure:   クロージャ
    public static func runAfterDelay(delayMSec: Int, closure:@escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(delayMSec), execute: closure)
    }

    /// メインスレッドで実行
    ///
    /// - Parameter closure: クロージャ
    public static func runOnMainThread(closure: @escaping () -> Void) {
        DispatchQueue.main.async(execute: closure)
    }
}
