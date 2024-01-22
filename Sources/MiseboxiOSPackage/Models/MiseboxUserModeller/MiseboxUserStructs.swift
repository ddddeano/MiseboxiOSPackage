//
//  File.swift
//  
//
//  Created by Daniel Watson on 22.01.24.
//

import Foundation

extension MiseboxUserManager {
    public struct Role {
        public var role: String
        public var name: String
        
        public init(role: String = "", name: String = "") {
            self.role = role
            self.name = name
        }
        
        public init?(fromDictionary fire: [String: Any]) {
            guard let role = fire["role"] as? String,
                  let name = fire["name"] as? String else { return nil }
            self.role = role
            self.name = name
        }
        
        public func toFirestore() -> [String: Any] {
            return ["role": role, "name": name]
        }
    }
    
    public func addRoleToMiseboxUser(role: Role) async {
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
