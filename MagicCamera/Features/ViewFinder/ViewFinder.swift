//
//  ViewFinder.swift
//  MagicCamera
//
//  Created by Apoorv Verma on 15/10/23.
//

import SwiftUI
import Combine
import Resolver

struct ViewFinder: View {
    var eventHandler = PassthroughSubject<ViewFinderCoordinatorEvent, Error>()
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    ViewFinder()
}
