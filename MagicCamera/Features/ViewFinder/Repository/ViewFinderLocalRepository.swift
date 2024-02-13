//
//  ViewFinderLocalRepository.swift
//  MagicCamera
//
//  Created by Apoorv Verma on 02/01/24.
//
import Combine
import AVFoundation
import Resolver
import Foundation

final class ViewFinderLocalRepository: ViewFinderLocalRepositoryProtocol {
    // MARK: Properties
    private let cameraManager: CameraManager
    
    // MARK: Initializer
    init(cameraManager: CameraManager) {
        self.cameraManager = cameraManager
    }
    
    // MARK: Helper Function
    /// Used to get camera preview
    func getCameraPreview() -> AVCaptureVideoPreviewLayer {
        return cameraManager.getPreviewLayer()
    }
    
    /// Used to change the camera direction
    func changeCameraDirection() {
        if cameraManager.getCurrentPosition() == .back {
            cameraManager.changeCamera(to: .builtInWideAngleCamera, position: .front)
        } else {
            cameraManager.changeCamera(to: .builtInWideAngleCamera, position: .back)
        }
    }
}
