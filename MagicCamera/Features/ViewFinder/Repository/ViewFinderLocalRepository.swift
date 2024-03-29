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
    
    /// - Used to get current camera position
    func getCurrentCameraPosition() -> AVCaptureDevice.Position {
        return cameraManager.getCurrentPosition()
    }
    
    /// - Used to get current camera position
    func getCaptureDeviceList() -> [AVCaptureDevice] {
        return cameraManager.captureDevices
    }
    
    /// Used to change the camera direction
    func changeCamera(lens: AVCaptureDevice?) {
        if let lens = lens {
            cameraManager.changeCamera(to: lens.deviceType, position: lens.position)
        } else {
            cameraManager.changeCamera(to: .builtInWideAngleCamera, position: cameraManager.getCurrentPosition() == .front ? .back : .front)
        }
    }
    
    /// - Capture image
    func captureImage() {
        cameraManager.captureImage()
    }
}
