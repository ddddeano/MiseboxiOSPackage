//
//  MiseboxUser.swift
//
//
//  Created by Daniel Watson on 22.01.24.
//

import Foundation
import FirebaseFirestore

extension MiseboxUserManager {
    
    public final class MiseboxUser: ObservableObject, Identifiable, Listenable {
        public var collectionName = "misebox-users"
                
        @Published public var id = ""
        @Published public var username = ""
        @Published public var imageUrl = ""
        @Published public var verified = false
        @Published public var userRoles: [UserRole] = []
        
        public init() {}

        public init?(documentSnapshot: DocumentSnapshot) {
            guard let data = documentSnapshot.data() else { return nil }
            self.id = documentSnapshot.documentID
            update(with: data)
        }
        
        public func update(with data: [String: Any]) {
            self.username = data["username"] as? String ?? ""
            self.imageUrl = data["image_url"] as? String ?? ""
            self.verified = data["verified"] as? Bool ?? false
            self.userRoles = fireArray(from: data["user_roles"] as? [[String: Any]] ?? [], using: UserRole.init(fromDictionary:))
        }
        
        public func toFirestore() -> [String: Any] {
            [
                "username": username,
                "image_url": imageUrl,
                "verified": verified,
                "user_roles": userRoles.map { $0.toFirestore() }
            ]
        }
        weak var delegate: ManagerDelegate?

        public func reset() {
            delegate?.resetData()
        }
    }
}

