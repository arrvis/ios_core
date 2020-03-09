//
//  EditCommentInterfaces.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 10/11/2019.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import ArrvisCore

protocol EditCommentViewInterface: ViewInterface {
    func showComment(_ comment: String?)
}

protocol EditCommentPresenterInterface: PresenterInterface {
    func didTapSave(_ comment: String?)
}

protocol EditCommentInteractorInterface: InteractorInterface {
    func fetchLoginUser()
    func saveComment(_ comment: String?)
}

protocol EditCommentInteractorOutputInterface: InteractorOutputInterface {
    func fetchLoginUserCompleted(_ loginUser: UserData)
    func saveCommentCompleted()
}

protocol EditCommentWireframeInterface: WireframeInterface {
}
