//
//  File.swift
//  
//
//  Created by Daniel Watson on 23.01.24.
//

import Foundation

extension RecruiterProfileManager {
    
    // MARK: - 1. CompanyName / store as object
    public struct CompanyName {
        public var name = ""
        
        public init() {}
        
        public init?(fromDictionary fire: [String: Any]) {
            self.name = fire["name"] as? String ?? ""
        }
        
        public func toFirestore() -> [String: Any] {
            [
                "name": name
            ]
        }
    }
    
    // MARK: - 2. AboutUs / store as object
    public struct AboutUs {
        public var description = ""
        
        public init() {}
        
        public init?(fromDictionary fire: [String: Any]) {
            self.description = fire["description"] as? String ?? ""
        }
        
        public func toFirestore() -> [String: Any] {
            [
                "description": description
            ]
        }
    }
    
    // MARK: - 3. GalleryImage / store as array
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
    
    // MARK: - 4. ContactInfo / store as object
    public struct ContactInfo {
        public var email = ""
        public var phone = ""
        
        public init() {}
        
        public init?(fromDictionary fire: [String: Any]) {
            self.email = fire["email"] as? String ?? ""
            self.phone = fire["phone"] as? String ?? ""
        }
        
        public func toFirestore() -> [String: Any] {
            [
                "email": email,
                "phone": phone
            ]
        }
    }
}
