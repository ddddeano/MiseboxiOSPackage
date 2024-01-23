//
//  File.swift
//  
//
//  Created by Daniel Watson on 23.01.24.
//

import Foundation
import FirebaseFirestore

extension RecruiterManager {
    
    public var id: String {
        return recruiter.id
    }
    public var username: String {
        return recruiter.username
    }
    public var kitchens: [Kitchen] {
        return recruiter.kitchens
    }
    public var primaryKitchen: Kitchen? {
        return recruiter.primaryKitchen
    }
    public var imageUrl: String {
        recruiter.imageUrl
    }
    
    public final class Recruiter: ObservableObject, Identifiable, Listenable {
        public var collectionName = "recruiters"
        
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
    public func resetRecruiter() {
        self.recruiter = Recruiter()
        listener?.remove()
    }
}
