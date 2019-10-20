//
//  UIColorEx.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2018/02/05.
//  Copyright © 2018年 Arrvis Co., Ltd. All rights reserved.
//

extension UIColor {

    /// 16進数文字列からUIColor生成
    /// - parameter hex: 16進数文字列
    /// - returns: UIColor
    public class func colorWith(hexStr: String, alpha: CGFloat = 1) -> UIColor {
        let scanner = Scanner(string: hexStr.replacingOccurrences(of: "#", with: "") as String)
        var color: UInt32 = 0
        return scanner.scanHexInt32(&color)
            ? UIColor(red: CGFloat((color & 0xFF0000) >> 16) / 255.0,
                      green: CGFloat((color & 0x00FF00) >> 8) / 255.0,
                      blue: CGFloat(color & 0x0000FF) / 255.0,
                      alpha: alpha)
            : .white
    }
}
