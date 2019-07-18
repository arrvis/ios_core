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
            self.resignFirstResponder()
        }
        return toolBar
    }

    private var textStore: String = ""

    private var pickerView: ValueSelectPickerView!

    public override var inputView: UIView? {
        return pickerView
    }

    public func show(_ values: [String]) -> Observable<Int> {
        pickerView = ValueSelectPickerView(values: values)
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

    public var inputChanged: Observable<Int> {
        return inputChangedSubject
    }
    private let inputChangedSubject = BehaviorSubject(value: 0)

    private var values: [String]!

    public override init(frame: CGRect) {
        super.init(frame: .zero)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    convenience init(values: [String]) {
        self.init(frame: .zero)
        self.values = values
        dataSource = self
        delegate = self
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
        inputChangedSubject.onNext(row)
    }
}
