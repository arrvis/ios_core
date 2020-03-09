//
//  AppScreens.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/10/01.
//  Copyright © 2019 grabss corporation. All rights reserved.
//

import ArrvisCore

/// アプリスクリーン定義
enum AppScreens: String, Screen, CaseIterable {
    case latestNotifications
    case selectMember
    case selectGroup
    case coinHistoryList
    case reportMessage
    case attachmentPreview
    case userProfile

    case splash
    case top
    case login
    case requestPermissions
    case walkthrough

    case main
    
    case homeTop
    case editComment
    case exchangeCoinList
    case exchangeCoinDetail
    case exchangeCoinCompleted

    case groupTop
    case groupCreation
    case groupChat
    case groupSetting
    case groupMemberList
    
    case notificationTop
    case notificationDetail
    case notificationCreation
    case editApprovalConfirmation
    
    case coinTop
    case sendCoin
    case selectCoin
    
    case moreTop
    case selectFontSize
    case help
    case helpDetail

    var path: String {
        return rawValue
    }

    var transition: NavigateTransions {
        switch self {
        case .splash, .top, .requestPermissions, .walkthrough, .main:
            return .replace
        case .latestNotifications, .attachmentPreview, .userProfile, .editComment, .exchangeCoinList, .notificationCreation, .notificationDetail, .sendCoin, .reportMessage, .help:
            return .present
        default:
            return .push
        }
    }

    func createViewController(_ payload: Any? = nil) -> UIViewController {
        let vc: UIViewController
        switch self {
        case .latestNotifications:
            vc = LatestNotificationsWireframe.generateModule(payload)
        case .selectMember:
            vc = SelectMemberWireframe.generateModule(payload)
        case .selectGroup:
            vc = SelectGroupWireframe.generateModule(payload)
        case .coinHistoryList:
            vc = CoinHistoryListWireframe.generateModule(payload)
        case .reportMessage:
            vc = ReportMessageWireframe.generateModule(payload)
        case .attachmentPreview:
            vc = AttachmentPreviewWireframe.generateModule(payload)
        case .userProfile:
            vc = UserProfileWireframe.generateModule(payload)

        case .splash:
            vc = SplashWireframe.generateModule(payload)
        case .top:
            vc = TopWireframe.generateModule(payload)
        case .login:
            vc = LoginWireframe.generateModule(payload)
        case .requestPermissions:
            vc = RequestPermissionsWireframe.generateModule(payload)
        case .walkthrough:
            vc = WalkthroughWireframe.generateModule(payload)

        case .main:
            vc = MainWireframe.generateModule(payload)
            
        case .homeTop:
            vc = HomeTopWireframe.generateModule(payload)
        case .editComment:
            vc = EditCommentWireframe.generateModule(payload)
        case .exchangeCoinList:
            vc = ExchangeCoinListWireframe.generateModule(payload)
        case .exchangeCoinDetail:
            vc = ExchangeCoinDetailWireframe.generateModule(payload)
        case .exchangeCoinCompleted:
            vc = ExchangeCoinCompletedWireframe.generateModule(payload)

        case .groupTop:
            vc = GroupTopWireframe.generateModule(payload)
        case .groupCreation:
            vc = GroupCreationWireframe.generateModule(payload)
        case .groupChat:
            vc = GroupChatWireframe.generateModule(payload)
        case .groupSetting:
            vc = GroupSettingWireframe.generateModule(payload)
        case .groupMemberList:
            vc = GroupMemberListWireframe.generateModule(payload)
            
        case .notificationTop:
            vc = NotificationTopWireframe.generateModule(payload)
        case .notificationDetail:
            vc = NotificationDetailWireframe.generateModule(payload)
        case .notificationCreation:
            vc = NotificationCreationWireframe.generateModule(payload)
        case .editApprovalConfirmation:
            vc = EditApprovalConfirmationWireframe.generateModule(payload)

        case .coinTop:
            vc = CoinTopWireframe.generateModule(payload)
        case .sendCoin:
            vc = SendCoinWireframe.generateModule(payload)
        case .selectCoin:
            vc = SelectCoinWireframe.generateModule(payload)
            
        case .moreTop:
            vc = MoreTopWireframe.generateModule(payload)
        case .selectFontSize:
            vc = SelectFontSizeWireframe.generateModule(payload)
        case .help:
            vc = HelpWireframe.generateModule(payload)
        case .helpDetail:
            vc = HelpDetailWireframe.generateModule(payload)
        }
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
}

