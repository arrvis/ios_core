//
//  UILabelEx.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2018/02/05.
//  Copyright © 2018年 Arrvis Co., Ltd. All rights reserved.
//

extension UILabel {

    /// リンクを追加
    ///
    /// - Parameters:
    ///   - linkText: 追加対象文字列
    ///   - linkColor: リンク色
    /// - Returns: UITapGestureRecognizer
    public func addLink(linkText: String, linkColor: UIColor) -> UITapGestureRecognizer? {
        guard let text = text else {
            return nil
        }

        let newText = NSMutableAttributedString(string: text)
        let attrs: [NSAttributedString.Key: Any] = [
            .foregroundColor: linkColor,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        let range = (text as NSString).range(of: linkText)
        newText.addAttributes(attrs, range: range)
        attributedText = newText

        isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer()
        addGestureRecognizer(gestureRecognizer)
        return gestureRecognizer
    }

    /// 文字間スペース指定
    public func setTextWithLineSpace(text: String?, lineSpacing: CGFloat) {
        self.text = text
        guard let text = text  else {
            return
        }
        self.attributedText = NSMutableAttributedString(string: text)
            .setParagraphStyle(style: NSMutableParagraphStyle().setLineSpace(lineSpacing: lineSpacing),
                               range: NSRange(location: 0, length: text.count))
    }
}
