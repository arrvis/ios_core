//
//  BaseTextView.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2018/02/05.
//  Copyright © 2018年 Arrvis Co., Ltd. All rights reserved.
//

/// TextView基底クラス
open class BaseTextView: UITextView {

    // MARK: - Variables

    /// inputToolBarのTintColor
    open var barTintColor: UIColor? {
        return nil
    }

    /// Responderが存在しない場合にボタンを非表示
    open var hideBtnIfNotExists: Bool {
        return false
    }

    open override var canBecomeFirstResponder: Bool {
        return isEditable || isSelectable
    }

    // MARK: - Initializer

    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        initImpl()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initImpl()
    }

    private func initImpl() {
        if !isEditable {
            return
        }
        inputAccessoryView = configureInputToolBar(bounds.width, barTintColor, hideBtnIfNotExists) { [unowned self] in
            self.resignFirstResponder()
        }
    }
}
