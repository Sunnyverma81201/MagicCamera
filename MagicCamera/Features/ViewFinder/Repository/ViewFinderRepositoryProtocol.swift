//
//  ViewFinderRepositoryProtocol.swift
//  MagicCamera
//
//  Created by Apoorv Verma on 16/12/23.
//

import Combine
import AVFoundation

protocol ViewFinderRepositoryProtocol {
    /// - Used to get camera Preview
    func getCameraPreview() -> AVCaptureVideoPreviewLayer
    
    /// - Used to get current camera position
    func getCurrentCameraPosition() -> AVCaptureDevice.Position
    
    /// - Used to get current camera position
    func getCaptureDeviceList() -> [AVCaptureDevice]
    
    /// - Used to change camera lens
    func changeCamera(lens: AVCaptureDevice?)
    
    /// - Capture image
    func captureImage()
}

protocol ViewFinderLocalRepositoryProtocol {
    /// - Used to get camera preview
    func getCameraPreview() -> AVCaptureVideoPreviewLayer
    
    /// - Used to get current camera position
    func getCurrentCameraPosition() -> AVCaptureDevice.Position
    
    /// - Used to get current camera position
    func getCaptureDeviceList() -> [AVCaptureDevice]
    
    /// - Used to change camera lens
    func changeCamera(lens: AVCaptureDevice?)
    
    /// - Capture image
    func captureImage()
}
