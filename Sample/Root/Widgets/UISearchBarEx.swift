//
//  UISearchBarEx.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/12/09.
//  Copyright © 2019 grabss corporation. All rights reserved.
//

import UIKit

extension UISearchBar {
    var textField: UITextField? {
        if #available(iOS 13.0, *) {
            return searchTextField
        } else {
            return value(forKey: "_searchField") as? UITextField
        }
    }
}
