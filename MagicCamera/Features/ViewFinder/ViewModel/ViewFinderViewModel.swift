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
        CameraManager.shared.getPreviewLayer()
    }
    
    
    /// - Used to get current camera position
    func getCurrentCameraPosition() {
        self.currentPosition = CameraManager.shared.getCurrentPosition()
    }
    
    /// - Used to get current camera position
    func getCaptureDeviceList() {
        self.devicesList = CameraManager.shared.captureDevices
    }
    
    /// - Used to change the camera
    func changeCamera(lens: AVCaptureDevice?) {
        if let lens = lens {
            CameraManager.shared.changeCamera(to: lens.deviceType, position: lens.position)
        } else {
            CameraManager.shared.changeCamera(to: .builtInWideAngleCamera,
                                              position: CameraManager.shared.getCurrentPosition() == .front ? .back : .front)
        }
    }
    
    /// - Capture image
    func captureImage() {
        CameraManager.shared.captureImage()
    }
}
