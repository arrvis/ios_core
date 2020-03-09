//
//  AttachmentIconView.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2020/02/05.
//  Copyright © 2020 grabss corporation. All rights reserved.
//

import UIKit
import RxSwift
import Alamofire
import Photos

struct AttachmentData: Equatable {
    let id: Any?
    let name: String?
    let url: URL?
    let canDelete: Bool
    let canSelect: Bool

    static func == (lhs: AttachmentData, rhs: AttachmentData) -> Bool {
        if let leftId = lhs.id, let rightId = rhs.id {
            return "\(leftId)" == "\(rightId)"
        } else if lhs.id == nil && rhs.id == nil {
            return lhs.name == rhs.name && lhs.url == rhs.url
        }
        return false
    }

    static func == (lhs: AttachmentData, rhs: ResponsedAttachments) -> Bool {
        if let leftId = lhs.id {
            return "\(leftId)" == String(rhs.id)
        } else if lhs.id == nil {
            return lhs.name == rhs.name && lhs.url?.absoluteString == rhs.url
        }
        return false
    }
}

final class AttachmentIconView: UIView {

    // MARK: - Const

    enum Types {
        case image
        case movie
        case document
        case expired
    }

    // MARK: - Outlets

    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var imageViewPlayIcon: UIImageView!
    @IBOutlet weak private var imageViewAttachmentIcon: UIImageView!
    @IBOutlet weak private var labelDocumentName: AppLabel!
    @IBOutlet weak private var btnDelete: UIButton!
    @IBOutlet weak private var btn: UIButton!

    // MARK: - Variables

    var didTapDelete: Observable<AttachmentData> {
        return didTapDeleteSubject
    }
    private let didTapDeleteSubject = PublishSubject<AttachmentData>()

    var didTap: Observable<AttachmentData> {
        return didTapSubject
    }
    private let didTapSubject = PublishSubject<AttachmentData>()

    var data: AttachmentData! {
        didSet {
            url = data.url
            btnDelete.isHidden = !data.canDelete
            btn.isHidden = !data.canSelect
        }
    }

    var imageContentMode: UIView.ContentMode? {
        didSet {
            guard let imageContentMode = imageContentMode else {
                return
            }
            imageView.contentMode = imageContentMode
        }
    }

    private var url: URL? {
        didSet {
            guard let url = data.url, let ext = url.lastPathComponent.split(separator: ".").last else {
                type = .expired
                return
            }
            let extString = String(ext).lowercased()
            imageView.image = nil
            if avaiableImageExtensions.contains(extString) {
                type = .image
                if url.scheme == "file", let data = try? Data(contentsOf: url) {
                    imageView.image = UIImage(data: data)
                } else {
                    imageView.setImageWithUrlString(url.absoluteString)
                }
            } else if availableVideoExtensions.contains(extString) {
                type = .movie
                if url.scheme == "file" {
                    imageView.image = url.generateThumbnail()
                } else {
                    Alamofire.request(APIRouter.generateHeaderAddedRequest(url.absoluteString)).response { res in
                        let directory = NSTemporaryDirectory()
                        let fileName = "\(NSUUID().uuidString).mov"
                        let fullURL = NSURL.fileURL(withPathComponents: [directory, fileName])!
                        if (try? res.data?.write(to: fullURL)) != nil {
                            self.imageView.image = fullURL.generateThumbnail()
                        }
                    }
                }
            } else {
                type = .document
                imageViewAttachmentIcon.image = avaiableExtensions.first(where: { $0.key == extString })?.value
                labelDocumentName.text = String(url.lastPathComponent.split(separator: ".").last!).uppercased() + "ファイル"
            }
        }
    }

    private(set) var type: Types! {
        didSet {
            switch type {
            case .image:
                imageView.isHidden = false
                imageViewPlayIcon.isHidden = true
                imageViewAttachmentIcon.isHidden = true
                labelDocumentName.isHidden = true
            case .movie:
                imageView.isHidden = false
                imageViewPlayIcon.isHidden = false
                imageViewAttachmentIcon.isHidden = true
                labelDocumentName.isHidden = true
            case .document:
                imageView.isHidden = true
                imageViewPlayIcon.isHidden = true
                imageViewAttachmentIcon.isHidden = false
                labelDocumentName.isHidden = false
            case .expired:
                imageView.isHidden = true
                imageViewPlayIcon.isHidden = true
                imageViewAttachmentIcon.isHidden = false
                imageViewAttachmentIcon.image = R.image.iconBatsu()
                labelDocumentName.isHidden = false
                labelDocumentName.text = R.string.localizable.expiredFile()
                borderWidth = 1
                borderColor = AppStyles.colorNavy.withAlphaComponent(0.5)
                cornerRadius = 8
            case .none:
                break
            }
        }
    }

    // MARK: - Initializers

    public override init(frame: CGRect) {
        super.init(frame: frame)
        initImpl()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        initImpl()
    }

    private func initImpl() {
        _ = loadNib(UINib(resource: R.nib.attachmentIconView))
    }

    // MARK: - Action

    @IBAction private func didTapDelete(_ sender: Any) {
        didTapDeleteSubject.onNext(data)
    }

    @IBAction private func didTap(_ sender: Any) {
        didTapSubject.onNext(data)
    }
}
