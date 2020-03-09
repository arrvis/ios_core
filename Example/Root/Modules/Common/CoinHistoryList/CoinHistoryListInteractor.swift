//
//  CoinHistoryListInteractor.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/02.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

// MARK: - CoinHistoryListInteractor
final class CoinHistoryListInteractor {

    // MARK: - Variables

    weak var output: CoinHistoryListInteractorOutputInterface?
}

// MARK: - CoinHistoryListInteractorInterface
extension CoinHistoryListInteractor: CoinHistoryListInteractorInterface {

    func fetchReceivedCoinHistoryList(_ page: Int?) {
        fetchPresents(nil, .received, page)
    }

    func fetchSendCoinHistoryList(_ page: Int?) {
        fetchPresents(nil, .send, page)
    }

    func fetchAllCoinHistoryList(_ page: Int?) {
        fetchPresents(nil, .all, page)
    }

    func fetchDepartmentCoinHistoryList(_ page: Int?) {
        fetchPresents(nil, .department, page)
    }

    func fetchReceivedCoinHistoryList(_ userId: String, _ page: Int?) {
        fetchPresents(userId, .received, page)
    }

    func fetchSendCoinHistoryList(_ userId: String, _ page: Int?) {
        fetchPresents(userId, .send, page)
    }

    private func fetchPresents(_ userId: String? = nil, _ type: CoinHistoryListType, _ page: Int?) {
        UserService.fetchPresents(userId, type, page).subscribe(onNext: { [unowned self] response in
            self.output?.fetchCoinHistoryListCompleted(response.data, response.coins, response.users, response.pagenation, UserService.loginUser!)
         }, onError: { [unowned self] error in
             self.output?.handleError(error, nil)
         }).disposed(by: self)
    }

    func removeClap(_ present: Present) {
        PresentsService.deleteClap(present.id).subscribe(onNext: { [unowned self] _ in
            self.output?.updateClapCompleted(present.removeClap(Int(UserService.loginUser!.data.id)!))
        }, onError: { [unowned self] error in
            self.output?.handleError(error, nil)
        }).disposed(by: self)
    }

    func sendClap(_ present: Present) {
        PresentsService.sendClap(present.id).subscribe(onNext: { [unowned self] _ in
            self.output?.updateClapCompleted(present.addClap(Int(UserService.loginUser!.data.id)!))
        }, onError: { [unowned self] error in
            self.output?.handleError(error, nil)
        }).disposed(by: self)
    }
}
