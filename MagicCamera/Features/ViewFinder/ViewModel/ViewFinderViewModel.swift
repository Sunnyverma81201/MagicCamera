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
    @Published var currentPosition: AVCaptureDevice.Position = .back
    @Published var devicesList = [AVCaptureDevice]()
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Initializer
    init(repository: ViewFinderRepositoryProtocol) {
        self.repository = repository
        self.getCaptureDeviceList()
        self.getCurrentCameraPosition()
    }
    
    // MARK: - Functions
    /// - returns: previewLayer
    func getPreviewLayer() -> AVCaptureVideoPreviewLayer {
        return repository.getCameraPreview()
    }
    
    
    /// - Used to get current camera position
    func getCurrentCameraPosition() {
        self.currentPosition = repository.getCurrentCameraPosition()
    }
    
    /// - Used to get current camera position
    func getCaptureDeviceList() {
        self.devicesList = repository.getCaptureDeviceList()
    }
    
    /// - Used to change the camera
    func changeCamera(lens: AVCaptureDevice?) {
        repository.changeCamera(lens: lens)
    }
    
    /// - Capture image
    func captureImage() {
        repository.captureImage()
    }
}
