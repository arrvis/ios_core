//
//  BaseTableViewController.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2018/03/15.
//  Copyright © 2018年 Arrvis Co., Ltd. All rights reserved.
//

import UIKit

/// UITableViewController基底クラス
open class BaseTableViewController: UITableViewController {

    open override func viewDidLoad() {
        super.viewDidLoad()
        initializePopGesture()
        handleDidFirstLayoutSubviews()
    }
}
