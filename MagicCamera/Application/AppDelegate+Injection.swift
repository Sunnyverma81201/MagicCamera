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
            getCameraAuthorisationStatus()
        }
        
        register {
            CameraManager(captureSession: resolve())
        }.scope(.application)
    }
    
    private static func getCameraAuthorisationStatus() {
        var isAuthorized: Bool {
            get async {
                let status = AVCaptureDevice.authorizationStatus(for: .video)
                
                // Determine if the user previously authorized camera access.
                var isAuthorized = status == .authorized
                
                // If the system hasn't determined the user's authorization status,
                // explicitly prompt them for approval.
                if status == .notDetermined {
                    isAuthorized = await AVCaptureDevice.requestAccess(for: .video)
                }
                
                return isAuthorized
            }
        }
    }
    
    private static func createSessionManager(cameraAuthProvider: CameraAuthProviderProtocol) -> AVCaptureSession? {
        var session: AVCaptureSession?
        
        cameraAuthProvider.checkAuthorizationStatus { isAuthorized in
            guard isAuthorized else {
                debugPrint("[Camera_Authorization_Error]: User not authorized for camera access.")
                return
            }
            
            // User is authorized, create the AVCaptureSession
            let captureSession = AVCaptureSession()
            // Perform session configurations as needed
            
            session = captureSession
        }
        
        return session
    }
}
