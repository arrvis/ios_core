//
//  TouchableButton.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2018/09/18.
//  Copyright © 2018年 Arrvis Co., Ltd. All rights reserved.
//

// TODO: Rx対応

/// タッチ可能なボタン
open class TouchableButton: UIButton {

    // MARK: - Variables

    /// タッチ開始
    public var started: (() -> Void)?

    /// タッチ移動
    public var moved: ((CGFloat, CGFloat) -> Void)?

    /// タッチキャンセル
    public var cancelled: (() -> Void)?

    /// タッチ終了
    public var ended: (() -> Void)?

    private var initial: CGPoint?
}

// MARK: - Touches
extension TouchableButton {

    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if let touch = touches.first {
            initial = touch.location(in: self)
        }
        started?()
    }

    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        if let touch = touches.first {
            if let moved = moved, let initial = initial {
                let location = touch.location(in: self)
                moved(location.x - initial.x, location.y - initial.y)
            }
        }
    }

    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        cancelled?()
    }

    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        ended?()
    }
}
