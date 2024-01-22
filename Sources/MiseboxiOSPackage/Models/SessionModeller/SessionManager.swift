//
//  File.swift
//  MiseboxiOSPackage
//
//  Created by Daniel Watson on 22.01.24.
//

import Foundation

public final class SessionManager {
    @Published public var session: Session
    
    private let themePreferenceKey = "isDarkModeEnabled"
    
    public init(session: Session) {
        self.session = session
        loadThemePreferences()
    }
    
    public func resetSession() {
        self.session = Session(role: session.role)
    }

    public func saveThemePreferences(isDarkModeEnabled: Bool) {
        UserDefaults.standard.set(isDarkModeEnabled, forKey: themePreferenceKey)
    }

    func loadThemePreferences() {
        if let isDarkModeEnabled = UserDefaults.standard.object(forKey: themePreferenceKey) as? Bool {
            session.isDarkMode = isDarkModeEnabled
        }
    }
}
