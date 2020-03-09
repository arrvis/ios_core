//
//  AppStyles.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/10/01.
//  Copyright © 2019 grabss corporation. All rights reserved.
//

import UIKit

/// アプリスタイル定義
struct AppStyles {
    static let colorText = UIColor.colorWith(hexStr: "#20222B")

    static let colorDarkGray = UIColor.colorWith(hexStr: "#515860")
    static let colorLineGray = UIColor.colorWith(hexStr: "#CAD0E1")

    static let colorLightNavy = UIColor.colorWith(hexStr: "#ECEFF4")
    static let colorNavy = UIColor.colorWith(hexStr: "#425493")
    static let colorDarkNavy = UIColor.colorWith(hexStr: "#20222B")

    static let colorWhite = UIColor.colorWith(hexStr: "#FFFFFF")
    static let colorRed = UIColor.colorWith(hexStr: "#F53C3C")
    static let colorBlue = UIColor.colorWith(hexStr: "#26BAFF")
    static let colorLightBlue = UIColor.colorWith(hexStr: "#E9F8FF")
    static let colorBlack = UIColor.colorWith(hexStr: "#000000")

    static let colorMoveBlue = UIColor.colorWith(hexStr: "#469FCE")

    static let colorShadow = UIColor.colorWith(hexStr: "#262A31").withAlphaComponent(0.1)
    static let colorTextViewBorder = UIColor.colorWith(hexStr: "#8CCEEB")

    static let font = UIFont.systemFont(ofSize: 14)
    static let fontSemiBold = UIFont.systemFont(ofSize: 14, weight: .semibold)
    static let fontBold = UIFont.boldSystemFont(ofSize: 14)
}
