//
//  ApplicationCoordinator.swift
//  GeeksforGeeks
//
//  Created by Apoorv Verma on 08/09/23.
//

import UIKit
import SwiftUI
import Combine

final class ApplicationCoordinator: BaseCoordinator {
	// MARK: - Properties
	private var window: UIWindow
	private var subscriptions = Set<AnyCancellable>()
	
	// MARK: - Initializer
	init(window: UIWindow) {
		self.window = window
		super.init()
	}
	
	// MARK: - Functions
	override func start() {
        let viewFinderCoordinator = ViewFinderCoordinator()
        start(coordinator: viewFinderCoordinator)
        
		UITableView.appearance().showsVerticalScrollIndicator = false
		UITableView.appearance().separatorColor = .clear
		UITableView.appearance().separatorStyle = .none
        
		window.rootViewController = navigationController
		window.makeKeyAndVisible()
	}
}

// MARK: - Event Handling
extension ApplicationCoordinator: CoordinatorEventHandler {
	typealias CoordinatorEvent = ApplicationCoordinatorEvent
	
	func handleEvent(_ event: ApplicationCoordinatorEvent) {
		switch event {
		case .didCompleteOnboarding: break
		}
	}
}
