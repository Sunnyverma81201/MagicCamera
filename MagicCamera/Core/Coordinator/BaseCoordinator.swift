//
//  BaseCoordinator.swift
//  GeeksforGeeks
//
//  Created by Apoorv Verma on 08/09/23.
//

import UIKit
import SafariServices

class BaseCoordinator: NSObject, Coordinator {
	// MARK: - Properties
	var childCoordinators: [Coordinator] = []
	var parentCoordinator: Coordinator?
	var navigationController = UINavigationController()
	
	// MARK: - Functions
	func start() {
		fatalError("start() must be implemented by the child coordinator")
	}
	
	func start(coordinator: Coordinator) {
		childCoordinators.append(coordinator)
		coordinator.parentCoordinator = self
		coordinator.navigationController = navigationController
		coordinator.start()
	}
	
	func stop() {
		parentCoordinator?.stop(coordinator: self)
		if navigationController.presentedViewController != nil {
			navigationController.dismiss(animated: true, completion: nil)
		} else {
			navigationController.popViewController(animated: true)
		}
	}
	
	func stop(coordinator: Coordinator) {
		if let coordinatorIndex = childCoordinators.firstIndex(where: { $0 === coordinator }) {
			childCoordinators.remove(at: coordinatorIndex)
		}
	}
}

// MARK: - Helper Functions
extension BaseCoordinator {
    
    /// Method to pop a specific number of controllers from navigation stack.
    /// - Parameter -  numberOfControllers: number of controllers to pop.
    func popBack(by numberOfControllers: Int) {
        let viewControllers = navigationController.viewControllers
        if numberOfControllers >= viewControllers.count { return }
        let toViewController = viewControllers[viewControllers.count - numberOfControllers - 1]
        removeChildCoordinators(numberOfCoordinators: numberOfControllers)
        navigationController.popToViewController(toViewController, animated: true)
    }
    
    private func removeChildCoordinators(numberOfCoordinators: Int) {
        var parentCoordinator = self.parentCoordinator
        var childCoordinator = self as Coordinator
        for _ in 0..<numberOfCoordinators {
            parentCoordinator?.stop(coordinator: childCoordinator)
            childCoordinator = parentCoordinator!
            parentCoordinator = parentCoordinator?.parentCoordinator
        }
    }
    
    
    func handleShareEvent(url: URL) {
        let popoverWidth = UIScreen.main.bounds.width / 2
        let popoverHeight = UIScreen.main.bounds.height / 2
        let activityController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        if UIDevice.current.userInterfaceIdiom == .pad, let mainWindow = UIApplication.shared.windows.first {
            activityController.popoverPresentationController?.sourceView = mainWindow
            activityController.popoverPresentationController?.sourceRect = CGRect(x: popoverWidth/2, y: popoverHeight/2, width: popoverWidth, height: popoverHeight)
            activityController.popoverPresentationController?.permittedArrowDirections = []
        }
        navigationController.present(activityController, animated: true, completion: nil)
    }
    
    /// to present UIAlertViewController.
    /// - Parameters:
    ///  - title: alert title.
    ///  - message: alert message.
    ///  - cancelTitle : cancel button title.
    ///  - actionTitle: action button title.
    ///  - cancelAction: cancel action handler
    ///  - action: action handler.
    func showAlert(title: String,
                   message: String,
                   cancelTitle: String = "OK",
                   actionTitle: String? = nil,
                   cancelAction: @escaping () -> Void = {},
                   action: @escaping () -> Void = {}) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if let _actionTitle = actionTitle {
            let action = UIAlertAction(title: _actionTitle, style: .default){ _ in action()}
            alertController.addAction(action)
        }
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel){ _ in cancelAction() }
        alertController.addAction(cancelAction)
        navigationController.present(alertController, animated: true)
    }
}

// MARK: - SafariViewController Delegate
extension BaseCoordinator: SFSafariViewControllerDelegate {
	func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
		navigationController.popViewController(animated: true)
	}
}
