//
//  BackFromNextHandleable.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2018/03/08.
//  Copyright © 2018年 Arrvis Co., Ltd. All rights reserved.
//

/// 次画面から戻ってきたイベントハンドリング可能
public protocol BackFromNextHandleable {
    func onBackFromNext(_ result: Any?)
}
