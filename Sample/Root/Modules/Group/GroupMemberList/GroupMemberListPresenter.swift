//
//  GroupMemberListPresenter.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 10/11/2019.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import ArrvisCore

// MARK: - GroupMemberListPresenter
final class GroupMemberListPresenter: PresenterBase {

    // MARK: - Variables

    private var interactor: GroupMemberListInteractorInterface {
        return interactorInterface as! GroupMemberListInteractorInterface
    }

    private weak var view: GroupMemberListViewInterface? {
        return viewInterface as? GroupMemberListViewInterface
    }

    private var wireframe: GroupMemberListWireframeInterface {
        return wireframeInterface as! GroupMemberListWireframeInterface
    }

    // MARK: - Life-Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view?.showMembers(payload as! GroupData)
    }
}

// MARK: - GroupMemberListPresenterInterface
extension GroupMemberListPresenter: GroupMemberListPresenterInterface {
}

// MARK: - GroupMemberListInteractorOutputInterface
extension GroupMemberListPresenter: GroupMemberListInteractorOutputInterface {
}
