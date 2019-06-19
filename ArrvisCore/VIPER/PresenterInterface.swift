//
//  PresenterInterface.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2018/02/08.
//  Copyright © 2018年 Arrvis Co., Ltd. All rights reserved.
//

public protocol PresenterInterface: class {
    func viewDidLoad()
    func viewWillAppear(_ animated: Bool)
    func viewDidAppear(_ animated: Bool)
    func viewWillDisappear(_ animated: Bool)
    func viewDidDisappear(_ animated: Bool)
}

extension PresenterInterface {

    public func viewDidLoad() {
        fatalError("Not implemented")
    }

    public func viewWillAppear(_ animated: Bool) {
        fatalError("Not implemented")
    }

    public func viewDidAppear(_ animated: Bool) {
        fatalError("Not implemented")
    }

    public func viewWillDisappear(_ animated: Bool) {
        fatalError("Not implemented")
    }

    public func viewDidDisappear(_ animated: Bool) {
        fatalError("Not implemented")
    }
}
