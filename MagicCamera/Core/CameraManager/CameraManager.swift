//
//  CameraManager.swift
//  MagicCamera
//
//  Created by Apoorv Verma on 21/10/23.
//
import AVFoundation
import SwiftUI
import Photos

class CameraManager: NSObject, ObservableObject {
    //MARK: - Properties
    
    /// Stores the session for the camera and the configuration
    private(set) var session: AVCaptureSession

    /// An array of available capture devices
    @Published var captureDevices: [AVCaptureDevice] = []
    
    /// Flag to identify if camera intractions are allowed or not; i.e. camera is in configuration mode
    @Published var isUserInteractionEnabled = false

    /// Camera configurations
    private var currentDeviceType: AVCaptureDevice.DeviceType = .builtInWideAngleCamera
    private var currentPosition: AVCaptureDevice.Position = .back

    let sessionQueue = DispatchQueue(label: "sessionQueue",attributes: .concurrent)
    
    /// Photo Output
    let photoOutput = AVCapturePhotoOutput()
    
    var photoData: Data?
    
    /// Stores the selected camera to start the capture session
    //MARK: - Initializer
    init(captureSession: AVCaptureSession?) {
        self.session = captureSession ?? AVCaptureSession()
        super.init()
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
        guard let rawType = photoOutput.availableRawPhotoPixelFormatTypes.first else { return AVCapturePhotoSettings() }
        var photoSettings = AVCapturePhotoSettings(rawPixelFormatType: rawType)
        
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
                self.photoOutput.capturePhoto(with: getPhotoSettings(), delegate: self)
            case .notReadyMomentarily:
                debugPrint("notReadyMomentarily")
            case .notReadyWaitingForCapture:
                debugPrint("notReadyWaitingForCapture")
            case .notReadyWaitingForProcessing:
                debugPrint("notReadyWaitingForProcessing")
            @unknown default:
                debugPrint("Unknown Error Occoured")
            }
        } else {
            print(photoOutput.availableRawPhotoFileTypes)
        }
        
        self.session.commitConfiguration()
        sessionQueue.async {
            self.session.startRunning()
        }
    }
}

extension CameraManager: AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput, willCapturePhotoFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
    }
    
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            print("Error capturing photo: \(error)")
        } else {
            photoData = photo.fileDataRepresentation()
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishCaptureFor resolvedSettings: AVCaptureResolvedPhotoSettings, error: Error?) {
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        if let error = error {
            print("Error capturing photo: \(error)")
            return
        }
        
        guard let photoData = photoData else {
            print("Error capturing photo")
            return
        }
        
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized {
                PHPhotoLibrary.shared().performChanges({
                    let options = PHAssetResourceCreationOptions()
                    let creationRequest = PHAssetCreationRequest.forAsset()
                    creationRequest.addResource(with: .photo, data: photoData, options: options)
                    
                }, completionHandler: { _, error in
                    if let error = error {
                        print("Error occurred while saving photo to photo library: \(error)")
                    }
                })
            }
        }
    }
    
}
