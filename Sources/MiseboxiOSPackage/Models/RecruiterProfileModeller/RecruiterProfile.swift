//  RecruiterProfile.swift
//  Recruiters
//
//  Created by Daniel Watson on 23.01.24.
//

import Foundation
import FirebaseFirestore

extension RecruiterProfileManager {
    
    public var id: String {
        return recruiterProfile.id
    }
    public var name: String {
        return recruiterProfile.name
    }
    
    public var username: String {
        return recruiterProfile.username
    }
    public var imageUrl: String {
        return recruiterProfile.imageUrl
    }
    
    public final class RecruiterProfile: ObservableObject, Identifiable, Listenable {
        public var collectionName = "recruiter-profiles"
        
        @Published public var id = ""
        @Published public var name = ""
        @Published public var imageUrl = ""
        @Published public var username = ""
        
        // Object (Custom objects)
        @Published public var companyName = CompanyName()
        @Published public var aboutUs = AboutUs()
        @Published public var contactInfo = ContactInfo()
        
        // Array (Arrays of objects)
        @Published public var gallery: [GalleryImage] = []
        
        public init() {}
        
        public init(recruiter: RecruiterManager.Recruiter) {
            self.id = recruiter.id
            self.username = recruiter.username
        }
        
        public required init?(documentSnapshot: DocumentSnapshot) {
            guard let data = documentSnapshot.data() else { return nil }
            self.id = documentSnapshot.documentID
            update(with: data)
        }
        
        public func update(with data: [String: Any]) {
            
            self.name = data["name"] as? String ?? ""
            self.imageUrl = data["image_url"] as? String ?? ""
            self.username = data["username"] as? String ?? ""
            
            self.companyName = fireObject(from: data["company_name"] as? [String: Any] ?? [:], using: CompanyName.init) ?? CompanyName()
            self.aboutUs = fireObject(from: data["about_us"] as? [String: Any] ?? [:], using: AboutUs.init) ?? AboutUs()
            self.contactInfo = fireObject(from: data["contact_info"] as? [String: Any] ?? [:], using: ContactInfo.init) ?? ContactInfo()
            
            self.gallery = (data["gallery"] as? [[String: Any]] ?? []).compactMap(GalleryImage.init)
        }
        
        public func toFirestore() -> [String: Any] {
            [
                "name": name,
                "image_url": imageUrl,
                "username": username,
                
                // Object
                "company_name": companyName.toFirestore(),
                "about_us": aboutUs.toFirestore(),
                "contact_info": contactInfo.toFirestore(),
                
                // Array
                "gallery": gallery.map { $0.toFirestore() }
            ]
        }
    }
    
    public func resetRecruiterProfile() {
        self.recruiterProfile = RecruiterProfile()
        listener?.remove()
    }
}
