//
//  File.swift
//  
//
//  Created by Daniel Watson on 22.01.24.
//

import Foundation
//
//  ChefProfileStructures.swift
//  Chefs
//
//  Created by Daniel Watson on 18.01.24.
//
// 1. FullNameEdit
// 2. NationalityEdit
// 3. CVEdit
// 4. GalleryImagesEdit
// 5. PreviousEmploymentsEdit
// 6. QualificationsEdit
// 7. SpokenLanguagesEdit
// 8. AvatarEdit

extension ChefProfileManager {
    
    // MARK: - 1. FullName / store as object
    public struct FullName {
        public var first = ""
        public var middle = ""
        public var last = ""
        
        public init() {}
        public init?(fromDictionary fire: [String: Any]) {
            self.first = fire["first"] as? String ?? ""
            self.middle = fire["middle"] as? String ?? ""
            self.last = fire["last"] as? String ?? ""
        }
        
        public func toFirestore() -> [String: Any] {
            [
                "first": first,
                "middle": middle,
                "last": last
            ]
        }
        
        public var formatted: String {
            [first, middle, last].filter { !$0.isEmpty }.joined(separator: " ")
        }
    }
    
    // MARK: - 2. Nationality / store as object
    
    public struct Nationality {
        public var country = ""
        public var flagCode = ""
        
        public init() {}
        
        public init?(fromDictionary fire: [String: Any]) {
            self.country = fire["country"] as? String ?? ""
            self.flagCode = fire["flag_code"] as? String ?? ""
        }
        
        public func toFirestore() -> [String: Any] {
            [
                "country": country,
                "flag_code": flagCode
            ]
        }
    }
    
    // MARK: - 3. about me / store as object
    public struct AboutMeBio {
        public var aboutMe = ""
        public var bio = ""
        
        public init() {}
        
        public init?(fromDictionary fire: [String: Any]) {
            self.aboutMe = fire["about_me"] as? String ?? ""
            self.bio = fire["bio"] as? String ?? ""
        }
        
        public func toFirestore() -> [String: Any] {
            [
                "about_me": aboutMe,
                "bio": bio
            ]
        }
    }
    
    // MARK: - 4. GalleryImage / store as array
    public struct GalleryImage: Identifiable {
        public let id = UUID()
        public var name = ""
        public var imageUrl = ""
        
        public init() {}
        
        public init?(fromDictionary fire: [String: Any]) {
            self.name = fire["name"] as? String ?? ""
            self.imageUrl = fire["image_url"] as? String ?? ""
        }
        
        public func toFirestore() -> [String: Any] {
            [
                "name": name,
                "image_url": imageUrl
            ]
        }
    }
    
    // MARK: - 7. PreviousEmployment / store as array
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
            [
                "employer_name": employerName,
                "role": role,
                "start_date": startDate,
                "end_date": endDate,
                "description": description
            ]
        }
    }
    // MARK: - 6. Qualification / store as array
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
            [
                "doc_url": docURL,
                "institution": institution,
                "name": name,
                "level": level
            ]
        }
    }
    
    // MARK: - 7. SpokenLanguage / store as array
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
            [
                "lang": lang,
                "level": level
            ]
        }
    }
}
