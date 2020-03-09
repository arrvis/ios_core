//
//  UIViewEx.swift
//  ios_vue_apollo
//
//  Created by Yutaka Izumaru on 2019/06/25.
//  Copyright © 2019 Arrvis Co., Ltd. All rights reserved.
//

import UIKit

// MARK: - IBInspectable
extension UIView {

    /// 角Radius
    @IBInspectable public var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }

    /// 枠線太さ
    @IBInspectable public var borderWidth: CGFloat {
        get {
            return self.layer.borderWidth
        }
        set {
            self.layer.borderWidth = newValue
        }
    }

    /// 枠線色
    @IBInspectable public var borderColor: UIColor? {
        get {
            return UIColor(cgColor: self.layer.borderColor!)
        }
        set {
            self.layer.borderColor = newValue?.cgColor
        }
    }
}
