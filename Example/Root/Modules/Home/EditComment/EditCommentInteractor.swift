//
//  EditCommentInteractor.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 10/11/2019.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

// MARK: - EditCommentInteractor
final class EditCommentInteractor {

    // MARK: - Variables

    weak var output: EditCommentInteractorOutputInterface?
}

// MARK: - EditCommentInteractorInterface
extension EditCommentInteractor: EditCommentInteractorInterface {

    func fetchLoginUser() {
        output?.fetchLoginUserCompleted(UserService.loginUser!)
    }

    func saveComment(_ comment: String?) {
        UserService.updateComment(comment).subscribe(onNext: { [unowned self] _ in
            self.output?.saveCommentCompleted()
        }, onError: { [unowned self] error in
            self.output?.handleError(error, nil)
        }).disposed(by: self)
    }
}
