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

    /// レスポンス受信
    open func onResponse<T: GraphQLOperation>(
        _ operation: T,
        _ result: GraphQLResult<T.Data>?,
        _ error: Error?) {}
}

// TODO: Rのnil対応。

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
        onResponse(operation, result, error)
        if let error = error {
            observer.onError(error)
        } else if let errors = result?.errors {
            observer.onError(GraphQLServiceError(errors: errors))
        } else if let resultMap = result?.data?.resultMap {
            if "\(operation.operationType)" == "query" {
                let value = resultMap.first!.value! as! [String: Any?]
                observer.onNext(R.fromObject(value) as! R)
            } else {
                let value = (resultMap.first!.value as! [String: Any?])
                    .first { $0.key != "__typename"}?
                    .value as? [String: Any?]
                if value == nil {
                    let v = resultMap.first!.value! as! [String: Any?]
                    observer.onNext(R.fromObject(v) as! R)
                } else {
                    observer.onNext(R.fromObject(value!) as! R)
                }
            }
            observer.onCompleted()
        } else {
            observer.onCompleted()
        }
    }

    /// Perform
    public func perform<T: GraphQLMutation, R: BaseModel>(_ mutation: T) -> Observable<[R]> {
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
    public func fetch<T: GraphQLQuery, R: BaseModel>(_ query: T) -> Observable<[R]> {
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
        _ observer: AnyObserver<[R]>) {
        onResponse(operation, result, error)
        if let error = error {
            observer.onError(error)
        } else if let errors = result?.errors {
            observer.onError(GraphQLServiceError(errors: errors))
        } else if let resultMap = result?.data?.resultMap {
            if "\(operation.operationType)" == "query" {
                let value = resultMap.first!.value! as! [Any]
                observer.onNext(value.map { R.fromObject($0) as! R })
            } else {
                let value = (resultMap.first!.value as! [String: Any?]).first { $0.key != "__typename"}?.value as? [Any]
                if value == nil {
                    let v = resultMap.first!.value! as! [Any]
                    observer.onNext(v.map { R.fromObject($0) as! R })
                } else {
                    observer.onNext(value!.map { R.fromObject($0) as! R })
                }
            }
        } else {
            observer.onCompleted()
        }
    }
}
