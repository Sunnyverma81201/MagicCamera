//
//  CameraAuthorisationProvider.swift
//  MagicCamera
//
//  Created by Apoorv Verma on 07/11/23.
//

import Foundation
import AVFoundation

protocol CameraAuthProviderProtocol {
    func checkAuthorizationStatus(completion: @escaping (Bool) -> Void)
    // Add more authorization-related methods as needed
}


class CameraAuthProvider: CameraAuthProviderProtocol {
    //MARK: - Properies
    //MARK: - Initializer
    init(completion: @escaping (AVCaptureSession?) -> Void) {
        checkAuthorizationStatus { isAuthorized in
            guard isAuthorized else {
                completion(nil)
                return
            }
            // Set up the capture session.
            completion(AVCaptureSession())
        }
    }
    //MARK: - Helper functions
    ///Checks the permission for camera and porvides a bool value based on which we can proceed further
    ///- Returns: `@escaping`(Bool) -> Void
    internal func checkAuthorizationStatus(completion: @escaping (Bool) -> Void) {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        if status == .authorized {
            completion(true)
        } else if status == .notDetermined {
            AVCaptureDevice.requestAccess(for: .video) { isAuthorized in
                completion(isAuthorized)
            }
        } else {
            completion(false)
        }
    }
}
