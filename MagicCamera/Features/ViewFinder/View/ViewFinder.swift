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
    @EnvironmentObject var cameraManager: CameraManager
    var eventHandler = PassthroughSubject<ViewFinderCoordinatorEvent, Error>()
    
    var body: some View {
        VStack {
            Text("hello")
        }
    }
}
      
#Preview {
    ViewFinder()
}
