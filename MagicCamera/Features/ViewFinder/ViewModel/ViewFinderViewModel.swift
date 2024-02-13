//
//  ViewFinderViewModel.swift
//  MagicCamera
//
//  Created by Apoorv Verma on 02/01/24.
//

import Combine
import AVFoundation

final class ViewFinderViewModel: ObservableObject {
    // MARK: - Properties
    private var repository: ViewFinderRepositoryProtocol
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Initializer
    init(repository: ViewFinderRepositoryProtocol) {
        self.repository = repository
    }
    
    // MARK: - Functions
    /// - returns: previewLayer
    func getPreviewLayer() -> AVCaptureVideoPreviewLayer {
        return repository.getCameraPreview()
    }
    
    /// - Used to change the camera
    func changeCameraDirection() {
        repository.changeCameraDirection()
    }
}
