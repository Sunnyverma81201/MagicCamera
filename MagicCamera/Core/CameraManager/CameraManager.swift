//
//  CameraManager.swift
//  MagicCamera
//
//  Created by Apoorv Verma on 21/10/23.
//
import AVFoundation
import SwiftUI
import Photos

final class CameraManager {
    //MARK: - Properties
    static let shared: CameraManager = .init()
    
    /// Stores the session for the camera and the configuration
    private(set) var session: AVCaptureSession = AVCaptureSession()

    /// An array of available capture devices
    var captureDevices: [AVCaptureDevice] = []
    
    /// Flag to identify if camera intractions are allowed or not; i.e. camera is in configuration mode
    var isUserInteractionEnabled = false

    /// Camera configurations
    private var currentDeviceType: AVCaptureDevice.DeviceType = .builtInWideAngleCamera
    private var currentPosition: AVCaptureDevice.Position = .back

    @preconcurrency let sessionQueue = DispatchQueue(label: "sessionQueue",qos: .userInitiated)
    
    /// Photo Output
    let photoOutput = AVCapturePhotoOutput()
    
    /// Media Manager
    let mediaManager = MediaManager.shared
    
    /// Stores the selected camera to start the capture session
    //MARK: - Initializer
    private init() {
        guard let session = CameraManager.createSessionManager() else { return }
        self.session = session
        self.sessionQueue.sync {
            self.discoverCaptureDevices()
            self.setupCameraSession()
        }
        self.startCaptureSession()
    }
    
    internal static func checkAuthorizationStatus(completion: @escaping (Bool) -> Void) {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { isAuthorized in
                completion(isAuthorized)
            }
        case .authorized:
            completion(true)
        default:
            completion(false)
        }
    }
    
    private static func createSessionManager() -> AVCaptureSession? {
        var session: AVCaptureSession?
        
        self.checkAuthorizationStatus { isAuthorized in
            guard isAuthorized else {
                debugPrint("[Camera_Authorization_Error]: User not authorized for camera access.")
                return
            }
            let captureSession = AVCaptureSession()
            session = captureSession
        }
        
        return session
    }
    
    
    //MARK: - Functions
    ///Configures the capture session according to the variables provided by the user
    fileprivate func setupCameraSession() {
        self.session.beginConfiguration()
        if let videoDevice = AVCaptureDevice.default(self.currentDeviceType,for: .video, position: self.currentPosition) {
            guard let captureInput = try? AVCaptureDeviceInput(device: videoDevice) else { return }
            
            self.session.sessionPreset = .photo
            if self.session.canAddInput(captureInput) {
                self.session.addInput(captureInput)
            }
            
            if self.session.canAddOutput(photoOutput) {
                self.session.addOutput(photoOutput)
            }
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
    public func getCurrentDevice() -> AVCaptureDevice.DeviceType {
        return self.currentDeviceType
    }
    
    /// used to get current camera position
    public func getCurrentPosition() -> AVCaptureDevice.Position {
        return self.currentPosition
    }
    
    
    private func getPhotoSettings() -> AVCapturePhotoSettings {
        guard let rawType = photoOutput.availableRawPhotoPixelFormatTypes.last else { return AVCapturePhotoSettings() }
        print(photoOutput.availableRawPhotoPixelFormatTypes)
        let photoSettings = AVCapturePhotoSettings(rawPixelFormatType: rawType, processedFormat: nil)
        
        return photoSettings
    }
    
    /// used to capture image
    public func captureImage() {
        self.session.beginConfiguration()
        
        photoOutput.maxPhotoQualityPrioritization = .quality
        
        if #available(iOS 17.0, *) {
            photoOutput.isZeroShutterLagEnabled = photoOutput.isZeroShutterLagSupported
        }
        
        if #available(iOS 17.0, *) {
            switch photoOutput.captureReadiness {
            case .sessionNotRunning:
                debugPrint("Session Not Running")
            case .ready:
                self.photoOutput.capturePhoto(with: getPhotoSettings(), delegate: MediaManager.shared)
            case .notReadyMomentarily:
                debugPrint("notReadyMomentarily")
            case .notReadyWaitingForCapture:
                debugPrint("notReadyWaitingForCapture")
            case .notReadyWaitingForProcessing:
                debugPrint("notReadyWaitingForProcessing")
            @unknown default:
                debugPrint("Unknown Error Occoured")
            }
        }
        
        self.session.commitConfiguration()
        sessionQueue.async {
            self.session.startRunning()
        }
    }
}
