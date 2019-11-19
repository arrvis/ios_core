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
    open var textInsets: UIEdgeInsets? {
        return nil
    }

    // MARK: - Overrides

    open override func drawText(in rect: CGRect) {
        if let textInsets = textInsets {
            super.drawText(in: rect.inset(by: textInsets))
        } else {
            super.drawText(in: rect)
        }
    }

    open override var intrinsicContentSize: CGSize {
        guard let text = self.text, let textInsets = textInsets else { return super.intrinsicContentSize }
        let newSize = text.boundingRect(
            with: CGSize(width: bounds.width,
                         height: CGFloat.greatestFiniteMagnitude),
            options: .usesFontLeading,
            attributes: [NSAttributedString.Key.font: font as Any], context: nil)
        return CGSize(
            width: ceil(newSize.size.width) + textInsets.left + textInsets.right,
            height: ceil(newSize.size.height) + textInsets.top + textInsets.bottom
        )
    }
}
