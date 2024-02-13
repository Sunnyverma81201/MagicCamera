//
//  ViewFinderCoordinator.swift
//  MagicCamera
//
//  Created by Apoorv Verma on 15/10/23.
//

import SwiftUI
import Combine
import Resolver

final class ViewFinderCoordinator: BaseCoordinator {
    private var subscriptions = Set<AnyCancellable>()
    
    override func start() {
        let viewFinder = ViewFinder()
        
        viewFinder.eventHandler
            .mapToResult()
            .sink(receiveValue: { [weak self] value in
                if case let .success(event) = value {
                    self?.handleEvent(event)
                }
            })
            .store(in: &subscriptions)
        let viewFinderViewController = UIHostingController(rootView: viewFinder)
        navigationController.pushViewController(viewFinderViewController, animated: false)
    }
}

extension ViewFinderCoordinator: CoordinatorEventHandler {
    typealias CoordinatorEvent = ViewFinderCoordinatorEvent
    
    func handleEvent(_ event: ViewFinderCoordinatorEvent) {
        switch event {
             
        }
    }
}
