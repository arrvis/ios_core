//
//  CoinHistoryListInterfaces.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/02.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import ArrvisCore

protocol CoinHistoryListViewInterface: ViewInterface {
    func showType(_ type: CoinHistoryListType)
    func showCoinHistoryList(_ data: [Present], _ coins: [Coin], _ users: [UserRelation], _ loginUser: UserData)
    func showMoreCoinHistoryList(_ data: [Present], _ coins: [Coin], _ users: [UserRelation], _ loginUser: UserData)
    func updateData(_ present: Present)
}

protocol CoinHistoryListPresenterInterface: PresenterInterface {
    func didTapRemoveClap(_ present: Present)
    func didTapAddClap(_ present: Present)
    func didReachBottom()
}

protocol CoinHistoryListInteractorInterface: InteractorInterface {
    func fetchReceivedCoinHistoryList(_ page: Int?)
    func fetchSendCoinHistoryList(_ page: Int?)
    func fetchAllCoinHistoryList(_ page: Int?)
    func fetchDepartmentCoinHistoryList(_ page: Int?)
    func fetchReceivedCoinHistoryList(_ userId: String, _ page: Int?)
    func fetchSendCoinHistoryList(_ userId: String, _ page: Int?)
    func removeClap(_ present: Present)
    func sendClap(_ present: Present)
}

protocol CoinHistoryListInteractorOutputInterface: InteractorOutputInterface {
    func fetchCoinHistoryListCompleted(_ data: [Present], _ coins: [Coin], _ users: [UserRelation], _ pagenation: Pagenation, _ loginUser: UserData)
    func updateClapCompleted(_ present: Present)
}

protocol CoinHistoryListWireframeInterface: WireframeInterface {
}
