//
//  GroupCreationPresenter.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 10/11/2019.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import ArrvisCore
import MobileCoreServices

// MARK: - GroupCreationPresenter
final class GroupCreationPresenter: PresenterBase {

    // MARK: - Variables

    private var interactor: GroupCreationInteractorInterface {
        return interactorInterface as! GroupCreationInteractorInterface
    }

    private weak var view: GroupCreationViewInterface? {
        return viewInterface as? GroupCreationViewInterface
    }

    private var wireframe: GroupCreationWireframeInterface {
        return wireframeInterface as! GroupCreationWireframeInterface
    }

    private var members: [UserData] {
        if let members = payload as? [UserData] {
            return members
        } else if let group = group {
            return group.users
        }
        return []
    }

    private var group: GroupData? {
        return payload as? GroupData
    }

    private var icon: UIImage?

    // MARK: - Life-Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view?.showMembers(members)
        if let group = group {
            view?.showGroup(group)
        }
        interactor.fetchLoginUser()
    }

    override func onBackFromNext(_ result: Any?) {
        if let selected = result as? [UserData] {
            view?.showMembers(selected)
        }
    }

    // MARK: - CameraRollEventHandler

    override func onImageSelected(_ image: UIImage, _ info: [UIImagePickerController.InfoKey: Any]) {
        icon = image
        view?.showIcon(image)
    }
}

// MARK: - GroupCreationPresenterInterface
extension GroupCreationPresenter: GroupCreationPresenterInterface {

    func didTapIcon() {
        view?.showMediaPickerSelectActionSheet([kUTTypeImage])
    }

    func didTapAddMember(_ members: [UserData]) {
        wireframe.showSelectMemberScreen(members)
    }

    func didTapCreate(_ groupName: String, _ selectedMembers: [UserData]) {
        view?.showLoading()
        if let group = group {
            interactor.editGroup(group, icon, selectedMembers, groupName)
        } else {
            interactor.createGroup(icon, selectedMembers, groupName)
        }
    }
}

// MARK: - GroupCreationInteractorOutputInterface
extension GroupCreationPresenter: GroupCreationInteractorOutputInterface {

    func fetchLoginUserCompleted(_ loginUser: UserData) {
        view?.showMinGroupMemberNumber(loginUser.role.groupMembersMinNumber!)
    }

    func createGroupCompleted() {
        view?.hideLoading()
        wireframe.popToRootScreen()
    }

    func editGroupCompleted(_ edited: GroupData) {
        view?.hideLoading()
        wireframe.popScreen(result: edited)
    }
}
