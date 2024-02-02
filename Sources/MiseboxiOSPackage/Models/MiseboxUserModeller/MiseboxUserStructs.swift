//
//  MiseboxUserManagerStructs.swift
//
//  Created by Daniel Watson on 22.01.24.
//

import FirebaseFirestore // Import Firestore

extension MiseboxUserManager {
    
    
    public struct RoleType {
        public var doc: String
        public var collection: String
        public var profile: String
        public var profileCollection: String
    }

    public struct UserRole {
        public var roleType: RoleType
        public var screenName: String
        
        public func toFirestore() -> [String: Any] {
            ["role_type": roleType.doc, "screen_name": screenName]
        }
        
        public init(roleType: RoleType, screenName: String) {
            self.roleType = roleType
            self.screenName = screenName
        }
        
        public init?(dictionary: [String: Any]) {
            let doc = dictionary["role_type"] as? String
            let screenName = dictionary["screen_name"] as? String
            let resolvedRoleType = RoleTypes.roleType(for: doc ?? "")
            self.init(roleType: resolvedRoleType, screenName: screenName ?? "")
        }

    }


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
            ["first": first, "middle": middle, "last": last]
        }
    }
    
    public struct Subscription {
        public var type: SubscriptionType = .basic
        public var startDate: Timestamp = Timestamp()
        public var endDate: Timestamp = Timestamp()
        
        public init() {}
        
        public init?(fromDictionary fire: [String: Any]) {
            self.type = SubscriptionType(rawValue: fire["type"] as? String ?? "") ?? .basic
            self.startDate = fire["start_date"] as? Timestamp ?? Timestamp()
            self.endDate = fire["end_date"] as? Timestamp ?? Timestamp()
        }
        
        public func toFirestore() -> [String: Any] {
            [ "type": type.rawValue, "start_date": startDate, "end_date": endDate]
        }
        public enum SubscriptionType: String {
            case basic
            case trial
            case premium
        }
    }
}

