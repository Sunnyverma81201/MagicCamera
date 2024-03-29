//
//  ViewFinderDefaultRepository.swift
//  MagicCamera
//
//  Created by Apoorv Verma on 02/01/24.
//

import Combine
import AVFoundation
import Resolver

final class ViewFinderDefaultRepository: ViewFinderRepositoryProtocol {
    private let localRepository: ViewFinderLocalRepositoryProtocol
    
    init(localRepository: ViewFinderLocalRepositoryProtocol) {
        self.localRepository = localRepository
    }
    
    /// Used to get camera preview
    func getCameraPreview() -> AVCaptureVideoPreviewLayer {
        return localRepository.getCameraPreview()
    }
    
    /// - Used to get current camera position
    func getCurrentCameraPosition() -> AVCaptureDevice.Position {
        return localRepository.getCurrentCameraPosition()
    }
    
    /// - Used to get current camera position
    func getCaptureDeviceList() -> [AVCaptureDevice] {
        return localRepository.getCaptureDeviceList()
    }
    
    /// Used to change the camera direction
    func changeCamera(lens: AVCaptureDevice?) {
        localRepository.changeCamera(lens: lens)
    }
    
    /// - Capture image
    func captureImage() {
        localRepository.captureImage()
    }
}
