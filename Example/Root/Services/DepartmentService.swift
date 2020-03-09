//
//  DepartmentService.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/28.
//  Copyright © 2019 grabss corporation. All rights reserved.
//

import ArrvisCore
import RxSwift

/// 部署サービス
final class DepartmentService {

    // MARK: - Variables

    static var departments = [DepartmentData]()
    static var allUsers: [UserData] {
        return departments.flatMap { $0.users }.distinct()
    }

    // MARK: - Methods

    private struct DepartmentsResponse: BaseModel {
        let data: [ResponsedDepartment]
    }
    /// 部署一覧更新
    static func refreshDepartments() -> Observable<Void> {
        let request: Observable<DepartmentsResponse> = APIRouter(path: "/departments").request()
        return request.flatMap {
            return Observable.zip($0.data.map { department in fetchDepartmentUsers(department)
                .map { users in DepartmentData(department: department, users: users.data.map { UserData(data: $0, included: users.included) }) }
            })
        }.map { ret in
            departments = ret
            return ()
        }.retryAuth()
    }
    private struct DepartmentUsersResponse: BaseModel {
        let data: [UserRelation]
        let included: [Included]
    }
    private static func fetchDepartmentUsers(_ department: ResponsedDepartment) -> Observable<DepartmentUsersResponse> {
        return APIRouter(path: "/departments/\(department.id)/users").request().retryAuth()
    }
}
