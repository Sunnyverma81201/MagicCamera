//
//  AppDelegate+Injection.swift
//  MarkAR
//
//  Created by Apoorv Verma on 03/09/23.
// 

import Foundation
import AVFoundation
import Resolver

extension Resolver: ResolverRegistering {
    public static func registerAllServices() {
        //Start Registering services here
        registerBasicServices()
        registerViewFinderServices()
    }
    
    private static func registerBasicServices() {

    }
    
    private static func registerViewFinderServices() {
        register{
            ViewFinderViewModel(repository: resolve())
        }
        
        register {
            ViewFinderDefaultRepository(localRepository: resolve())
        }.implements(ViewFinderRepositoryProtocol.self)
        
        register {
            ViewFinderLocalRepository(cameraManager: CameraManager.shared)
        }.implements(ViewFinderLocalRepositoryProtocol.self)
        
    }
    
    
}
