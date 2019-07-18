//
//  ValueSelectPicker.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2019/07/19.
//  Copyright © 2019 Arrvis Co., Ltd. All rights reserved.
//

import RxSwift

/// 値選択PickerView
public final class ValueSelectPicker: UIControl {

    public override var canBecomeFirstResponder: Bool {
        return true
    }

    public override var inputAccessoryView: UIView? {
        let toolBar = InputToolBarView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: 44))
        toolBar.didTapDone = { [unowned self] in
            self.pickerView.dismiss()
            self.resignFirstResponder()
        }
        return toolBar
    }

    private var textStore: String = ""

    private var pickerView: ValueSelectPickerView!

    public override var inputView: UIView? {
        return pickerView
    }

    public func show(_ values: [String], _ current: Int? = nil) -> Observable<Int?> {
        pickerView = ValueSelectPickerView(values: values, current: current)
        becomeFirstResponder()
        return pickerView.inputChanged
    }
}

extension ValueSelectPicker: UIKeyInput {

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

final class ValueSelectPickerView: UIPickerView {

    public var inputChanged: Observable<Int?> {
        return inputChangedSubject
    }
    private lazy var inputChangedSubject = {
        return BehaviorSubject<Int?>(value: last)
    }()

    private var values: [String]!

    private var last: Int?

    public override init(frame: CGRect) {
        super.init(frame: .zero)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    convenience init(values: [String], current: Int?) {
        self.init(frame: .zero)
        self.values = values
        self.last = current
        if let current = current {
            selectRow(current, inComponent: 0, animated: false)
        }
        dataSource = self
        delegate = self
    }

    func dismiss() {
        let row = selectedRow(inComponent: 0)
        if row != last {
            inputChangedSubject.onNext(row)
        }
    }
}

extension ValueSelectPickerView: UIPickerViewDataSource, UIPickerViewDelegate {

    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return values.count
    }

    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return values[row]
    }

    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        last = row
        inputChangedSubject.onNext(row)
    }
}
