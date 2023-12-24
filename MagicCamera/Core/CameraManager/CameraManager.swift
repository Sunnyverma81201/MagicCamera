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
    private let sessionQueue = DispatchQueue(label: "captureQueue")
    
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
        self.setupCameraSession()
        self.discoverCaptureDevices()
        self.startCaptureSession()
    }
    
    //MARK: - Functions
    ///Configures the capture session according to the variables provided by the user
    fileprivate func setupCameraSession() {
        self.session.beginConfiguration()
        let videoDevice = AVCaptureDevice.default(self.currentDeviceType,for: .video, position: self.currentPosition)
        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice!),
              self.session.canAddInput(videoDeviceInput)
        else {
            return
        }
        self.session.addInput(videoDeviceInput)
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
    
    public func changeCamera(to newDevice: AVCaptureDevice.DeviceType, position: AVCaptureDevice.Position) {
        self.session.beginConfiguration()
        self.session.removeInput(self.session.inputs.first!)
        let videoDevice = AVCaptureDevice.default(newDevice, for: .video, position: position)
        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice!)
        else {
            return
        }
        self.session.addInput(videoDeviceInput)
        self.session.commitConfiguration()
    }
}
