//
//  SelectMemberInterfaces.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 23/11/2019.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import ArrvisCore

protocol SelectMemberViewInterface: ViewInterface {
    func setCanMultipleSelection(_ canMultipleSelection: Bool)
    func showMembers(_ members: [UserData], _ departments: [DepartmentData], _ loginUser: UserData)
    func showSelectedMembers(_ members: [UserData])
    func showMinGroupMemberNumber(_ number: Int)
}

protocol SelectMemberPresenterInterface: PresenterInterface {
    func didTapNext(_ selectedMembers: [UserData])
}

protocol SelectMemberInteractorInterface: InteractorInterface {
    func fetchMembers()
    func fetchMembersIgnoreSelf()
}

protocol SelectMemberInteractorOutputInterface: InteractorOutputInterface {
    func fetchMembersCompleted(_ members: [UserData], _ departments: [DepartmentData], _ loginUser: UserData)
}

protocol SelectMemberWireframeInterface: WireframeInterface {
    func showGroupCreationScreen(_ selectedMembers: [UserData])
}
