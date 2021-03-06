//
//  DateSelectPicker.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2019/07/19.
//  Copyright © 2019 Arrvis Co., Ltd. All rights reserved.
//

import RxSwift

/// 日付選択PickerView
public final class DateSelectPicker: UIControl {

    public override var canBecomeFirstResponder: Bool {
        return true
    }

    public override var inputAccessoryView: UIView? {
        let toolBar = InputToolBarView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: 44))
        toolBar.didTapDone = { [unowned self] in
            self.dismiss()
            self.resignFirstResponder()
        }
        return toolBar
    }

    private var textStore: String = ""

    private var inputChangedSubject = BehaviorSubject<Date?>(value: nil)

    private var datePicker: UIDatePicker!

    private var last: Date?

    public override var inputView: UIView? {
        return datePicker
    }

    public func show(_ mode: UIDatePicker.Mode,
                     _ min: Date? = nil,
                     _ max: Date? = nil,
                     _ current: Date? = nil,
                     _ locale: Locale? = nil) -> Observable<Date?> {
        datePicker = UIDatePicker()
        datePicker.datePickerMode = mode
        datePicker.minimumDate = min
        datePicker.maximumDate = max
        datePicker.locale = locale ?? Locale(identifier: "ja")
        if let current = current {
            datePicker.date = current
        }
        datePicker.addTarget(self, action: #selector(changed), for: .valueChanged)
        becomeFirstResponder()
        inputChangedSubject.dispose()
        inputChangedSubject = BehaviorSubject<Date?>(value: current)
        return inputChangedSubject
    }

    @objc private func changed() {
        last = datePicker.date
        inputChangedSubject.onNext(datePicker.date)
    }

    func dismiss() {
        if datePicker.date != last {
            inputChangedSubject.onNext(datePicker.date)
        }
    }
}

extension DateSelectPicker: UIKeyInput {

    public var hasText: Bool {
        return !textStore.isEmpty
    }

    public func insertText(_ text: String) {
        textStore += text
        setNeedsDisplay()
    }

    public func deleteBackward() {
        textStore.remove(at: textStore.endIndex)
        setNeedsDisplay()
    }
}
