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
    public var name: String {
        return miseboxUser.name
    }
    public var verified: Bool {
        return miseboxUser.verified
    }
    public var accountProviders: [String] {
        return miseboxUser.accountProviders
    }
    public var roles: [Role] {
        return miseboxUser.roles
    }
    public var imageUrl: String {
        return miseboxUser.imageUrl
    }
    
    public final class MiseboxUser: ObservableObject, Identifiable, Listenable {
        public var collectionName = "misebox-users"
        
        @Published public var id = ""
        @Published public var name = ""
        @Published public var imageUrl = ""

        @Published public var verified = false
        @Published public var accountProviders: [String] = []
        @Published public var roles: [Role] = []
        
        public init() {}

        public init?(documentSnapshot: DocumentSnapshot) {
            guard let data = documentSnapshot.data() else { return nil }
            self.id = documentSnapshot.documentID
            update(with: data)
        }
        
        public func update(with data: [String: Any]) {
            self.name = data["name"] as? String ?? self.name
            self.imageUrl = data["image_url"] as? String ?? self.imageUrl

            self.verified = data["verified"] as? Bool ?? self.verified
            self.accountProviders = data["account_providers"] as? [String] ?? []
            self.roles = fireArray(from: data["roles"] as? [[String: Any]] ?? [], using: Role.init(fromDictionary:))
        }
        
        public func toFirestore() -> [String: Any] {
            return [
                "id": id,
                "name": name,
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
