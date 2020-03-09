//
//  GroupCreationInterfaces.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 10/11/2019.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import ArrvisCore

protocol GroupCreationViewInterface: ViewInterface {
    func showGroup(_ group: GroupData)
    func showIcon(_ image: UIImage)
    func showMembers(_ members: [UserData])
    func showMinGroupMemberNumber(_ number: Int)
}

protocol GroupCreationPresenterInterface: PresenterInterface {
    func didTapIcon()
    func didTapAddMember(_ members: [UserData])
    func didTapCreate(_ groupName: String, _ selectedMembers: [UserData])
}

protocol GroupCreationInteractorInterface: InteractorInterface {
    func fetchLoginUser()
    func createGroup(_ icon: UIImage?, _ members: [UserData], _ groupName: String)
    func editGroup(_ group: GroupData, _ icon: UIImage?, _ members: [UserData], _ groupName: String)
}

protocol GroupCreationInteractorOutputInterface: InteractorOutputInterface {
    func fetchLoginUserCompleted(_ loginUser: UserData)
    func createGroupCompleted()
    func editGroupCompleted(_ edited: GroupData)
}

protocol GroupCreationWireframeInterface: WireframeInterface {
    func showSelectMemberScreen(_ members: [UserData])
}
