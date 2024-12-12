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
    @ObservedObject var viewModel: ViewFinderViewModel
    var eventHandler = PassthroughSubject<ViewFinderCoordinatorEvent, Error>()
    
    // MARK: - Initializer
    init() {
        self.viewModel = Resolver.resolve()
    }
        
    // MARK: - Body
    var body: some View {
        VStack {
            PreviewView(previewLayer: viewModel.getPreviewLayer())
                .ignoresSafeArea(edges: .horizontal)
                .overlay(alignment: .bottom) {
                    HStack(spacing: 8){
                        LensesSelection(devices: viewModel.devicesList, currnetLens: viewModel.devicesList[0], currentPosition: viewModel.currentPosition, lenseButtonTapAction: changeCameraTapAction)
                        Button {
                            self.changeCameraTapAction()
                        } label: {
                            Image(systemName: "arrow.triangle.2.circlepath")
                                .padding()
                        }
                        .background(Material.regular)
                        .clipShape(Circle())
                    }
                }
            Button {
                viewModel.captureImage()
            } label: {
                Circle()
                    .fill(.white)
                    .frame(width: 80, height: 80, alignment: .center)
            }

        }
        .background(.black)
    }
    
    // MARK: - Helper Function
    private func changeCameraTapAction(_ lens: AVCaptureDevice? = nil) {
        self.viewModel.changeCamera(lens: lens)
    }
}
