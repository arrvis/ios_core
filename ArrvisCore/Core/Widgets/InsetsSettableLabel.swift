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
        guard let text = self.text, let textInsets = textInsets else {
            return super.intrinsicContentSize
        }
        let singleLineSize = text.boundingRect(
            with: CGSize(
                width: bounds.width - (textInsets.left + textInsets.right),
                height: CGFloat.greatestFiniteMagnitude),
            options: .usesFontLeading,
            attributes: [NSAttributedString.Key.font: font as Any], context: nil)
        let actualSize = text.boundingRect(
            with: CGSize(
                width: bounds.width - (textInsets.left + textInsets.right),
                height: CGFloat.greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: [NSAttributedString.Key.font: font as Any], context: nil)
        let height: CGFloat
        if numberOfLines == 0 {
            height = actualSize.height
        } else {
            height = min(singleLineSize.height * CGFloat(numberOfLines), actualSize.height)
        }
        return CGSize(
            width: ceil(bounds.width) + textInsets.left + textInsets.right,
            height: ceil(height) + textInsets.top + textInsets.bottom
        )
    }
}
