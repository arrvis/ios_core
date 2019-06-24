//
//  EventKitService.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2019/06/23.
//  Copyright © 2019 Arrvis Co., Ltd. All rights reserved.
//

import Foundation
import EventKit
import RxSwift

/// EventKitサービス
public final class EventKitService {

    // MARK: - Variables

    /// DisposeBag
    public static let disposeBag = DisposeBag()

    /// EventStore
    public static let eventStore = EKEventStore()
}

extension EventKitService {

    /// EventStoreへのアクセス許可リクエスト
    public static func requestAuthorizationIfNeed() -> Observable<Void> {
        return Observable.create { observer in
            let status = EKEventStore.authorizationStatus(for: .event)
            switch status {
            case .authorized:
                observer.onNext(())
            case .notDetermined:
                eventStore.requestAccess(to: .event) { (granted, _) in
                    if granted {
                        observer.onNext(())
                    } else {
                        observer.onError(PermissionError())
                    }
                }
            case .denied, .restricted:
                observer.onError(PermissionError())
            @unknown default:
                fatalError()
            }
            return Disposables.create()
        }
    }

    /// イベントフェッチ
    public static func fetchEvents(_ rangeYear: Int,
                                   _ monthRange: Int,
                                   _ lastSyncTime: Date?) -> Observable<[EKEvent]> {
        func fetchMonthEvents(_ month: Date) -> Observable<[EKEvent]> {
            return Observable.create({ observer in
                let predicate = eventStore.predicateForEvents(withStart: month,
                                                              end: month.plusMonth(1),
                                                              calendars: eventStore.calendars(for: .event))
                let events = eventStore.events(matching: predicate)
                    .filter { $0.hasRecurrenceRules ? eventStore.event(withIdentifier: $0.eventIdentifier) == $0 : true}
                    .filter { lastSyncTime == nil || $0.lastModifiedDate == nil
                        ? true
                        : $0.lastModifiedDate! > lastSyncTime! }
                if !events.isEmpty {
                    observer.onNext(events)
                }
                observer.onCompleted()
                return Disposables.create()
            })
        }
        var months = Date.getMonths(start: Date.now.startOfDay.plusMonth(-monthRange / 2),
                                    end: Date.now.startOfDay.plusMonth(monthRange / 2))
        months.append(contentsOf: Date.getMonths(start: Date.now.startOfDay.plusYear(-rangeYear),
                                                 end: Date.now.startOfDay.plusMonth(-monthRange / 2)))
        months.append(contentsOf: Date.getMonths(start: Date.now.startOfDay.plusMonth(monthRange / 2),
                                                 end: Date.now.startOfDay.plusYear(rangeYear)))
        return Observable.merge(months.map { fetchMonthEvents($0)})
    }
}
