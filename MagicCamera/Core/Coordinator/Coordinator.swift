//
//  Coordinator.swift
//  GeeksforGeeks
//
//  Created by Apoorv Verma on 08/09/23.
//

import UIKit

protocol Coordinator: AnyObject {
	var navigationController: UINavigationController { get set }
	var parentCoordinator: Coordinator? { get set }
	var childCoordinators: [Coordinator] { get set }
	
	func start()
	func start(coordinator: Coordinator)
	func stop()
	func stop(coordinator: Coordinator)
}
