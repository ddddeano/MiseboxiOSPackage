//
//  MiseboxUserManager.swift
//  Created by Daniel Watson on 22.01.24.
//

import Foundation
import FirebaseFirestore

public final class MiseboxUserManager: ObservableObject {
    public var role: SessionManager.UserRole
    let firestoreManager = FirestoreManager()
    
    public enum RoleTypes {
         static let miseboxUser = RoleType(doc: "misebox-user", collection: "misebox-users", profile: "misebox-user-profile", profileCollection: "misebox-user-profiles")
         static let chef = RoleType(doc: "chef", collection: "chefs", profile: "chef-profile", profileCollection: "chef-profiles")
         static let agent = RoleType(doc: "agent", collection: "agents", profile: "agent-profile", profileCollection: "agent-profiles")
         static let recruiter = RoleType(doc: "recruiter", collection: "recruiters", profile: "recruiter-profile", profileCollection: "recruiter-profiles")
         
        static func roleType(for doc: String) -> RoleType {
            switch doc {
            case miseboxUser.doc: return miseboxUser
            case chef.doc: return chef
            case agent.doc: return agent
            case recruiter.doc: return recruiter
            default: fatalError("Unknown doc type: \(doc)")
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

    public enum EcoSystemRole: String {
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
