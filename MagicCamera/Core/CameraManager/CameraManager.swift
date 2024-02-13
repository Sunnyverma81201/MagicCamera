//
//  CameraManager.swift
//  MagicCamera
//
//  Created by Apoorv Verma on 21/10/23.
//
import AVFoundation
import SwiftUI

class CameraManager: ObservableObject {
    //MARK: - Properties
    
    /// Stores the session for the camera and the configuration
    private(set) var session: AVCaptureSession
    let sessionQueue = DispatchQueue(label: "sessionQueue",attributes: .concurrent)
    
    /// An array of available capture devices
    @Published var captureDevices: [AVCaptureDevice] = []
    
    /// Flag to identify if camera intractions are allowed or not; i.e. camera is in configuration mode
    @Published var isUserInteractionEnabled = false
    
    /// Camera configurations
    private var currentDeviceType: AVCaptureDevice.DeviceType = .builtInWideAngleCamera
    private var currentPosition: AVCaptureDevice.Position = .back
    
    
    /// Stores the selected camera to start the capture session
    //MARK: - Initializer
    init(captureSession: AVCaptureSession?) {
        self.session = captureSession ?? AVCaptureSession()
        self.sessionQueue.sync {
            self.discoverCaptureDevices()
            self.setupCameraSession()
        }
        self.startCaptureSession()
    }
    
    //MARK: - Functions
    ///Configures the capture session according to the variables provided by the user
    fileprivate func setupCameraSession() {
        self.session.beginConfiguration()
        if let videoDevice = AVCaptureDevice.default(self.currentDeviceType,for: .video, position: self.currentPosition) {
            guard let captureInput = try? AVCaptureDeviceInput(device: videoDevice),
                  let captureOutput = try? AVCapturePhotoOutput(),
                  self.session.canAddInput(captureInput),
                  self.session.canAddOutput(captureOutput)
            else {
                return
            }
            self.session.sessionPreset = .photo
            self.session.addInput(captureInput)
            self.session.addOutput(captureOutput)
        }
        self.session.commitConfiguration()
    }
    
    ///- Used to discover available capture devices
    fileprivate func discoverCaptureDevices() {
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera,
                                                                              .builtInTelephotoCamera,
                                                                              .builtInUltraWideCamera
        ], mediaType: .video, position: .unspecified)
        self.captureDevices = discoverySession.devices
    }
    
    fileprivate func startCaptureSession(){
        sessionQueue.async {
            self.session.startRunning()
        }
    }
    
    ///  used to get the preview layer for current session
    ///- Returns: ``AVCaptureVideoPreviewLayer``
    public func getPreviewLayer() -> AVCaptureVideoPreviewLayer {
        return AVCaptureVideoPreviewLayer(session: self.session)
    }
    
    /// used to switch camera
    /// - Parameters:
    ///     - newDevice:``AVCaptureDevice.DeviceType``
    ///     - position: representing the postition of device
    public func changeCamera(to newDevice: AVCaptureDevice.DeviceType, position: AVCaptureDevice.Position) {
        self.session.beginConfiguration()
        if let currentInput = self.session.inputs.first {
            self.session.removeInput(currentInput)
        }
        
        if let newCaptureDevice = AVCaptureDevice.default(newDevice, for: .video, position: position){
            guard let captureInput = try? AVCaptureDeviceInput(device: newCaptureDevice) else { return }
            self.session.addInput(captureInput)
        }
        self.session.commitConfiguration()
        self.currentDeviceType = newDevice
        self.currentPosition = position
    }
    
    /// used to get current capture device
    public func getCurrentPosition() -> AVCaptureDevice.DeviceType {
        return self.currentDeviceType
    }
    
    /// used to get current camera position
    public func getCurrentPosition() -> AVCaptureDevice.Position {
        return self.currentPosition
    }
}
