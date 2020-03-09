//
//  MainPresenter.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/03.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import ArrvisCore

// MARK: - MainPresenter
final class MainPresenter: PresenterBase {

    // MARK: - Variables

    private var interactor: MainInteractorInterface {
        return interactorInterface as! MainInteractorInterface
    }

    private weak var view: MainViewInterface? {
        return viewInterface as? MainViewInterface
    }

    private var wireframe: MainWireframeInterface {
        return wireframeInterface as! MainWireframeInterface
    }

    // MARK: - Life-Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view?.showLoading()
        interactor.loadData()
    }
}

// MARK: - MainPresenterInterface
extension MainPresenter: MainPresenterInterface {
}

// MARK: - MainInteractorOutputInterface
extension MainPresenter: MainInteractorOutputInterface {

    func loadDataCompleted() {
        view?.hideLoading()
        view?.showViewControllers()
    }

    func fetchBadgeCountsCompleted(_ footer: Footer) {
        view?.showBadgeCounts(footer)
    }
}
