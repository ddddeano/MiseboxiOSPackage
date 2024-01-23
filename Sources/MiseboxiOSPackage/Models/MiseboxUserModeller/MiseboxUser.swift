//
//  File.swift
//  
//
//  Created by Daniel Watson on 22.01.24.
//

import Foundation
import Firebase
import FirebaseFirestore

extension MiseboxUserManager {
    
    public var id: String {
        return miseboxUser.id
    }
    public var username: String {
        return miseboxUser.username
    }
    public var verified: Bool {
        return miseboxUser.verified
    }
    public var accountProviders: [String] {
        return miseboxUser.accountProviders
    }
    public var roles: [AppRole] {
        return miseboxUser.roles
    }
    public var imageUrl: String {
        return miseboxUser.imageUrl
    }
    
    public final class MiseboxUser: ObservableObject, Identifiable, Listenable {
        public var collectionName = "misebox-users"
        
        @Published public var id = ""
        @Published public var username = ""
        @Published public var imageUrl = ""

        @Published public var verified = false
        @Published public var accountProviders: [String] = []
        @Published public var roles: [AppRole] = []
        
        public init() {}

        public init?(documentSnapshot: DocumentSnapshot) {
            guard let data = documentSnapshot.data() else { return nil }
            self.id = documentSnapshot.documentID
            update(with: data)
        }
        
        public func update(with data: [String: Any]) {
            self.username = data["username"] as? String ?? ""
            self.imageUrl = data["image_url"] as? String ?? ""

            self.verified = data["verified"] as? Bool ?? self.verified
            self.accountProviders = data["account_providers"] as? [String] ?? []
            self.roles = fireArray(from: data["roles"] as? [[String: Any]] ?? [], using: AppRole.init(fromDictionary:))
        }
        
        public func toFirestore() -> [String: Any] {
            return [
                "id": id,
                "username": username,
                "verified": verified,
                "account_providers": accountProviders,
                "roles": roles.map { $0.toFirestore() }
            ]
        }
    }
    public func resetMiseboxUser() {
        self.miseboxUser = MiseboxUser()
        listener?.remove()
    }
}
