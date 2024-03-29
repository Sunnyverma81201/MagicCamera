//
//  View+Extension.swift
//  MagicCamera
//
//  Created by Apoorv Verma on 25/02/24.
//

import SwiftUI

extension View {
    func center(_ axis: Axis = .horizontal) -> any View {
        if axis == .horizontal {
            HStack {
                Spacer()
                self
                Spacer()
            }
        } else {
            VStack {
                Spacer()
                self
                Spacer()
            }
        }
    }
}
