//
//  MiseboxUserManager.swift
//  Created by Daniel Watson on 22.01.24.
//

import Foundation
import FirebaseFirestore

public final class MiseboxUserManager: ObservableObject {
    public var role: SessionManager.UserRole
    let firestoreManager = FirestoreManager()
    
    public enum MiseboxUserDocCollectionMarker: String {
        case miseboxUser, miseboxUserProfile

        func collection() -> String {
            switch self {
            case .miseboxUser:
                return "misebox-users"
            case .miseboxUserProfile:
                return "misebox-user-profiles"
            }
        }

        func doc() -> String {
            switch self {
            case .miseboxUser:
                return "misebox-user"
            case .miseboxUserProfile:
                return "misebox-user-profile"
            }
        }
    }
    
    public var listener: ListenerRegistration?
    deinit {
        listener?.remove()
    }
    
    @Published public var miseboxUser: MiseboxUser
    @Published public var miseboxUserProfile: MiseboxUserProfile
    
    public init(miseboxUser: MiseboxUser, miseboxUserProfile: MiseboxUserProfile, role: SessionManager.UserRole) {
        self.role = role
        self.miseboxUser = miseboxUser
        self.miseboxUserProfile = miseboxUserProfile
    }

    public func reset() {
        self.miseboxUser = MiseboxUser()
        self.miseboxUserProfile = MiseboxUserProfile()
        listener?.remove()
    }
    
    public enum UserDependantDocCollection: String, CaseIterable {
        case chef, recruiter

        func collection() -> String {
            switch self {
            case .chef:
                return "chefs"
            case .recruiter:
                return "recruiters"
            }
        }
        func doc() -> String {
            switch self {
            case .chef:
                return "chef"
            case .recruiter:
                return "recruiter"
            }
        }
    }

    public enum Role: String {
           case chef = "chef"
           case recruiter = "recruiter"
       }
    
    public enum AccountAuthenticationMethod: String {
        case anon, email, other
    }
}
public protocol CanMiseboxUser {
    var authenticationManager: AuthenticationManager { get }
    var miseboxUserManager: MiseboxUserManager { get }
    func verifyMiseboxUser(with accountType: MiseboxUserManager.AccountAuthenticationMethod) async throws
    func onboardMiseboxUser() async
}
