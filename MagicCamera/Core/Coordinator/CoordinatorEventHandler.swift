//
//  CoordinatorEventHandler.swift
//  GeeksforGeeks
//
//  Created by Apoorv Verma on 08/09/23.
//

protocol CoordinatorEventHandler {
	associatedtype CoordinatorEvent
	
	func handleEvent(_ event: CoordinatorEvent)
}
