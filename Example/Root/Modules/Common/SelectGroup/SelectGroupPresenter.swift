//
//  SelectGroupPresenter.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 18/01/2020.
//  Copyright © 2020 grabss corporation.. All rights reserved.
//

import ArrvisCore

// MARK: - SelectGroupPresenter
final class SelectGroupPresenter: PresenterBase {

    // MARK: - Variables

    private var interactor: SelectGroupInteractorInterface {
        return interactorInterface as! SelectGroupInteractorInterface
    }

    private weak var view: SelectGroupViewInterface? {
        return viewInterface as? SelectGroupViewInterface
    }

    private var wireframe: SelectGroupWireframeInterface {
        return wireframeInterface as! SelectGroupWireframeInterface
    }

    private var groups = [ResponsedGroup]()

    private var selectedGroups: [ResponsedGroup] {
        return (payload as? [ResponsedGroup]) ?? []
    }

    // MARK: - Life-Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view?.showLoading()
        interactor.fetchGroups()
    }
}

// MARK: - SelectGroupPresenterInterface
extension SelectGroupPresenter: SelectGroupPresenterInterface {

    func didTapDone(_ selectedGroups: [ResponsedGroup]) {
        wireframe.popScreen(result: (selectedGroups, groups.count))
    }
}

// MARK: - SelectGroupInteractorOutputInterface
extension SelectGroupPresenter: SelectGroupInteractorOutputInterface {

    func fetchGroupsCompleted(_ groups: [ResponsedGroup]) {
        self.groups = groups
        view?.hideLoading()
        view?.showGroups(groups, selectedGroups)
    }
}
