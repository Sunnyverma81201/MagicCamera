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
    
    /// Used to change the camera direction
    func changeCameraDirection() {
        localRepository.changeCameraDirection()
    }
}
