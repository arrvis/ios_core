//
//  Stamps.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2020/02/21.
//  Copyright © 2020 grabss corporation. All rights reserved.
//

import Foundation
import UIKit

final class Stamps {

    static var stampPaths: [URL] = {
        return Bundle.main.paths(forResourcesOfType: "png", inDirectory: "Stamps", forLocalization: nil).map { URL(fileURLWithPath: $0) }
    }()

    static var stampImages: [UIImage] = {
        return stampPaths.compactMap {
            if let data = try? Data(contentsOf: $0) {
                return UIImage(data: data)
            }
            return nil
        }
    }()

    static func getId(_ index: Int) -> String {
        return ":" + String(stampPaths[index].lastPathComponent.split(separator: ".").first!)
    }

    static func fromId(_ id: String) -> URL {
        return stampPaths.first(where: { $0.lastPathComponent.split(separator: ".").first! == String(id[id.index(after: id.startIndex)..<id.endIndex]) })!
    }
}
