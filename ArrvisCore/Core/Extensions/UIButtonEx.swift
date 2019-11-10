//
//  UIButtonEx.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2019/11/10.
//  Copyright © 2019 Arrvis Co., Ltd. All rights reserved.
//

extension UIButton {

    /// 背景色設定
    public func setBackgroundColor(_ color: UIColor, _ cornerRadius: CGFloat = 0, for state: UIControl.State) {
        setBackgroundImage(color.toImage(frame.size, cornerRadius), for: state)
    }
}
