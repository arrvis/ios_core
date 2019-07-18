//
//  InputToolBarView.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2018/09/18.
//  Copyright © 2018年 Arrvis Co., Ltd. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

private var inputToolBarKey = 0

/// 入力コントロール用ToolBar
public final class InputToolBarView: UIToolbar {

    // MARK: - Variables

    /// 前のResponder
    var previousInputResponder: UIResponder? {
        didSet {
            btnPrev.isEnabled = previousInputResponder != nil
        }
    }

    /// 次のResponder
    var nextInputResponder: UIResponder? {
        didSet {
            btnNext.isEnabled = nextInputResponder != nil
        }
    }

    /// 完了タップ
    var didTapDone: (() -> Void)?

    private let btnPrev = UIBarButtonItem(barButtonHiddenItem: .up)
    private let btnNext = UIBarButtonItem(barButtonHiddenItem: .down)
    private let btnDone = UIBarButtonItem(barButtonSystemItem: .done)
    private let disposeBag = DisposeBag()

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)
        initImpl()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initImpl()
    }

    private func initImpl() {
        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace)
        spacer.width = 10
        items = [
            btnPrev,
            spacer,
            btnNext,
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace),
            btnDone
        ]
        btnPrev.isEnabled = false
        btnNext.isEnabled = false

        btnPrev.rx.tap.subscribe(onNext: { [unowned self] in
            self.previousInputResponder?.becomeFirstResponder()
        }).disposed(by: disposeBag)
        btnNext.rx.tap.subscribe(onNext: { [unowned self] in
            self.nextInputResponder?.becomeFirstResponder()
        }).disposed(by: disposeBag)
        btnDone.rx.tap.subscribe(onNext: { [unowned self] in
            self.didTapDone?()
        }).disposed(by: disposeBag)
    }
}

extension UITextInput {

    /// 前のResponder
    public var previousInputResponder: UIResponder? {
        get {
            return inputToolBar?.previousInputResponder
        }
        set {
            inputToolBar?.previousInputResponder = previousInputResponder
        }
    }

    /// 次のResponder
    public var nextInputResponder: UIResponder? {
        get {
            return inputToolBar?.nextInputResponder
        }
        set {
            inputToolBar?.nextInputResponder = nextInputResponder
        }
    }

    private var inputToolBar: InputToolBarView? {
        get {
            return objc_getAssociatedObject(self, &inputToolBarKey) as? InputToolBarView
        }
        set {
            objc_setAssociatedObject(self, &inputToolBarKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }

    func configureInputToolBar(_ width: CGFloat,
                               _ barTintColor: UIColor?,
                               _ doneAction: @escaping () -> Void) -> InputToolBarView {
        inputToolBar = InputToolBarView(frame: CGRect(x: 0, y: 0, width: width, height: 44))
        if let color = barTintColor {
            inputToolBar?.tintColor = color
        }
        inputToolBar!.didTapDone = {
            doneAction()
        }
        return inputToolBar!
    }
}
