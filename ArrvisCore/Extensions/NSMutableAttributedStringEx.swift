//
//  NSMutableAttributedStringEx.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2018/03/31.
//  Copyright © 2018年 Arrvis Co., Ltd. All rights reserved.
//

import UIKit

extension NSMutableAttributedString {

    /// フォント指定
    public func setFont(font: UIFont, range: NSRange) -> Self {
        addAttribute(.font, value: font, range: range)
        return self
    }

    /// 文字色指定
    public func setTextColor(color: UIColor, range: NSRange) -> Self {
        addAttribute(.foregroundColor, value: color, range: range)
        return self
    }

    /// ベースラインオフセット指定
    public func setBaseLineOffset(offset: CGFloat, range: NSRange) -> Self {
        addAttribute(.baselineOffset, value: offset, range: range)
        return self
    }

    /// 文字間指定
    public func setLetterSpacing(letterSpacing: CGFloat, range: NSRange) -> Self {
        addAttribute(.kern, value: letterSpacing, range: range)
        return self
    }

    /// 文章スタイル指定
    public func setParagraphStyle(style: NSParagraphStyle, range: NSRange) -> Self {
        addAttribute(.paragraphStyle, value: style, range: range)
        return self
    }
}

extension NSMutableParagraphStyle {

    /// 行高さ指定
    public func setLineHeight(min: CGFloat, max: CGFloat) -> Self {
        self.minimumLineHeight = min
        self.maximumLineHeight = max
        return self
    }

    /// 文字位置指定
    public func setTextAlignment(alignment: NSTextAlignment) -> Self {
        self.alignment = alignment
        return self
    }

    /// 改行モード指定
    public func setLineBreak(lineBreakMode: NSLineBreakMode) -> Self {
        self.lineBreakMode = lineBreakMode
        return self
    }

    /// 行間指定
    public func setLineSpace(lineSpacing: CGFloat) -> Self {
        self.lineSpacing = lineSpacing
        return self
    }
}
