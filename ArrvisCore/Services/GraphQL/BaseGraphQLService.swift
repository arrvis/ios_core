//
//  BaseGraphQLService.swift
//  Arrvis
//
//  Created by Yutaka Izumaru on 2018/02/05.
//  Copyright © 2018年 Arrvis Co., Ltd. All rights reserved.
//

import RxSwift
import Apollo

/// GraphQLサービス基底クラス
open class BaseGraphQLService {

    /// DisposeBag
    let disposeBag = DisposeBag()

    private init() {}
}

/// GraphQLServiceプロトコル
public protocol GraphqlServiceProtocol {
    func fetchClient(request: @escaping (ApolloClient) -> Void, onError: ((Error) -> Void)?, useNonAuth: Bool)
}

// MARK: - GraphqlServiceProtocol
extension BaseGraphQLService: GraphqlServiceProtocol {

    /// ApolloClientフェッチ
    public func fetchClient(request: @escaping (ApolloClient) -> Void, onError: ((Error) -> Void)?, useNonAuth: Bool) {
        fatalError("Not implemented.")
    }
}

// TODO: mapでいいか検討
extension BaseGraphQLService {

    /// Perform
    public func perform<T: GraphQLMutation, R: BaseModel>(
        _ mutation: T,
        _ parse: ((T.Data, (R?, Error?) -> Void) -> Void)? = nil) -> Observable<R> {
        return Observable.create { [unowned self] observer in
            self.fetchClient(request: { apolloClient in
                apolloClient.perform(mutation: mutation) { [unowned self]  result, error in
                    self.handleResponse(mutation, result, error, parse, observer)
                }
            }, onError: { error in
                observer.onError(error)
            }, useNonAuth: false)
            return Disposables.create()
        }
    }

    /// Fetch
    public func fetch<T: GraphQLQuery, R: BaseModel>(
        _ query: T,
        _ parse: ((T.Data, (R?, Error?) -> Void) -> Void)? = nil) -> Observable<R> {
        return Observable.create { [unowned self]  observer in
            self.fetchClient(request: { apolloClient in
                apolloClient.fetch(query: query) { [unowned self]  result, error in
                    self.handleResponse(query, result, error, parse, observer)
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
        _ parse: ((T.Data, (R?, Error?) -> Void) -> Void)?,
        _ observer: AnyObserver<R>) {
        if let error = error {
            observer.onError(error)
        } else if let errors = result?.errors {
            observer.onError(GraphQLServiceError(errors: errors))
        } else if let data = result?.data {
            if let parse = parse {
                parse(data) { parsed, error in
                    if let error = error {
                        observer.onError(error)
                    } else if let parsed = parsed {
                        observer.onNext(parsed)
                        observer.onCompleted()
                    } else {
                        observer.onCompleted()
                    }
                }
            } else {
                observer.onNext(data as! R)
                observer.onCompleted()
            }
        } else {
            observer.onCompleted()
        }
    }
}
