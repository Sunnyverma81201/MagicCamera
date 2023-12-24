//
//  ViewFinder.swift
//  MagicCamera
//
//  Created by Apoorv Verma on 15/10/23.
//

import SwiftUI
import Combine
import AVFoundation
import Resolver

struct ViewFinder: View {
    // MARK: - Properties
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @ObservedObject var cameraManager: CameraManager
    var eventHandler = PassthroughSubject<ViewFinderCoordinatorEvent, Error>()
    
    // MARK: - Initializer
    init(cameraManager: CameraManager) {
        self.cameraManager = cameraManager
    }
    
    // MARK: - Body
    var body: some View {
        VStack {
            Spacer()
            PreviewView()
                .ignoresSafeArea()
            Spacer()
            Button {
                self.changeCamera()
            } label: {
                Image(systemName: "arrow.clockwise")
                    .padding()
                    .background(Material.thin)
                    .clipShape(.circle)
            }
        }
    }
    
    // MARK: - Helper Function
    func changeCamera() {
        self.cameraManager.changeCamera(to: .builtInWideAngleCamera,position: .front)
    }
}
      
#Preview {
    ViewFinder(cameraManager: CameraManager(captureSession: AVCaptureSession()))
}
