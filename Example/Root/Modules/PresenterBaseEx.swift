//
//  PresenterBaseEx.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2020/02/24.
//  Copyright © 2020 grabss corporation. All rights reserved.
//

import ArrvisCore

extension PresenterBase {

    func didTapUser(_ userId: String) {
        wireframeInterface.showUserProfileScreen(userId)
    }
}
