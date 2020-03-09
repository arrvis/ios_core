//
//  HomeTopPresenter.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/02.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import ArrvisCore
import MobileCoreServices

// MARK: - HomeTopPresenter
final class HomeTopPresenter: PresenterBase {

    // MARK: - Variables

    private var interactor: HomeTopInteractorInterface {
        return interactorInterface as! HomeTopInteractorInterface
    }

    private weak var view: HomeTopViewInterface? {
        return viewInterface as? HomeTopViewInterface
    }

    private var wireframe: HomeTopWireframeInterface {
        return wireframeInterface as! HomeTopWireframeInterface
    }

    // MARK: - Life-Cycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor.fetchLoginUser()
    }

    // MARK: - CameraRollEventHandler

    override func onImageSelected(_ image: UIImage, _ info: [UIImagePickerController.InfoKey: Any]) {
        view?.showLoading()
        interactor.updateIcon(image)
    }
}

// MARK: - HomeTopPresenterInterface
extension HomeTopPresenter: HomeTopPresenterInterface {

    func didTapLatestNotifications() {
        wireframe.showLatestNotificationsScreen()
    }

    func didTapChangeIcon() {
        view?.showMediaPickerSelectActionSheet([kUTTypeImage])
    }

    func didTapEditComment() {
        wireframe.showEditCommentScreen()
    }

    func didTapExchangeCoin() {
        wireframe.showExchangeCoinListScreen()
    }
}

// MARK: - HomeTopInteractorOutputInterface
extension HomeTopPresenter: HomeTopInteractorOutputInterface {

    func fetchLoginUserCompleted(_ loginUser: UserData) {
        view?.showLoginUser(loginUser)
    }

    func updateIconCompleted(_ loginUser: UserData) {
        view?.hideLoading()
        view?.showLoginUser(loginUser)
    }
}
