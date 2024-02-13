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
    
    /// - Used to change camera lens
    func changeCameraDirection()
}

protocol ViewFinderLocalRepositoryProtocol {
    /// - Used to get camera preview
    func getCameraPreview() -> AVCaptureVideoPreviewLayer
    
    /// - Used to change camera lens
    func changeCameraDirection()
}
