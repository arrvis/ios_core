//
//  AutoResizeTextView.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2018/10/16.
//  Copyright © 2018年 Arrvis Co., Ltd. All rights reserved.
//

import UIKit
import RxSwift
import TinyConstraints

/// 自動でリサイズするTextView
@IBDesignable open class AutoResizeTextView: BaseTextView {

    // MARK: - Variables

    @IBInspectable public var maxExpandLines: Int = Int.max
    @IBInspectable public var minHeight: CGFloat = 0
    @IBInspectable public var maxWidth: CGFloat = 100

    private var sizeConstraints: Constraints?

    private let disposeBag = DisposeBag()

    // MARK: - Initializer

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        initialize()
    }

    private func initialize() {
        if !isEditable {
            textContainerInset = .zero
        }
        rx.text.subscribe(onNext: { [unowned self] _ in
            self.refreshHeight()
        }).disposed(by: disposeBag)
    }
}

// MARK: - Public
extension AutoResizeTextView {

    /// サイズ更新
    public func refreshSize() -> CGSize {
        sizeConstraints?.deActivate()
        let fitsSize = sizeThatFits(CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude))
        let s = CGSize(width: fitsSize.width, height: max(fitsSize.height, minHeight))
        sizeConstraints = size(s)
        self.isScrollEnabled = false
        return s
    }

    /// 高さ更新
    public func refreshHeight() {
        let inputtedLines = Int(contentSize.height / font!.lineHeight)
        if inputtedLines >= maxExpandLines {
            self.isScrollEnabled = true
        } else {
            sizeConstraints?.deActivate()
            let fitsSize = sizeThatFits(CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude))
            sizeConstraints = size(CGSize(width: bounds.width, height: max(fitsSize.height, minHeight)))
            self.isScrollEnabled = false
        }
    }
}

// MARK: - Touches
extension AutoResizeTextView {

    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let next = next {
            next.touchesBegan(touches, with: event)
        } else {
            super.touchesBegan(touches, with: event)
        }
    }

    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let next = next {
            next.touchesEnded(touches, with: event)
        } else {
            super.touchesEnded(touches, with: event)
        }
    }

    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let next = next {
            next.touchesCancelled(touches, with: event)
        } else {
            super.touchesCancelled(touches, with: event)
        }
    }

    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let next = next {
            next.touchesMoved(touches, with: event)
        } else {
            super.touchesMoved(touches, with: event)
        }
    }
}
