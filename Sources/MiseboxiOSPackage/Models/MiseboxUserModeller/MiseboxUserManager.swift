//
//  File.swift
//  
//
//  Created by Daniel Watson on 22.01.24.
//

import Foundation
import FirebaseFirestore

public final class MiseboxUserManager: ObservableObject {
    public var role: UserRole
    
    let firestoreManager = FirestoreManager()
    var rootCollection = "misebox-users"
    
    public var listener: ListenerRegistration?
    deinit {
        listener?.remove()
    }

    @Published public var miseboxUser: MiseboxUser
    
    public init(user: MiseboxUser, role: UserRole) {
        self.miseboxUser = user
        self.role = role
    }
    public enum AccountType: String {
        case anon
        case email
        case other
    }
}
public protocol CanMiseboxUser {
    func verifyMiseboxUser() async
    func onboardMiseboxUser() async
}

public protocol CanVerifyUser {
    var miseboxUserManager: MiseboxUserManager { get }
    func verifyUser(with accountType: MiseboxUserManager.AccountType) async throws
}

