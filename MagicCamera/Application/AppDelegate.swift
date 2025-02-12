//
//  MarkARApp.swift
//  MarkAR
//
//  Created by Apoorv Verma on 19/08/23.
//
import SwiftUI
import AVFoundation
import Resolver

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
        Resolver.registerAllServices()
        return true
    }
}
