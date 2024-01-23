//
//  File.swift
//  
//
//  Created by Daniel Watson on 23.01.24.
//

import Foundation
import FirebaseFirestore

public final class RecruiterProfileManager: ObservableObject {
    
    var firestoreManager = FirestoreManager()
    var rootCollection = "recruiter-profiles"
    
    var listener: ListenerRegistration?
    deinit {
        listener?.remove()
    }
    @Published public var recruiterProfile: RecruiterProfile
    
    public init(recruiterProfile: RecruiterProfile) {
        self.recruiterProfile = recruiterProfile
    }
}
