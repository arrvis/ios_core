//
//  UIViewEx.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2018/02/05.
//  Copyright © 2018年 Arrvis Co., Ltd. All rights reserved.
//

import UIKit
import TinyConstraints

private var constraintsKey = 0

extension UIView {

    /// 完了アクション
    public typealias Completion = () -> Void

    /// Nibをロード
    ///
    /// - Parameter nib: nib
    public func loadNib(_ nib: UINib) {
        addSubviewWithFit(nib.instantiate(withOwner: self, options: nil).first as! UIView)
    }

    /// スクリーンショット生成
    public func takeScreenShot() -> UIImage? {
        return UIGraphicsImageRenderer(size: bounds.size).image { _ in
            drawHierarchy(in: CGRect(origin: .zero, size: bounds.size), afterScreenUpdates: true)
        }
    }
}

// MARK: - IBInspectable
extension UIView {

    /// 角Radius
    @IBInspectable public var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
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

// MARK: - SubView Property
extension UIView {

    /// SubViewの一番右の座標取得
    public var maxSubViewRight: CGFloat {
        guard let view = subviews.max(by: { (a, b) in
            return a.frame.origin.x + a.frame.width <= b.frame.origin.x + b.frame.width
        }) else {
            return 0
        }
        return view.frame.origin.x + view.frame.width
    }

    /// SubViewの一番下の座標取得
    public var maxSubViewBottom: CGFloat {
        guard let view = subviews.max(by: { (a, b) -> Bool in
            return a.frame.origin.y + a.frame.height < b.frame.origin.y + b.frame.height
        }) else {
            return 0
        }
        return view.frame.origin.y + view.frame.height
    }

    /// SubViewの最大サイズ
    public var maxSubViewSize: CGSize {
        return CGSize(width: maxSubViewRight, height: maxSubViewBottom)
    }
}

// MARK: - Animation
extension UIView {

    /// フェードイン
    ///
    /// - Parameters:
    ///   - duration: 時間
    ///   - completion: 完了通知
    public func fadeIn(duration: TimeInterval, completion: Completion?) {
        fadeImpl(true, duration: duration, completion: completion)
    }

    /// フェードアウト
    ///
    /// - Parameters:
    ///   - duration: 時間
    ///   - completion: 完了通知
    public func fadeOut(duration: TimeInterval, completion: Completion?) {
        fadeImpl(false, duration: duration, completion: completion)
    }

    private func fadeImpl(_ isfadeIn: Bool, duration: TimeInterval, completion: Completion?) {
        alpha = isfadeIn ? 0 : 1
        self.layer.removeAllAnimations()
        UIView.animate(withDuration: duration, animations: {
            self.alpha = isfadeIn ? 1 : 0
        }, completion: { finished in
            if finished {
                completion?()
            }
        })
    }
}

// MARK: - add / remove subview
extension UIView {

    /// 追加済みのConstraints
    public var addedConstraints: Constraints? {
        get {
            return objc_getAssociatedObject(self, &constraintsKey) as? Constraints ?? nil
        }
        set {
            objc_setAssociatedObject(self, &constraintsKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }

    /// 親にfitさせてaddSubView
    public func addSubviewWithFit(_ view: UIView, usingSafeArea: Bool = false) {
        addSubview(view)
        addedConstraints = view.edgesToSuperview(usingSafeArea: usingSafeArea)
    }

    /// centerにaddSubView
    ///
    /// - Parameter view: view
    public func addSubviewToCenter(_ view: UIView) {
        addSubview(view)
        addedConstraints = center(in: view)
    }

    /// 子を全て削除
    public func removeAllSubView() {
        subviews.forEach { (subView) in
            subView.removeFromSuperview()
        }
    }
}
