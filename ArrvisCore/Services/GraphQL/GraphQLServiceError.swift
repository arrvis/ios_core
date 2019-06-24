//
//  GraphQLServiceError.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2019/06/24.
//  Copyright © 2019 Arrvis Co., Ltd. All rights reserved.
//

import Apollo

public class GraphQLServiceError: Error {

    public var errors: [GraphQLError]!

    init(errors: [GraphQLError]) {
        self.errors = errors
    }
}
