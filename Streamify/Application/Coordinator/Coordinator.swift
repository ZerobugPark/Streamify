//
//  Coordinator.swift
//  Streamify
//
//  Created by 조다은 on 3/22/25.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    func start()
}
