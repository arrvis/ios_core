//
//  SelectMemberPresenter.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 23/11/2019.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import ArrvisCore

// MARK: - SelectMemberPresenter
final class SelectMemberPresenter: PresenterBase {

    // MARK: - Variables

    private var interactor: SelectMemberInteractorInterface {
        return interactorInterface as! SelectMemberInteractorInterface
    }

    private weak var view: SelectMemberViewInterface? {
        return viewInterface as? SelectMemberViewInterface
    }

    private var wireframe: SelectMemberWireframeInterface {
        return wireframeInterface as! SelectMemberWireframeInterface
    }

    private var nextScreen: AppScreens? {
        return payload as? AppScreens
    }

    private var selectedMembers: [UserData]? {
        return payload as? [UserData]
    }

    // MARK: - Life-Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        if nextScreen == AppScreens.groupCreation {
            interactor.fetchMembers()
        } else {
            interactor.fetchMembersIgnoreSelf()
        }
        view?.setCanMultipleSelection(nextScreen == AppScreens.groupCreation || selectedMembers != nil)
    }
}

// MARK: - SelectMemberPresenterInterface
extension SelectMemberPresenter: SelectMemberPresenterInterface {

    func didTapNext(_ selectedMembers: [UserData]) {
        if nextScreen == AppScreens.groupCreation {
            wireframe.showGroupCreationScreen(selectedMembers)
        } else {
            wireframe.popScreen(result: selectedMembers, true)
        }
    }
}

// MARK: - SelectMemberInteractorOutputInterface
extension SelectMemberPresenter: SelectMemberInteractorOutputInterface {

    func fetchMembersCompleted(_ members: [UserData], _ departments: [DepartmentData], _ loginUser: UserData) {
        view?.showMembers(members, departments, loginUser)
        if nextScreen == AppScreens.groupCreation {
            view?.showMinGroupMemberNumber(loginUser.role.groupMembersMinNumber!)
        }
        if let selectedMembers = selectedMembers {
            view?.showSelectedMembers(selectedMembers)
            view?.showMinGroupMemberNumber(loginUser.role.groupMembersMinNumber!)
        }
    }
}
