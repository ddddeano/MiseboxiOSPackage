//
//  File.swift
//  
//
//  Created by Daniel Watson on 22.01.24.
//

import Foundation
import FirebaseFirestore

extension ChefProfileManager {
    
    public var id: String {
        return chefProfile.id
    }
    public var nickname: String {
        return chefProfile.nickname
    }
    
    public var username: String {
        return chefProfile.username
    }
    public var imageUrl: String {
        return chefProfile.imageUrl
    }
    
    public final class ChefProfile: ObservableObject, Identifiable, Listenable {
        public var collectionName = "chef-profiles"
        
        @Published public var id = ""
        @Published public var nickname = ""
        @Published public var imageUrl = ""
        @Published public var username = ""
        
        // Object (Custom objects)
        @Published public var fullName = FullName()
        @Published public var nationality = Nationality()
        @Published public var aboutMeBio = AboutMeBio()  // Replaced CV with AboutMeBio
        
        // Array (Arrays of objects)
        @Published public var gallery: [GalleryImage] = []
        @Published public var previousEmployment: [PreviousEmployment] = []
        @Published public var qualifications: [Qualification] = []
        @Published public var spokenLanguages: [SpokenLanguage] = []
        
        
        public init() {}
        
        public init(chef: ChefManager.Chef) {
            self.id = chef.id
            self.username = chef.username
        }
        
        public required init?(documentSnapshot: DocumentSnapshot) {
            guard let data = documentSnapshot.data() else { return nil }
            self.id = documentSnapshot.documentID
            update(with: data)
        }
        
        public func update(with data: [String: Any]) {
            
            self.nickname = data["nickname"] as? String ?? ""
            self.imageUrl = data["image_url"] as? String ?? ""
            self.username = data["username"] as? String ?? ""
            
            self.fullName = fireObject(from: data["full_name"] as? [String: Any] ?? [:], using: FullName.init) ?? FullName()
            self.aboutMeBio = fireObject(from: data["about_me_bio"] as? [String: Any] ?? [:], using: AboutMeBio.init) ?? AboutMeBio()
            self.nationality = fireObject(from: data["nationality"] as? [String: Any] ?? [:], using: Nationality.init) ?? Nationality()
            
            self.gallery = (data["gallery"] as? [[String: Any]] ?? []).compactMap(GalleryImage.init)
            
            self.previousEmployment = fireArray(from: data["previous_employment"] as? [[String: Any]] ?? [], using: PreviousEmployment.init)
            self.qualifications = fireArray(from: data["qualifications"] as? [[String: Any]] ?? [], using: Qualification.init)
            self.spokenLanguages = fireArray(from: data["spoken_languages"] as? [[String: Any]] ?? [], using: SpokenLanguage.init)
            
        }
        
        
        public func toFirestore() -> [String: Any] {
            [
                "nickname": nickname,
                "image_url": imageUrl,
                "username": username,
                
                // Object
                "full_name": fullName.toFirestore(),
                "nationality": nationality.toFirestore(),
                "about_me_bio": aboutMeBio.toFirestore(),
                
                // Array
                "gallery": gallery.map { $0.toFirestore() },
                "previous_employment": previousEmployment.map { $0.toFirestore() },
                "qualifications": qualifications.map { $0.toFirestore() },
                "spoken_languages": spokenLanguages.map { $0.toFirestore() }
            ]
        }
    }
    public func resetChefProfile() {
        self.chefProfile = ChefProfile()
        listener?.remove()
    }
}
