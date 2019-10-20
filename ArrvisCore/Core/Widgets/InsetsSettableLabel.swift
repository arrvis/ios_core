//
//  InsetsSettableLabel.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2018/09/18.
//  Copyright © 2018年 Arrvis Co., Ltd. All rights reserved.
//

/// Insets設定可能なLabel
open class InsetsSettableLabel: UILabel {

    // MARK: - Variables

    /// テキストのInsets
    open var textInsets: UIEdgeInsets {
        return .zero
    }

    // MARK: - Overrides

    open override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }

    open override var intrinsicContentSize: CGSize {
        guard let text = self.text else { return super.intrinsicContentSize }
        var contentSize = super.intrinsicContentSize
        let newSize = text.boundingRect(
            with: CGSize(width: bounds.width - textInsets.left + textInsets.right,
                         height: CGFloat.greatestFiniteMagnitude),
            options: NSStringDrawingOptions.usesLineFragmentOrigin,
            attributes: [NSAttributedString.Key.font: font as Any], context: nil)
        contentSize.height = ceil(newSize.size.height) + textInsets.top + textInsets.bottom
        return contentSize
    }
}
