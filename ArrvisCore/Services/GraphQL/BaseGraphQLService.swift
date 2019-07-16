//
//  BaseGraphQLService.swift
//  Arrvis
//
//  Created by Yutaka Izumaru on 2018/02/05.
//  Copyright © 2018年 Arrvis Co., Ltd. All rights reserved.
//

import RxSwift
import Apollo

/// GraphQLServiceプロトコル
protocol GraphqlServiceProtocol {
    func fetchClient(request: @escaping (ApolloClient) -> Void, onError: ((Error) -> Void)?, useNonAuth: Bool)
}

/// GraphQLサービス基底クラス
open class BaseGraphQLService: GraphqlServiceProtocol {

    /// DisposeBag
    let disposeBag = DisposeBag()

    public init() {}

    // MARK: - GraphqlServiceProtocol

    /// ApolloClientフェッチ
    open func fetchClient(request: @escaping (ApolloClient) -> Void, onError: ((Error) -> Void)?, useNonAuth: Bool) {
        fatalError("Not implemented.")
    }
}

// MARK: - Public
extension BaseGraphQLService {

    /// Perform
    public func perform<T: GraphQLMutation, R: BaseModel>(_ mutation: T) -> Observable<R> {
        return Observable.create { [unowned self] observer in
            self.fetchClient(request: { apolloClient in
                apolloClient.perform(mutation: mutation) { [unowned self]  result, error in
                    self.handleResponse(mutation, result, error, observer)
                }
            }, onError: { error in
                observer.onError(error)
            }, useNonAuth: false)
            return Disposables.create()
        }
    }

    /// Fetch
    public func fetch<T: GraphQLQuery, R: BaseModel>(_ query: T) -> Observable<R> {
        return Observable.create { [unowned self]  observer in
            self.fetchClient(request: { apolloClient in
                apolloClient.fetch(query: query) { [unowned self]  result, error in
                    self.handleResponse(query, result, error, observer)
                }
            }, onError: { error in
                observer.onError(error)
            }, useNonAuth: false)
            return Disposables.create()
        }
    }

    private func handleResponse<T: GraphQLOperation, R: BaseModel>(
        _ operation: T,
        _ result: GraphQLResult<T.Data>?,
        _ error: Error?,
        _ observer: AnyObserver<R>) {
        if let error = error {
            observer.onError(error)
        } else if let errors = result?.errors {
            observer.onError(GraphQLServiceError(errors: errors))
        } else if let resultMap = result?.data?.resultMap {
            observer.onNext(R.fromObject(object: resultMap.first!.value!) as! R)
            observer.onCompleted()
        } else {
            observer.onCompleted()
        }
    }
}
