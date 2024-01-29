//
//  ChefStructures.swift
//
//
//  Created by Daniel Watson on 22.01.24.
//

import Foundation

extension ChefManager {
    
    // MARK: - Chef Structures

    public struct MiseboxUser: Identifiable {
        
        public var id = ""
        public var username = ""
        
        public init () {}
        
        public init?(fromDictionary fire: [String: Any]) {
            guard let id = fire["id"] as? String,
                  let username = fire["username"] as? String else { return nil }
            self.id = id
            self.username = username
        }
        public init(miseboxUser: MiseboxUserManager.MiseboxUser) {
            self.id = miseboxUser.id
            self.username = miseboxUser.username
        }
        
        public func toFirestore() -> [String: Any] {
            return ["id": id, "username": username]
        }
    }
    
    public struct Kitchen: Identifiable {
        public var id = ""
        public var name = ""
        
        public init() {}
        
        public init?(fromDictionary fire: [String: Any]) {
            self.id = fire["id"] as? String ?? ""
            self.name = fire["name"] as? String ?? ""
        }
        public init(kitchen: KitchenManager.Kitchen) {
            self.id = kitchen.id
            self.name = kitchen.name
        }
        public func toFirestore() -> [String: Any] {
            return ["id": id, "name": name]
        }
    }
    
    
    // MARK: - Chef-Profile Structures
    public struct GeneralInfo {
        public var name = ""
        public var username = ""
        public var imageUrl = ""
        public var nickname = ""
        
        public init() {}
        
        public init(fromDictionary fire: [String: Any]) {
            self.name = fire["name"] as? String ?? ""
            self.username = fire["username"] as? String ?? ""
            self.imageUrl = fire["image_url"] as? String ?? ""
            self.nickname = fire["nickname"] as? String ?? ""
        }
        
        
        public func toFirestore() -> [String: Any] {
            ["name": name, "username": username, "image_url": imageUrl, "nickname": nickname]
        }
    }
        
    public struct Nationality {
        public var country = ""
        public var flagCode = ""
        
        public init() {}
        
        public init?(fromDictionary fire: [String: Any]) {
            self.country = fire["country"] as? String ?? ""
            self.flagCode = fire["flag_code"] as? String ?? ""
        }
        
        public func toFirestore() -> [String: Any] {
            ["country": country, "flag_code": flagCode]
        }
    }
    
    public struct AboutMeBio {
        public var aboutMe = ""
        public var bio = ""
        
        public init() {}
        
        public init?(fromDictionary fire: [String: Any]) {
            self.aboutMe = fire["about_me"] as? String ?? ""
            self.bio = fire["bio"] as? String ?? ""
        }
        
        public func toFirestore() -> [String: Any] {
            ["about_me": aboutMe, "bio": bio]
        }
    }
    
    public struct GalleryImage: Identifiable {
        public let id = UUID()
        public var name: String
        public var imageUrl: String
        
        public init(name: String, imageUrl: String) {
            self.name = name
            self.imageUrl = imageUrl
        }
        public init(fromDictionary fire: [String: Any]) {
            self.name = fire["name"] as? String ?? ""
            self.imageUrl = fire["image_url"] as? String ?? ""
        }
        
        public func toFirestore() -> [String: Any] {
            ["id": id.uuidString, "name": name, "image_url": imageUrl]
        }
    }
    
    public struct PreviousEmployment: Identifiable {
        public let id = UUID()
        public var employerName = ""
        public var role = ""
        public var startDate = ""
        public var endDate = ""
        public var description = ""
        
        public init() {}
        
        public init?(fromDictionary fire: [String: Any]) {
            self.employerName = fire["employer_name"] as? String ?? ""
            self.role = fire["role"] as? String ?? ""
            self.startDate = fire["start_date"] as? String ?? ""
            self.endDate = fire["end_date"] as? String ?? ""
            self.description = fire["description"] as? String ?? ""
        }
        public var isValid: Bool {
            !employerName.isEmpty && !role.isEmpty
        }
        public func toFirestore() -> [String: Any] {
            ["id": id.uuidString, "employer_name": employerName, "role": role, "start_date": startDate, "end_date": endDate, "description": description]
        }
    }
    
    public struct Qualification: Identifiable {
        public let id = UUID()
        public var docURL = ""
        public var institution = ""
        public var name = ""
        public var level = ""
        
        public init() {}
        
        public init?(fromDictionary fire: [String: Any]) {
            self.docURL = fire["doc_url"] as? String ?? ""
            self.institution = fire["institution"] as? String ?? ""
            self.name = fire["name"] as? String ?? ""
            self.level = fire["level"] as? String ?? ""
        }
        public var isValid: Bool {
            !name.isEmpty && !institution.isEmpty
        }
        
        public func toFirestore() -> [String: Any] {
            ["id": id.uuidString, "doc_url": docURL, "institution": institution, "name": name, "level": level]
        }
    }
    
    public struct SpokenLanguage: Identifiable {
        public let id = UUID()
        public var lang = ""
        public var level = ""
        
        public init() {}
        
        public init?(fromDictionary fire: [String: Any]) {
            self.lang = fire["lang"] as? String ?? ""
            self.level = fire["level"] as? String ?? ""
        }
        
        public func toFirestore() -> [String: Any] {
            ["id": id.uuidString, "lang": lang, "level": level]
        }
    }
}
