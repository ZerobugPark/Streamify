//
//  NotificationCenterManager.swift
//  Streamify
//
//  Created by Sebin Kwon on 3/25/25.
//

import Foundation
import RxSwift

protocol NotificationCenterHandler {
    var name: Notification.Name { get }
}

extension NotificationCenterHandler {
    func addObserver() -> Observable<Any?> {
        return NotificationCenter.default.rx.notification(name).map { $0.object }
    }

    func post(object: Any? = nil) {
        NotificationCenter.default.post(name: name, object: object, userInfo: nil)
    }
}

enum NotificationCenterManager: NotificationCenterHandler {
    case progress
    case isChanged
    var name: Notification.Name {
        switch self {
        case .progress:
            return Notification.Name("NotificationCenterManager.progress")
        case .isChanged:
            return Notification.Name("isChanged")
        }
    }
    
}
