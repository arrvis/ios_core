//
//  UIScrollViewEx.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2018/02/05.
//  Copyright © 2018年 Arrvis Co., Ltd. All rights reserved.
//

// didScrollToBottomとかほしいいな。
extension UIScrollView {

    /// Topにいるか
    public var isAtTop: Bool {
        return contentOffset.y <= verticalOffsetForTop
    }

    /// Borromにいるか
    public var isAtBottom: Bool {
        return contentOffset.y >= verticalOffsetForBottom
    }

    /// Topの垂直方向オフセット
    public var verticalOffsetForTop: CGFloat {
        let topInset = contentInset.top
        return -topInset
    }

    /// Bottomの垂直方向オフセット
    public var verticalOffsetForBottom: CGFloat {
        let scrollViewHeight = bounds.height
        let scrollContentSizeHeight = contentSize.height
        let bottomInset = contentInset.bottom
        let scrollViewBottomOffset = scrollContentSizeHeight + bottomInset - scrollViewHeight
        return scrollViewBottomOffset
    }

    /// 表示中のページ
    public var currentHorizontalPage: Int {
        return (Int)(contentOffset.x / bounds.width)
    }

    /// 最大ページ数
    public var maxHorizontalPage: Int {
        return (Int)(contentSize.width / bounds.width) - 1
    }

    /// 最初のページかどうか
    public var isFirstHorizontalPage: Bool {
        return currentHorizontalPage == 0
    }

    /// 最終ページかどうか
    public var isLastHorizontalPage: Bool {
        return currentHorizontalPage == maxHorizontalPage
    }

    /// 表示中のページ
    public var currentVerticalPage: Int {
        return (Int)(contentOffset.y / bounds.height)
    }

    /// 最大ページ数
    public var maxVerticalPage: Int {
        return (Int)(contentSize.height / bounds.height) - 1
    }

    /// 最初のページかどうか
    public var isFirstVerticalPage: Bool {
        return currentVerticalPage == 0
    }

    /// 最終ページかどうか
    public var isLastVerticalPage: Bool {
        return currentVerticalPage == maxVerticalPage
    }

    /// 指定したページまでスクロール
    ///
    /// - Parameters:
    ///   - horizontalPage: 水平方向ページ
    ///   - verticalPage: 垂直方向ページ
    ///   - duration: アニメーション時間
    public func scrollTo(horizontalPage: Int, verticalPage: Int, duration: TimeInterval) {
        scrollToImpl(horizontalPage: horizontalPage, verticalPage: verticalPage, duration: duration, completion: nil)
    }

    /// 指定したページまでスクロール
    ///
    /// - Parameters:
    ///   - horizontalPage: 水平方向ページ
    ///   - verticalPage: 垂直方向ページ
    ///   - duration: アニメーション時間
    ///   - completion: 完了通知
    public func scrollTo(horizontalPage: Int,
                         verticalPage: Int,
                         duration: TimeInterval,
                         completion: @escaping Completion) {
        scrollToImpl(horizontalPage: horizontalPage,
                     verticalPage: verticalPage,
                     duration: duration,
                     completion: completion)
    }

    /// 指定したページまでスクロール
    ///
    /// - Parameters:
    ///   - horizontalPage: 水平方向ページ
    ///   - duration: アニメーション時間
    public func scrollTo(horizontalPage: Int, duration: TimeInterval) {
        scrollTo(horizontalPage: horizontalPage, verticalPage: currentVerticalPage,
                 duration: duration)
    }

    /// 指定したページまでスクロール
    ///
    /// - Parameters:
    ///   - horizontalPage: 水平方向ページ
    ///   - duration: アニメーション時間
    ///   - completion: 完了通知
    public func scrollTo(horizontalPage: Int, duration: TimeInterval, completion: @escaping Completion) {
        scrollTo(horizontalPage: horizontalPage, verticalPage: currentVerticalPage,
                 duration: duration, completion: completion)
    }

    /// 前のページまでスクロール
    ///
    /// - Parameter duration: アニメーション時間
    public func scrollToHorizontalPreviousPage(duration: TimeInterval) {
        if !isFirstHorizontalPage {
            scrollTo(horizontalPage: currentHorizontalPage - 1, duration: duration)
        }
    }

    /// 前のページまでスクロール
    ///
    /// - Parameters:
    ///   - duration: アニメーション時間
    ///   - completion: 完了通知
    public func scrollToHorizontalPreviousPage(duration: TimeInterval, completion: @escaping Completion) {
        if !isFirstHorizontalPage {
            scrollTo(horizontalPage: currentHorizontalPage - 1, duration: duration, completion: completion)
        }
    }

    /// 次のページまでスクロール
    ///
    /// - Parameter duration: アニメーション時間
    public func scrollToHorizontalNextPage(duration: TimeInterval) {
        if !isLastHorizontalPage {
            scrollTo(horizontalPage: currentHorizontalPage + 1, duration: duration)
        }
    }

    /// 次のページまでスクロール
    ///
    /// - Parameters:
    ///   - duration: アニメーション時間
    ///   - completion: 完了通知
    public func scrollToHorizontalNextPage(duration: TimeInterval, completion: @escaping Completion) {
        if !isLastHorizontalPage {
            scrollTo(horizontalPage: currentHorizontalPage + 1, duration: duration, completion: completion)
        }
    }

    /// 指定したページまでスクロール
    ///
    /// - Parameters:
    ///   - verticalPage: 垂直方向ページ
    ///   - duration: アニメーション時間
    public func scrollTo(verticalPage: Int, duration: TimeInterval) {
        scrollTo(horizontalPage: currentHorizontalPage, verticalPage: self.currentVerticalPage,
                 duration: duration)
    }

    /// 指定したページまでスクロール
    ///
    /// - Parameters:
    ///   - verticalPage: 垂直方向ページ
    ///   - duration: アニメーション時間
    ///   - completion: 完了通知
    public func scrollTo(verticalPage: Int, duration: TimeInterval, completion: @escaping Completion) {
        scrollTo(horizontalPage: currentHorizontalPage, verticalPage: self.currentVerticalPage,
                 duration: duration, completion: completion)
    }

    /// 前のページまでスクロール
    ///
    /// - Parameter duration: アニメーション時間
    public func scrollToVerticalPreviousPage(duration: TimeInterval) {
        if !isFirstVerticalPage {
            scrollTo(verticalPage: currentVerticalPage - 1, duration: duration)
        }
    }

    /// 前のページまでスクロール
    ///
    /// - Parameters:
    ///   - duration: アニメーション時間
    ///   - completion: 完了通知
    public func scrollToVerticalPreviousPage(duration: TimeInterval, completion: @escaping Completion) {
        if !isFirstVerticalPage {
            scrollTo(verticalPage: currentVerticalPage - 1, duration: duration, completion: completion)
        }
    }

    /// 次のページまでスクロール
    ///
    /// - Parameter duration: アニメーション時間
    public func scrollToVerticalNextPage(duration: TimeInterval) {
        if !isLastVerticalPage {
            scrollTo(verticalPage: currentVerticalPage + 1, duration: duration)
        }
    }

    /// 次のページまでスクロール
    ///
    /// - Parameters:
    ///   - duration: アニメーション時間
    ///   - completion: 完了通知
    public func scrollToVerticalNextPage(duration: TimeInterval, completion: @escaping Completion) {
        if !isLastVerticalPage {
            scrollTo(verticalPage: currentVerticalPage + 1, duration: duration, completion: completion)
        }
    }

    // MARK: - private method

    private func scrollToImpl(horizontalPage: Int, verticalPage: Int, duration: TimeInterval, completion: Completion?) {
        let point = CGPoint(
            x: self.bounds.width * CGFloat(horizontalPage),
            y: self.bounds.height * CGFloat(verticalPage))
        UIView.animate(withDuration: duration, animations: {
            self.contentOffset = point
        }, completion: { finished in
            if finished {
                if let completion = completion {
                    completion()
                } else {
                    self.delegate?.scrollViewDidEndDecelerating?(self)
                }
            }
        })
    }
}
