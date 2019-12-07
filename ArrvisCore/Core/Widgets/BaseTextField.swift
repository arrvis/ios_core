//
//  BaseTextField.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2018/02/05.
//  Copyright © 2018年 Arrvis Co., Ltd. All rights reserved.
//

import RxSwift
import RxCocoa

/// TextField基底クラス
open class BaseTextField: UITextField {

    // MARK: - Variables

    /// inputToolBarのTintColor
    open var barTintColor: UIColor? {
        return nil
    }

    /// Responderが存在しない場合にボタンを非表示
    open var hideBtnIfNotExists: Bool {
        return false
    }

    /// Action可能かどうか
    public var canAction = true

    private let disposeBag = DisposeBag()

    // MARK: - Initializer

    public override init(frame: CGRect) {
        super.init(frame: frame)
        initImpl()
    }

    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initImpl()
    }

    private func initImpl() {
        inputAccessoryView = configureInputToolBar(bounds.width, barTintColor, hideBtnIfNotExists) { [unowned self] in
            self.resignFirstResponder()
        }
        rx.controlEvent(.editingDidEndOnExit).subscribe(onNext: { [unowned self] _ in
            if let n = self.nextInputResponder {
                n.becomeFirstResponder()
            } else {
                self.resignFirstResponder()
            }
        }).disposed(by: disposeBag)
    }
}

// MARK: - Overrides
extension BaseTextField {

    open override func caretRect(for position: UITextPosition) -> CGRect {
        if canAction {
            return super.caretRect(for: position)
        }
        return CGRect.zero
    }

    open override func selectionRects(for range: UITextRange) -> [UITextSelectionRect] {
        if canAction {
            return super.selectionRects(for: range)
        }
        return []
    }

    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return canAction
    }
}
