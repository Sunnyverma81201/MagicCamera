//
//  LensesSelection.swift
//  MagicCamera
//
//  Created by Apoorv Verma on 18/02/24.
//

import SwiftUI
import AVFoundation

struct LensesSelection: View {
    // MARK: - Properties
    let devices: [AVCaptureDevice]
    let currnetLens: AVCaptureDevice
    let currentPosition: AVCaptureDevice.Position
    let lenseButtonTapAction: (AVCaptureDevice) -> Void
    
    // MARK: - Body
    var body: some View {
        HStack(spacing: 2){
            if currentPosition == .back {
                ForEach(devices, id: \.self) { device in
                    if device.position == self.currentPosition {
                        Button {
                            lenseButtonTapAction(device)
                        } label: {
                            Text("\(cameraZoom(device))mm")
                        }
                        .padding()
                        .background(Material.thick)
                        .clipShape(RoundedRectangle(cornerRadius: .infinity))
                        .padding(4)
                    }
                }
            }
        }
        .background(Material.thin)
        .clipShape(RoundedRectangle(cornerRadius: .infinity))
    }
    
    // MARK: - Helper Function
    func cameraZoom(_ device: AVCaptureDevice) -> Int {
        let fov = device.activeFormat.videoFieldOfView * .pi / 180
        let focalLength = 35.0 / (2.0 * tan(fov/2))
        return Int(round(focalLength))
    }
}
