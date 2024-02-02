//
//  File.swift
//  
//
//  Created by Daniel Watson on 31.01.24.
//

import Foundation

extension SessionManager {
        
    public static func mockSessionManager() -> SessionManager {
        
        let mockSession = Session()
        
        let mockSessionManager = SessionManager(session: mockSession)
        return mockSessionManager
    }
}
