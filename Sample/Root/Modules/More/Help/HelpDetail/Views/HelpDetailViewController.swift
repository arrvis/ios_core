//
//  HelpDetailViewController.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 04/03/2020.
//  Copyright © 2020 grabss corporation.. All rights reserved.
//

import UIKit

// MARK: - HelpDetailViewController
final class HelpDetailViewController: ViewBase {

    // MARK: - Outlets

    @IBOutlet weak private var labelQuestion: LinkLabel!
    @IBOutlet weak private var labelAnswer: LinkLabel!

    // MARK: - Variables

    private var presenter: HelpDetailPresenterInterface {
        return presenterInterface as! HelpDetailPresenterInterface
    }
}

// MARK: - HelpDetailViewInterface
extension HelpDetailViewController: HelpDetailViewInterface {

    func showHelp(_ help: HelpData) {
        labelQuestion.text = help.help.attributes.question
        labelAnswer.text = help.help.attributes.answer
    }
}
