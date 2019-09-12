//
//  BaseViewController.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2018/02/05.
//  Copyright © 2018年 Arrvis Co., Ltd. All rights reserved.
//

import UIKit

/// UIViewController基底クラス
open class BaseViewController: UIViewController, BarButtonItemSettableViewController {

    open override func viewDidLoad() {
        super.viewDidLoad()
        initializePopGesture()
        handleDidFirstLayoutSubviews()
    }
}
