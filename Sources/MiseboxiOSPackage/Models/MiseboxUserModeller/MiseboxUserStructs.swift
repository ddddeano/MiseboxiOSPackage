//
//  File.swift
//  
//
//  Created by Daniel Watson on 22.01.24.
//

import Foundation

extension MiseboxUserManager {
    public struct AppRole {
        public var role: String
        public var username: String
        
        public init(role: String = "", username: String = "") {
            self.role = role
            self.username = username
        }
        
        public init?(fromDictionary fire: [String: Any]) {
            guard let role = fire["role"] as? String,
                  let username = fire["username"] as? String else { return nil }
            self.role = role
            self.username = username
        }
        
        public func toFirestore() -> [String: Any] {
            return ["role": role, "username": username]
        }
    }
    
    public func addRoleToMiseboxUser(role: AppRole) async {
        await firestoreManager.updateDocumentDependant(
            collection: rootCollection,
            documentID: self.id,
            field: "roles",
            value: role.toFirestore(),
            operation: .arrayUnion
        )
    }
    
    public func removeRole() async {
        if let chefRole = miseboxUser.roles.first(where: { $0.role == self.role.rawValue }) {
            await firestoreManager.updateDocumentDependant(
                collection: rootCollection,
                documentID: self.id,
                field: "roles",
                value: chefRole.toFirestore(),
                operation: .arrayRemove
            )
        }
    }
}
