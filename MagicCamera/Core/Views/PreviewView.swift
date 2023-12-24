//
//  PreviewView.swift
//  MagicCamera
//
//  Created by Apoorv Verma on 16/12/23.
//

import UIKit
import SwiftUI
import AVFoundation
import Resolver

class PreviewViewController: UIViewController {
    // MARK: - Properties
    private var manager: CameraManager = Resolver.resolve()
    private var previewLayer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer()
    
    
    // MARK: - App LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.previewLayer = manager.getPreviewLayer()
        DispatchQueue(label: "sessionQueue").async {
            self.setupPreviewView()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - Function
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        let screen = UIScreen.main.bounds
        self.previewLayer.frame = CGRect(x: 0, y: 0, width: screen.size.width, height: screen.size.height)
        
        switch UIDevice.current.orientation {
           case UIDeviceOrientation.portraitUpsideDown: self.previewLayer.connection?.videoOrientation = .portraitUpsideDown
           case UIDeviceOrientation.landscapeLeft: self.previewLayer.connection?.videoOrientation = .landscapeRight
           case UIDeviceOrientation.landscapeRight: self.previewLayer.connection?.videoOrientation = .landscapeLeft
           case UIDeviceOrientation.portrait: self.previewLayer.connection?.videoOrientation = .portrait
           default: break
        }
    }
    
    func setupPreviewView() {
        let screenRect = UIScreen.main.bounds
        
        previewLayer = AVCaptureVideoPreviewLayer(session: manager.session)
        previewLayer.frame = CGRect(x: 0, y: 0, width: screenRect.size.width, height: screenRect.width * (4/3))
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill // Fill screen
        previewLayer.connection?.videoOrientation = .portrait
        
        DispatchQueue.main.async { [weak self] in
            self!.view.layer.addSublayer(self!.previewLayer)
        }
    }
}

struct PreviewView: UIViewControllerRepresentable {
    // MARK: - Function
    func makeUIViewController(context: Context) -> some UIViewController {
        return PreviewViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}
