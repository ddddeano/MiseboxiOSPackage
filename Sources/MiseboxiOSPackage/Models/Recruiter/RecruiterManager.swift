//
//  File.swift
//  
//
//  Created by Daniel Watson on 23.01.24.
//

import Foundation
import FirebaseFirestore

public final class RecruiterManager: ObservableObject {
        
    var firestoreManager = FirestoreManager()
    var rootCollection = "recruiters"
    
    var dependants = ["misebox-users", "recruiter-profiles"]
    
    var listener: ListenerRegistration?
    deinit {
        listener?.remove()
    }
    
    @Published public var recruiter: Recruiter
    
    public init(recruiter: Recruiter) {
        self.recruiter = recruiter
    }
}

public protocol CanRecruiter {
    var miseboxUserManager: MiseboxUserManager { get }
    var recruiterManager: RecruiterManager { get }
    func createRecruiter(skip: Bool) async throws
    func onboardRecruiter() async
}
