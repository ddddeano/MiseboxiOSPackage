//
//  File.swift
//  
//
//  Created by Daniel Watson on 22.01.24.
//

import Foundation
import FirebaseFirestore

extension ChefManager {
    
    public final class Chef: ObservableObject, Identifiable, Listenable {
        public var collectionName = "chefs"
        @Published public var id = ""
        @Published public var name = ""
        @Published public var generalInfo = GeneralInfo()
        @Published public var miseboxUser = MiseboxUser()
        @Published public var primaryKitchen: Kitchen? = nil
        @Published public var kitchens: [Kitchen] = []
        
        public init() {}
        
        public init?(documentSnapshot: DocumentSnapshot) {
            guard let data = documentSnapshot.data() else { return nil }
            self.id = documentSnapshot.documentID
            update(with: data)
        }
        
        public func update(with data: [String: Any]) {
            self.name = data["name"] as? String ?? ""
            self.generalInfo = fireObject(from: data["general_info"] as? [String: Any] ?? [:], using: GeneralInfo.init) ?? GeneralInfo()
            self.miseboxUser = fireObject(from: data["misebox_user"] as? [String: Any] ?? [:], using: MiseboxUser.init) ?? MiseboxUser()
            self.primaryKitchen = fireObject(from: data["primary_kitchen"] as? [String: Any] ?? [:], using: Kitchen.init) ?? nil
            self.kitchens = fireArray(from: data["kitchens"] as? [[String: Any]] ?? [], using: Kitchen.init(fromDictionary:))
        }
        
        public func toFirestore() -> [String: Any] {
            [
                "name": name,
                "general_info": generalInfo.toFirestore(),
                "miseboxUser": miseboxUser.toFirestore(),
                "primary_kitchen": primaryKitchen?.toFirestore() ?? [:],
                "kitchens": kitchens.map { $0.toFirestore() }
            ]
        }
    }
}

