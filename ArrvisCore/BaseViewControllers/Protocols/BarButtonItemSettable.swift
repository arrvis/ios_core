//
//  BarButtonItemSettable.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2019/07/02.
//  Copyright © 2019 Arrvis Co., Ltd. All rights reserved.
//

/// BarButtonItem設定可能
public protocol BarButtonItemSettable where Self: UIViewController {

    /// 戻るBarButtonItem
    var backBarButtonItem: UIBarButtonItem? { get }

    /// 左BarButtonItems
    var leftBarButtonItems: [UIBarButtonItem]? { get }

    /// 右BarButtonItems
    var rightBarButtonItems: [UIBarButtonItem]? { get }

    /// 戻るBarButtonItemタップ
    func didTapBackBarButtonItem()

    /// 左BarButtonItemタップ
    func didTapLeftBarButtonItem(_ index: Int)

    /// 右BarButtonItemタップ
    func didTapRightBarButtonItem(_ index: Int)
}

extension BarButtonItemSettable {

    func initBarButtonItems() {
        if let backBarButtonItem = backBarButtonItem {
            navigationItem.backBarButtonItem = backBarButtonItem
        }
        navigationItem.backBarButtonItem?.rx.tap.subscribe(onNext: { [unowned self] in
            // TODO: こいつ呼ばれないぞ
            self.didTapBackBarButtonItem()
        }).disposed(by: self)

        if let leftBarButtonItems = leftBarButtonItems {
            navigationItem.leftBarButtonItems = leftBarButtonItems
        }
        navigationItem.leftBarButtonItems?.forEach({ item in
            item.rx.tap.subscribe(onNext: { [unowned self] in
                self.didTapLeftBarButtonItem(self.navigationItem.leftBarButtonItems!.firstIndex(of: item)!)
            }).disposed(by: self)
        })

        if let rightBarButtonItems = rightBarButtonItems {
            navigationItem.rightBarButtonItems = rightBarButtonItems
        }
        navigationItem.rightBarButtonItems?.forEach({ item in
            item.rx.tap.subscribe(onNext: { [unowned self] in
                self.didTapRightBarButtonItem(self.navigationItem.rightBarButtonItems!.firstIndex(of: item)!)
            }).disposed(by: self)
        })
    }
}
