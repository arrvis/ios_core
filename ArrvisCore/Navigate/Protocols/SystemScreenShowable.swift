//
//  SystemScreenProtocols.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2019/10/21.
//  Copyright © 2019 Arrvis Co., Ltd. All rights reserved.
//

/// SystemScreen表示可能
public protocol SystemScreenShowable: AlertShowable,
//    ActionSheetShowable, ImagePickerShowableで宣言してるからいらないらしい
    ActivityShowable,
    ImagePickerShowable,
    DocumentBrowserShowable,
    DocumentPickerShowable {}
