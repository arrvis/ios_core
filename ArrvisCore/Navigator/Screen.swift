//
//  Screen.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2018/09/27.
//  Copyright © 2018年 Arrvis Co., Ltd. All rights reserved.
//

import UIKit

/// Screen protocol
public protocol Screen {

    /// パス
    var path: String { get }

    /// 遷移Transition
    var transition: NavigateTransions { get }

    /// ViewController
    func createViewController(_ payload: Any?) -> UIViewController
}

/// 遷移Transition
///
/// - replace: replace
/// - push: push
/// - present: present
public enum NavigateTransions: String {
    case replace
    case push
    case present
}
