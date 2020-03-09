//
//  SelectMemberInteractor.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 23/11/2019.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

// MARK: - SelectMemberInteractor
final class SelectMemberInteractor {

    // MARK: - Variables

    weak var output: SelectMemberInteractorOutputInterface?
}

// MARK: - SelectMemberInteractorInterface
extension SelectMemberInteractor: SelectMemberInteractorInterface {

    func fetchMembers() {
        output?.fetchMembersCompleted(DepartmentService.allUsers, DepartmentService.departments, UserService.loginUser!)
    }

    func fetchMembersIgnoreSelf() {
        output?.fetchMembersCompleted(
            DepartmentService.allUsers.filter { $0.data.id != UserService.loginUser!.data.id },
            DepartmentService.departments.map { DepartmentData(department: $0.department, users: $0.users.filter { $0.data.id != UserService.loginUser!.data.id }) },
            UserService.loginUser!
        )
    }
}
