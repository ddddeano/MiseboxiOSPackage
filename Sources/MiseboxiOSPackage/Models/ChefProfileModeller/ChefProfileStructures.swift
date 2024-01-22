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
    struct FullName {
        var first = ""
        var middle = ""
        var last = ""
        
        init() {}
        init?(fromDictionary fire: [String: Any]) {
            self.first = fire["first"] as? String ?? ""
            self.middle = fire["middle"] as? String ?? ""
            self.last = fire["last"] as? String ?? ""
        }
        
        func toFirestore() -> [String: Any] {
            return [
                "full_name": [
                    "first": first,
                    "middle": middle,
                    "last": last
                ]
            ]
        }
        
        var formatted: String {
            [first, middle, last].filter { !$0.isEmpty }.joined(separator: " ")
        }
    }
    
    // MARK: - 2. Nationality / store as object

    struct Nationality {
        var country = ""
        var flagCode = ""
        
        init() {}
        
        init?(fromDictionary fire: [String: Any]) {
            self.country = fire["country"] as? String ?? ""
            self.flagCode = fire["flag_code"] as? String ?? ""
        }
        
        func toFirestore() -> [String: Any] {
            return [
                "nationality": [
                    "country": country,
                    "flag_code": flagCode
                ]
            ]
        }
    }
    
    // MARK: - 3. about me / store as object
    struct AboutMeBio {
           var aboutMe = ""
           var bio = ""
           
           init() {}

           init?(fromDictionary fire: [String: Any]) {
               self.aboutMe = fire["about_me"] as? String ?? ""
               self.bio = fire["bio"] as? String ?? ""
           }

           func toFirestore() -> [String: Any] {
               return [
                "about_me_bio": [
                   "about_me": aboutMe,
                   "bio": bio
                   ]
               ]
           }
       }
    
    // MARK: - 4. GalleryImage / store as array
    struct GalleryImage: Identifiable {
        let id = UUID()
        var name = ""
        var imageUrl = ""
        
        init() {}
        
        init?(fromDictionary fire: [String: Any]) {
            self.name = fire["name"] as? String ?? ""
            self.imageUrl = fire["image_url"] as? String ?? ""
        }
        
        func toFirestore() -> [String: Any] {
            return [
                    "name": name,
                    "image_url": imageUrl
            ]
        }
    }
    
    // MARK: - 7. PreviousEmployment / store as array
    struct PreviousEmployment: Identifiable {
        let id = UUID()
        var employerName = ""
        var role = ""
        var startDate = ""
        var endDate = ""
        var description = ""
        
        init() {}
        
        init?(fromDictionary fire: [String: Any]) {
            self.employerName = fire["employer_name"] as? String ?? ""
            self.role = fire["role"] as? String ?? ""
            self.startDate = fire["start_date"] as? String ?? ""
            self.endDate = fire["end_date"] as? String ?? ""
            self.description = fire["description"] as? String ?? ""
        }
        var isValid: Bool {
               !employerName.isEmpty && !role.isEmpty
           }
        func toFirestore() -> [String: Any] {
            return [
                    "employer_name": employerName,
                    "role": role,
                    "start_date": startDate,
                    "end_date": endDate,
                    "description": description
            ]
        }
    }
    // MARK: - 6. Qualification / store as array
    struct Qualification: Identifiable {
        let id = UUID()
        var docURL = ""
        var institution = ""
        var name = ""
        var level = ""
        
        init() {}
        
        init?(fromDictionary fire: [String: Any]) {
            self.docURL = fire["doc_url"] as? String ?? ""
            self.institution = fire["institution"] as? String ?? ""
            self.name = fire["name"] as? String ?? ""
            self.level = fire["level"] as? String ?? ""
        }
            var isValid: Bool {
                !name.isEmpty && !institution.isEmpty
            }

        func toFirestore() -> [String: Any] {
            return [
                    "doc_url": docURL,
                    "institution": institution,
                    "name": name,
                    "level": level
            ]
        }
    }
    
    // MARK: - 7. SpokenLanguage / store as array
    struct SpokenLanguage: Identifiable {
        let id = UUID()
        var lang = ""
        var level = ""
        
        init() {}
        
        init?(fromDictionary fire: [String: Any]) {
            self.lang = fire["lang"] as? String ?? ""
            self.level = fire["level"] as? String ?? ""
        }
        
        func toFirestore() -> [String: Any] {
            return [
                    "lang": lang,
                    "level": level
            ]
        }
    }
}
