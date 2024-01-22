//
//  File.swift
//  
//
//  Created by Daniel Watson on 22.01.24.
//

import Foundation
import FirebaseFirestore
extension KitchenManager {
    public struct TeamMember: Identifiable, FirestoreEntity {
        public var collectionName = "team"
        
        public var id: String
        public var name: String
        public var role: String

        public init(id: String = "", name: String, role: String) {
            self.id = id
            self.name = name
            self.role = role
        }

        public init?(fromDictionary fire: [String: Any]) {
            guard let id = fire["id"] as? String else { return nil }
            self.id = id
            self.name = fire["name"] as? String ?? ""
            self.role = fire["role"] as? String ?? ""
        }
        
        public init?(documentSnapshot: DocumentSnapshot) {
            guard let data = documentSnapshot.data() else { return nil }
            self.init(fromDictionary: data)
        }
        
        public func toFirestore() -> [String: Any] {
            return ["id": id, "name": name, "role": role]
        }
    }
    public func addTeamMemberToKitchenTeam(teamMember: TeamMember, kitchenId: String ) {
        let updateData: [String: Any] = ["team": teamMember.toFirestore()]
        update(id: kitchenId, data: updateData)
    }
}
