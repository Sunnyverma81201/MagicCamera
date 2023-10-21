//
//  SceneDelegate.swift
//  MarkAR
//
//  Created by Apoorv Verma on 08/09/23.
//

import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    // MARK: - Properties
    var window: UIWindow?
    private var applicationCoordinator: ApplicationCoordinator?
    
    // MARK: - Functions
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions)
    {
        
        guard let windowScene = (scene as? UIWindowScene) else {
            return
        }
        let window = UIWindow(windowScene: windowScene)
        applicationCoordinator = ApplicationCoordinator(window: window)
        applicationCoordinator?.start()
    }
}
