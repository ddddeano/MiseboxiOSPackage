//
//  File.swift
//  
//
//  Created by Daniel Watson on 22.01.24.
//

import Foundation
import FirebaseFirestore

extension GigsManager {
    public final class Gig: ObservableObject, Identifiable, Listenable {
        @Published public var id: String = ""
        @Published public var title: String = ""
        public var collectionName = "gigs"

        public init() {}

        public init?(documentSnapshot: DocumentSnapshot) {
            guard let data = documentSnapshot.data() else { return nil }
            self.id = documentSnapshot.documentID
            self.title = data["title"] as? String ?? ""
        }

        public func update(with data: [String: Any]) {
            self.id = data["id"] as? String ?? self.id
            self.title = data["title"] as? String ?? self.title
        }

        public func toFirestore() -> [String: Any] {
            [
                "id": id,
                "title": title
            ]
        }
    }
}
