//
//  File.swift
//  
//
//  Created by Daniel Watson on 22.01.24.
//

import Foundation
import FirebaseFirestore

extension KitchenManager {
    public final class Kitchen: ObservableObject, Identifiable, FirestoreEntity, Listenable {
        public var collectionName = "kitchens"
        
        @Published public var id: String = ""
        @Published public var name: String = ""
        @Published public var createdBy: String = ""
        @Published public var team: [TeamMember] = []
        
        public init() {}
        
        // init(fromDocumentSnapshot:)
        public init?(documentSnapshot: DocumentSnapshot) {
            guard let data = documentSnapshot.data() else { return nil }
            self.id = documentSnapshot.documentID
            self.update(with: data)
        }
        
        public func update(with data: [String: Any]) {
            self.name = data["name"] as? String ?? self.name
            self.createdBy = data["createdBy"] as? String ?? self.createdBy
            
            self.team = fireArray(from: data["team"] as? [[String: Any]] ?? [], using: TeamMember.init(fromDictionary:))
            
        }
        
        public func toFirestore() -> [String: Any] {
            [
                "id": id,
                "name": name,
                "createdBy": createdBy,
                "team": team.map { $0.toFirestore() }
            ]
        }
    }
}
