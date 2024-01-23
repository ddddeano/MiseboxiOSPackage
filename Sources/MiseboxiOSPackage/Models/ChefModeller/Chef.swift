//
//  File.swift
//  
//
//  Created by Daniel Watson on 22.01.24.
//

import Foundation
import FirebaseFirestore


extension ChefManager {
    
    public var id: String {
        return chef.id
    }
    public var username: String {
        return chef.username
    }
    public var kitchens: [ChefManager.Kitchen] {
        return chef.kitchens
    }
    public var primaryKitchen: ChefManager.Kitchen? {
        return chef.primaryKitchen
    }
    public var imageUrl: String {
        chef.imageUrl
    }
    
    public final class Chef: ObservableObject, Identifiable, Listenable {
        public var collectionName = "chefs"
        
        @Published public var id = ""
        
        @Published public var username = ""
        @Published public var imageUrl = ""
        
        @Published public var miseboxUser: MiseboxUser? = nil
        @Published public var primaryKitchen: Kitchen? = nil
        @Published public var kitchens: [Kitchen] = []
        
        public init() {}
        
        public init?(documentSnapshot: DocumentSnapshot) {
            guard let data = documentSnapshot.data() else { return nil }
            self.id = documentSnapshot.documentID
            update(with: data)
        }
        
        public func update(with data: [String : Any]) {
            self.username = data["username"] as? String ?? ""
            self.imageUrl = data["image_url"] as? String ?? ""
            
            self.miseboxUser = fireObject(from: data["misebox_user"] as? [String: Any] ?? [:], using: MiseboxUser.init(fromDictionary:))
            self.primaryKitchen = fireObject(from: data["primary_kitchen"] as? [String: Any] ?? [:], using: Kitchen.init(fromDictionary:))
            self.kitchens = fireArray(from: data["kitchens"] as? [[String: Any]] ?? [], using: Kitchen.init(fromDictionary:))
        }
        
        public func toFirestore() -> [String: Any] {
            [
                "username": username,
                "image_url": imageUrl,
                "user": miseboxUser?.toFirestore() ?? [:],
                "primary_kitchen": primaryKitchen?.toFirestore() ?? [:],
                "kitchens": kitchens.map { $0.toFirestore() }
            ]
        }
        public func toProfile() -> [String: Any] {
            [
                "username": username,
                "image_url": imageUrl
            ]
        }
    }
    public func resetChef() {
        self.chef = Chef()
        listener?.remove()
    }
}
