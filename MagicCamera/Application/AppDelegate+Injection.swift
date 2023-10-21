//
//  AppDelegate+Injection.swift
//  MarkAR
//
//  Created by Apoorv Verma on 03/09/23.
//

import Foundation
import Resolver

extension Resolver: ResolverRegistering {
    public static func registerAllServices() {
        //Start Registering services here
        registerBasicServices()
    }
    
    private static func registerBasicServices() {
//        register {
//            
//        }.implements()
//            .scope(.application)
    }
}
