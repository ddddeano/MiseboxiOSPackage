//
//  File.swift
//  
//
//  Created by Daniel Watson on 22.01.24.
//

import Foundation
extension ChefManager {
    public struct MiseboxUser: Identifiable {
        
        public var id: String
        public var username: String
        
        public init(id: String = "", username: String = "") {
            self.id = id
            self.username = username
        }
        
        public init?(fromDictionary fire: [String: Any]) {
            guard let id = fire["id"] as? String,
                  let username = fire["username"] as? String else { return nil }
            self.id = id
            self.username = username
        }
        public init(fromMiseboxUser miseboxUser: MiseboxUserManager.MiseboxUser) {
            self.id = miseboxUser.id
            self.username = miseboxUser.username
        }
        
        public func toFirestore() -> [String: Any] {
            return ["id": id, "username": username]
        }
    }
    public func updateMiseboxUserRole(miseboxUserId: String) async {
        let roleData = ["role": "chef", "username": username]
        await firestoreManager.updateDocumentDependant(
            collection: "misebox-users",
            documentID: miseboxUserId,
            field: "roles",
            value: roleData,
            operation: .arrayUnion
        )
    }
    
    public struct Kitchen: Identifiable {
        public var id: String
        public var name: String
        
        public init(id: String = "", name: String = "") {
            self.id = id
            self.name = name
        }
        
        public init?(fromDictionary fire: [String: Any]) {
            guard let id = fire["id"] as? String,
                  let name = fire["name"] as? String else { return nil }
            self.id = id
            self.name = name
        }
        
        public func toFirestore() -> [String: Any] {
            return ["id": id, "name": name]
        }
    }
    
    public func setChefPrimaryKitchen(kitchen: Kitchen) async throws {
        let updateData: [String: Any] = ["primary_kitchen": kitchen.toFirestore()]
        try await self.update(data: updateData)
    }
    
    public func addKitchenToChef(kitchen: Kitchen) async {
        await firestoreManager.updateDocumentDependant(
            collection: rootCollection,
            documentID: self.id,
            field: "kitchens",
            value: kitchen.toFirestore(),
            operation: .arrayUnion
        )
    }
    
    public func removeKitchenFromChef(kitchenId: String, chefId: String) async {
        let kitchenData: [String: Any] = ["id": kitchenId]
        await firestoreManager.updateDocumentDependant(
            collection: rootCollection,
            documentID: chefId,
            field: "kitchens",
            value: kitchenData,
            operation: .arrayRemove
        )
    }
}
