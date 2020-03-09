//
//  MessageInputView.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2020/01/23.
//  Copyright © 2020 grabss corporation. All rights reserved.
//

import UIKit
import RxSwift

final class MessageInputView: UIView {

    // MARK: - Const

    enum Mode {
        case initial
        case inputting
        case stamp
    }

    // MARK: - Outlets

    @IBOutlet weak private var buttonFile: UIButton!
    @IBOutlet weak private var buttonImage: UIButton!
    @IBOutlet weak private var labelPlaceHolder: AppLabel!
    @IBOutlet weak private var textViewInput: AutoResizeTextView!
    @IBOutlet weak private var buttonAction: UIButton!
    @IBOutlet weak private var heightOfStampCollectionView: NSLayoutConstraint!
    @IBOutlet weak private var stampCollectionView: UICollectionView!
    @IBOutlet weak private var flowLayout: UICollectionViewFlowLayout!

    // MARK: - Variables

    var didTapFile: Observable<Void> {
        return didTapFileSubject
    }
    private let didTapFileSubject = PublishSubject<Void>()

    var didTapImage: Observable<Void> {
        return didTapImageSubject
    }
    private let didTapImageSubject = PublishSubject<Void>()

    var didTapSend: Observable<String> {
        return didTapSendSubject
    }
    private let didTapSendSubject = PublishSubject<String>()

    var didTapStamp: Observable<String> {
        return didTapStampSubject
    }
    private let didTapStampSubject = PublishSubject<String>()

    var mode = Mode.initial {
        didSet {
            switch mode {
            case .initial:
                labelPlaceHolder.isHidden = !textViewInput.text.isEmpty
                textViewInput.isHidden = false
                buttonAction.setImage(R.image.iconStamp(), for: .normal)
                buttonAction.setTitle(nil, for: .normal)
                buttonAction.isEnabled = true
                heightOfStampCollectionView.constant = 0
            case .inputting:
                labelPlaceHolder.isHidden = true
                textViewInput.isHidden = false
                buttonAction.setImage(nil, for: .normal)
                buttonAction.setTitle("送信", for: .normal)
                buttonAction.isEnabled = !textViewInput.text.isEmpty
                heightOfStampCollectionView.constant = 0
            case .stamp:
                endEditing(true)
                buttonAction.setImage(R.image.iconStampFilled(), for: .normal)
                buttonAction.setTitle(nil, for: .normal)
                buttonAction.isEnabled = true
                heightOfStampCollectionView.constant = 219
            }
            UIView.animate(withDuration: 0.3) { [unowned self] in
                self.layoutIfNeeded()
            }
        }
    }

    // MARK: - Initializers

    public override init(frame: CGRect) {
        super.init(frame: frame)
        initImpl()
    }

    required public init? (coder: NSCoder) {
        super.init(coder: coder)
        initImpl()
    }

    private func initImpl() {
        _ = loadNib(UINib(resource: R.nib.messageInputView))
        textViewInput.rx.text.subscribe(onNext: { [unowned self] text in
            if self.mode == .inputting {
                self.buttonAction.isEnabled = !text!.isEmpty
            }
        }).disposed(by: self)
        mode = .initial
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        stampCollectionView.register(R.nib.stampCollectionViewCell)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let marginsAndInsets = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + stampCollectionView.safeAreaInsets.left
            + stampCollectionView.safeAreaInsets.right
            + flowLayout.minimumInteritemSpacing * CGFloat(4 - 1)
        let itemWidth = ((stampCollectionView.bounds.size.width - marginsAndInsets) / CGFloat(4)).rounded(.down)
        flowLayout.itemSize =  CGSize(width: itemWidth, height: itemWidth)
    }

    // MARK: Methods

    func onKeyboardWillShow() {
        mode = .inputting
    }

    func onKeyboardWillHide() {
        mode = .initial
    }
}

// MARK: - Action
extension MessageInputView {

    @IBAction private func didTapFile(_ sender: Any) {
        didTapFileSubject.onNext(())
    }

    @IBAction private func didTapImage(_ sender: Any) {
        didTapImageSubject.onNext(())
    }

    @IBAction private func didTapAction(_ sender: Any) {
        switch mode {
        case .initial:
            mode = .stamp
        case .inputting:
            didTapSendSubject.onNext(textViewInput.text)
            textViewInput.text = ""
            mode = .initial
        case .stamp:
            mode = .initial
        }
    }
}

// MARK: - UICollectionViewDataSource
extension MessageInputView: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Stamps.stampImages.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.stampCollectionViewCell, for: indexPath)!
        cell.image = Stamps.stampImages[indexPath.row]
        cell.didTap = { [unowned self] in
            self.didTapStampSubject.onNext(Stamps.getId(indexPath.row))
            self.mode = .initial
        }
        return cell
    }
}
