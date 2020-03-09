//
//  CoinHistoryListPresenter.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/02.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import ArrvisCore

// MARK: - CoinHistoryListPresenter
final class CoinHistoryListPresenter: PresenterBase {

    // MARK: - Variables

    private var interactor: CoinHistoryListInteractorInterface {
        return interactorInterface as! CoinHistoryListInteractorInterface
    }

    private weak var view: CoinHistoryListViewInterface? {
        return viewInterface as? CoinHistoryListViewInterface
    }

    private var wireframe: CoinHistoryListWireframeInterface {
        return wireframeInterface as! CoinHistoryListWireframeInterface
    }

    var payload: Any? {
        didSet {
            if let typeWithUserId = typeWithUserId {
                view?.showType(typeWithUserId.0)
            } else {
                view?.showType(type)
            }
        }
    }

    private var type: CoinHistoryListType {
        return payload as! CoinHistoryListType
    }

    private var typeWithUserId: (CoinHistoryListType, String)? {
        return payload as? (CoinHistoryListType, String)
    }

    private var currentPagenation: Pagenation?
    private var isFetching = false

    // MARK: - Life-Cycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        currentPagenation = nil
        if let typeWithUserId = typeWithUserId {
            switch typeWithUserId.0 {
            case .received:
                interactor.fetchReceivedCoinHistoryList(typeWithUserId.1, nil)
            case .send:
                interactor.fetchSendCoinHistoryList(typeWithUserId.1, nil)
            case .all, .department:
                break
            }
        } else {
            switch type {
            case .received:
                interactor.fetchReceivedCoinHistoryList(nil)
            case .send:
                interactor.fetchSendCoinHistoryList(nil)
            case .all:
                interactor.fetchAllCoinHistoryList(nil)
            case .department:
                interactor.fetchDepartmentCoinHistoryList(nil)
            }
        }
    }
}

// MARK: - CoinHistoryListPresenterInterface
extension CoinHistoryListPresenter: CoinHistoryListPresenterInterface {

    func didTapRemoveClap(_ present: Present) {
        interactor.removeClap(present)
    }

    func didTapAddClap(_ present: Present) {
        interactor.sendClap(present)
    }

    func didReachBottom() {
        if isFetching || currentPagenation?.next == nil {
            return
        }
        isFetching = true
        if let typeWithUserId = typeWithUserId {
            switch typeWithUserId.0 {
            case .received:
                interactor.fetchReceivedCoinHistoryList(typeWithUserId.1, currentPagenation?.next)
            case .send:
                interactor.fetchSendCoinHistoryList(typeWithUserId.1, currentPagenation?.next)
            case .all, .department:
                break
            }
        } else {
            switch type {
            case .received:
                interactor.fetchReceivedCoinHistoryList(currentPagenation?.next)
            case .send:
                interactor.fetchSendCoinHistoryList(currentPagenation?.next)
            case .all:
                interactor.fetchAllCoinHistoryList(currentPagenation?.next)
            case .department:
                interactor.fetchDepartmentCoinHistoryList(currentPagenation?.next)
            }
        }
    }
}

// MARK: - CoinHistoryListInteractorOutputInterface
extension CoinHistoryListPresenter: CoinHistoryListInteractorOutputInterface {

    func fetchCoinHistoryListCompleted(_ data: [Present], _ coins: [Coin], _ users: [UserRelation], _ pagenation: Pagenation, _ loginUser: UserData) {
        isFetching = false
        if currentPagenation == nil {
            view?.showCoinHistoryList(data, coins, users, loginUser)
        } else {
            view?.showMoreCoinHistoryList(data, coins, users, loginUser)
        }
        currentPagenation = pagenation
    }

    func updateClapCompleted(_ present: Present) {
        view?.updateData(present)
    }
}
