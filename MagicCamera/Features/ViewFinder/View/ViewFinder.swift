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
            Button {
                viewModel.changeCameraDirection()
            } label: {
                Image(systemName: "arrow.triangle.2.circlepath")
                    .padding()
                    .clipShape(.circle)
            }
        }
    }
    
    
}
