//
//  PreviewViewCoordinator.swift
//  MagicCamera
//
//  Created by Apoorv Verma on 20/01/24.
//
import ObjectiveC

class PreviewViewCoordinator: NSObject {
    private var parent: PreviewView?
    
    init(_ parent: PreviewView?) {
        self.parent = parent
    }
}
