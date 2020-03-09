//
//  EditCommentPresenter.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 10/11/2019.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import ArrvisCore

// MARK: - EditCommentPresenter
final class EditCommentPresenter: PresenterBase {

    // MARK: - Variables

    private var interactor: EditCommentInteractorInterface {
        return interactorInterface as! EditCommentInteractorInterface
    }

    private weak var view: EditCommentViewInterface? {
        return viewInterface as? EditCommentViewInterface
    }

    private var wireframe: EditCommentWireframeInterface {
        return wireframeInterface as! EditCommentWireframeInterface
    }

    // MARK: - Life-Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.fetchLoginUser()
    }
}

// MARK: - EditCommentPresenterInterface
extension EditCommentPresenter: EditCommentPresenterInterface {

    func didTapSave(_ comment: String?) {
        view?.showLoading()
        interactor.saveComment(comment)
    }
}

// MARK: - EditCommentInteractorOutputInterface
extension EditCommentPresenter: EditCommentInteractorOutputInterface {

    func fetchLoginUserCompleted(_ loginUser: UserData) {
        view?.showComment(loginUser.data.attributes.comment)
    }

    func saveCommentCompleted() {
        view?.hideLoading()
        wireframe.dismissScreen()
    }
}
