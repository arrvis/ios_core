//
//  Device.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2015/04/22.
//  Copyright © 2015年 Arrvis Co.,Ltd. All rights reserved.
//

/// デバイス情報
public struct Device {

    /// 基底のスクリーン幅
    public static let baseScreenWidth: CGFloat = 320.0

    /// Bounds
    public static var bounds: CGRect {
        return UIScreen.main.bounds
    }

    /// スクリーン幅
    public static var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }

    /// スクリーン高さ
    public static var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }

    /// ステータスバー高さ
    public static var statusBarHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.height
    }

    /// スクリーンの拡大率
    public static var screenScaleRatio: CGFloat {
        return UIScreen.main.bounds.width / baseScreenWidth
    }

    /// NavigationBar高さ
    public static func navBarHeight(navigationController: UINavigationController) -> CGFloat {
        return navigationController.navigationBar.frame.size.height
    }

    /// ステータスバー高さ+NavigationBar高さ
    public static func commonTopHeight(navigationController: UINavigationController) -> CGFloat {
        return navBarHeight(navigationController: navigationController) + statusBarHeight
    }
}
