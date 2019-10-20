//
//  UITextFieldEx.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2018/03/31.
//  Copyright © 2018年 Arrvis Co., Ltd. All rights reserved.
//

extension UITextField {

    /// 下線追加
    ///
    /// - Parameters:
    ///   - width: 幅
    ///   - color: 色
    public func addUnderline(_ width: CGFloat, color: UIColor) {
        let border = CALayer()
        border.frame = CGRect(x: 0, y: self.frame.height - width, width: self.frame.width, height: width)
        border.backgroundColor = color.cgColor
        self.layer.addSublayer(border)
    }
}
