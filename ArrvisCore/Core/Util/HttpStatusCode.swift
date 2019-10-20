//
//  HttpStatusCode.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2015/04/22.
//  Copyright © 2015年 Arrvis Co.,Ltd. All rights reserved.
//

/// HTTPステータスコード列挙型
///
/// - cContinue: 継続 クライアントはリクエストを継続できる。
/// - switchingProtocols: プロトコル切り替え サーバはリクエストを理解し、遂行のためにプロトコルの切り替えを要求している
/// - processing: 処理中 WebDAVの拡張ステータスコード。処理が継続して行われていることを示す。
/// - ok: OK リクエストは成功し、レスポンスとともに要求に応じた情報が返される。
/// - created: 作成 リクエストは完了し、新たに作成されたリソースのURIが返される。
/// - accepted: 受理 リクエストは受理されたが、処理は完了していない。
/// - nonAuthoritativeInformation: 信頼できない情報 オリジナルのデータではなく、ローカルやプロキシ等からの情報であることを示す。
/// - noContent: 内容なし リクエストを受理したが、返すべきレスポンスエンティティが存在しない場合に返される。
/// - resetContent: 内容のリセット リクエストを受理し、ユーザエージェントの画面をリセットする場合に返される。
/// - partialContent: 部分的内容 部分的GETリクエストを受理したときに、返される。
/// - multiStatus: 複数のステータス WebDAVの拡張ステータスコード。
/// - IMUsed: IM使用 Delta encoding in HTTPの拡張ステータスコード。
/// - multipleChoices: 複数の選択 リクエストしたリソースが複数存在し、ユーザやユーザーエージェントに選択肢を提示するときに返される。
/// - movedPermanently: 恒久的に移動した リクエストしたリソースが恒久的に移動されているときに返される。Location:ヘッダに移動先のURLが示されている。
/// - found: 発見した リクエストしたリソースが一時的に移動されているときに返される。Location:ヘッダに移動先のURLが示されている。
/// - seeOther: 他を参照せよ リクエストに対するレスポンスが他のURLに存在するときに返される。Location:ヘッダに移動先のURLが示されている。
/// - notModified: 未更新 リクエストしたリソースは更新されていないことを示す。
/// - useProxy: プロキシを使用せよ レスポンスのLocation:ヘッダに示されるプロキシを使用してリクエストを行わなければならないことを示す。
/// - unUsed: 将来のために予約されている。ステータスコードは前のバージョンの仕様書では使われていたが、もはや使われておらず、将来のために予約されているとされる。
/// - temporaryRedirect: 一時的リダイレクト リクエストしたリソースは一時的に移動されているときに返される。Location:ヘッダに移動先のURLが示されている。
/// - badRequest: リクエストが不正である 定義されていないメソッドを使うなど、クライアントのリクエストがおかしい場合に返される。
/// - unauthorized: 認証が必要である Basic認証やDigest認証などを行うときに使用される。
/// - paymentRequired: 支払いが必要である 現在は実装されておらず、将来のために予約されているとされる。
/// - forbidden: 禁止されている リソースにアクセスすることを拒否された。
/// - notFound: 未検出 リソースが見つからなかった。
/// - methodNotAllowed: 許可されていないメソッド 許可されていないメソッドを使用しようとした。
/// - notAcceptable: 受理できない Accept関連のヘッダに受理できない内容が含まれている場合に返される。
/// - proxyAuthenticationRequired: プロキシ認証が必要である プロキシの認証が必要な場合に返される。
/// - requestTimeout: リクエストタイムアウト リクエストが時間以内に完了していない場合に返される。
/// - conflict: 矛盾 要求は現在のリソースと矛盾するので完了できない。
/// - gone: 消滅した。ファイルは恒久的に移動した。
/// - lengthRequired: 長さが必要 Content-Lengthヘッダがないのでサーバーがアクセスを拒否した場合に返される。
/// - preconditionFailed: 前提条件で失敗した 前提条件が偽だった場合に返される。
/// - requestEntityTooLarge: リクエストエンティティが大きすぎる リクエストエンティティがサーバの許容範囲を超えている場合に返す。
/// - requestURITooLong: リクエストURIが大きすぎる URIが長過ぎるのでサーバが処理を拒否した場合に返す。
/// - unsupportedMediaType: サポートしていないメディアタイプ 指定されたメディアタイプがサーバでサポートされていない場合に返す。
/// - requestedRangeNotSatisfiable: リクエストしたレンジは範囲外にある 実ファイルのサイズを超えるデータを要求した。
/// - expectationFailed: Expectヘッダによる拡張が失敗 その拡張はレスポンスできない。またはプロキシサーバは、次に到達するサーバがレスポンスできないと判断している。
/// - imaTeapot: 私はティーポット HTCPCP/1.0の拡張ステータスコード。
/// - unprocessableEntity: 処理できないエンティティ WebDAVの拡張ステータスコード。
/// - locked: ロックされている WebDAVの拡張ステータスコード。リクエストしたリソースがロックされている場合に返す。
/// - failedDependency: 依存関係で失敗 WebDAVの拡張ステータスコード。
/// - upgradeRequired: アップグレード要求 Upgrading to TLS Within HTTP/1.1の拡張ステータスコード。
/// - internalServerError: サーバ内部エラー サーバ内部にエラーが発生した場合に返される。
/// - notImplemented: 実装されていない 実装されていないメソッドを使用した。
/// - badGateway: 不正なゲートウェイ ゲートウェイ・プロキシサーバは不正な要求を受け取り、これを拒否した。
/// - serviceUnavailable: サービス利用不可 サービスが一時的に過負荷やメンテナンスで使用不可能である。
/// - gatewayTimeout: ゲートウェイタイムアウト ゲートウェイ・プロキシサーバはURIから推測されるサーバからの適切なレスポンスがなくタイムアウトした。
/// - httpVersionNotSupported: サポートしていないHTTPバージョン リクエストがサポートされていないHTTPバージョンである場合に返される。
/// - variantAlsoNegotiates: Transparent Content Negotiation in HTTPで定義されている拡張ステータスコード。
/// - insufficientStorage: 容量不足 WebDAVの拡張ステータスコード。リクエストを処理するために必要なストレージの容量が足りない場合に返される。
/// - bandwidthLimitExceeded: 帯域幅制限超過 そのサーバに設定されている帯域幅（転送量）を使い切った場合に返される。
/// - notExtended: 拡張できない An HTTP Extension Frameworkで定義されている拡張ステータスコード。
public enum HttpStatusCode: Int {

    case cContinue = 100

    case switchingProtocols = 101

    case processing = 102

    case ok = 200

    case created = 201

    case accepted = 202

    case nonAuthoritativeInformation = 203

    case noContent = 204

    case resetContent = 205

    case partialContent = 206

    case multiStatus = 207

    case IMUsed = 226

    case multipleChoices = 300

    case movedPermanently = 301

    case found = 302

    case seeOther = 303

    case notModified = 304

    case useProxy = 305

    case unUsed = 306

    case temporaryRedirect = 307

    case badRequest = 400

    case unauthorized = 401

    case paymentRequired = 402

    case forbidden = 403

    case notFound = 404

    case methodNotAllowed = 405

    case notAcceptable = 406

    case proxyAuthenticationRequired = 407

    case requestTimeout = 408

    case conflict = 409

    case gone = 410

    case lengthRequired = 411

    case preconditionFailed = 412

    case requestEntityTooLarge = 413

    case requestURITooLong = 414

    case unsupportedMediaType = 415

    case requestedRangeNotSatisfiable = 416

    case expectationFailed = 417

    case imaTeapot = 418

    case unprocessableEntity = 422

    case locked = 423

    case failedDependency = 424

    case upgradeRequired = 426

    case internalServerError = 500

    case notImplemented = 501

    case badGateway = 502

    case serviceUnavailable = 503

    case gatewayTimeout = 504

    case httpVersionNotSupported = 505

    case variantAlsoNegotiates = 506

    case insufficientStorage = 507

    case bandwidthLimitExceeded = 509

    case notExtended = 510
}
