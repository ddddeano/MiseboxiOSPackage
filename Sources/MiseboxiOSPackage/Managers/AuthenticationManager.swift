//
//  File.swift
//  
//
//  Created by Daniel Watson on 22.01.24.
//

import Foundation
import Firebase
import FirebaseAuth

class AuthenticationManager: ObservableObject {
    
    struct FirebaseUser {
        let uid: String
        let email: String?
        let isAnon: Bool
        
        init(user: User) {
            self.uid = user.uid
            self.email = user.email
            self.isAnon = user.isAnonymous
        }
    }
    
    @Published var authError: Error?
    
    func authenticate() async throws -> FirebaseUser {
        if let currentUser = Auth.auth().currentUser {
            // User is already signed in
            return FirebaseUser(user: currentUser)
        } else {
            // No user signed in, proceed with anonymous sign-in
            return try await signInAnon()
        }
    }

    func linkEmailToUser(email: String, password: String, user: User) async throws -> FirebaseUser {
        do {
            let linkedUser = try await linkEmail(email: email, password: password)
            return linkedUser
        } catch {
            print("Error linking email to user: \(error.localizedDescription)")
            throw error
        }
    }
    
    @discardableResult
    func signInAnon() async throws -> FirebaseUser {
        let authResultData =  try await Auth.auth().signInAnonymously()
        return FirebaseUser(user: authResultData.user)
    }

    func createUser(email: String, password: String) async throws -> FirebaseUser {
        let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
        return FirebaseUser(user: authResult.user)
    }

    func signInUser(email: String, password: String) async throws -> FirebaseUser {
        let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
        return FirebaseUser(user: authResult.user)
    }
    @discardableResult
    func linkEmail(email: String, password: String) async throws -> FirebaseUser {
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        guard let currentUser = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        let authResult = try await currentUser.link(with: credential)
        return FirebaseUser(user: authResult.user)
    }
}
