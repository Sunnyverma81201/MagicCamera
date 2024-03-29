//
//  PreviewView.swift
//  MagicCamera
//
//  Created by Apoorv Verma on 16/12/23.
//
import SwiftUI
import AVFoundation

struct PreviewView: UIViewRepresentable {
    // MARK: - Properties
    var previewLayer: AVCaptureVideoPreviewLayer
    let screen = UIScreen.main.bounds
    
    // MARK: - Initializer
    init(previewLayer: AVCaptureVideoPreviewLayer) {
        self.previewLayer = previewLayer
        
        /// - preview layer setup
        self.previewLayer.frame = CGRect(x: 0, y: 0, width: screen.size.width, height: screen.size.width * (4/3))
        self.previewLayer.videoGravity = .resizeAspect
        self.previewLayer.connection?.videoOrientation = .portrait
    }
    
    // MARK: - Function
    func makeCoordinator() -> PreviewViewCoordinator {
        return PreviewViewCoordinator(self)
    }
    
    func makeUIView(context: Context) -> UIView {
        let previewView = UIView()
        previewView.bounds = previewLayer.frame
        previewView.layer.addSublayer(previewLayer)
        return previewView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}
