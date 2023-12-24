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
    }
    
    private static func registerBasicServices() {
        register {
            CameraAuthProvider()
        }.implements(CameraAuthProviderProtocol.self)
            .scope(.application)
        
        register {
            createSessionManager(cameraAuthProvider: resolve())
        }.scope(.cached)
        
        register {
            CameraManager(captureSession: Resolver.optional())
        }.scope(.cached)
    }
    
    private static func createSessionManager(cameraAuthProvider: CameraAuthProviderProtocol) -> AVCaptureSession? {
        var session: AVCaptureSession?
        
        cameraAuthProvider.checkAuthorizationStatus { isAuthorized in
            guard isAuthorized else {
                debugPrint("[Camera_Authorization_Error]: User not authorized for camera access.")
                return
            }
            let captureSession = AVCaptureSession()
            session = captureSession
        }
        
        return session
    }
}
