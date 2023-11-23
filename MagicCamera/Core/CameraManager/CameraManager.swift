//
//  CameraManager.swift
//  MagicCamera
//
//  Created by Apoorv Verma on 21/10/23.
//
import AVFoundation
import SwiftUI

class CameraManager: ObservableObject {
    //MARK: - PROPERTIES
    private(set) var session: AVCaptureSession
    
    //MARK: - INITIALIZER
    init(captureSession: AVCaptureSession?) {
        self.session = captureSession ?? AVCaptureSession()
    }
    
    //MARK: - METHODS
}
