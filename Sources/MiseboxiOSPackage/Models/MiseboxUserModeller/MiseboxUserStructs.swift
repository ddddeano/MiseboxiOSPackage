//
//  MiseboxUserManagerStructs.swift
//
//  Created by Daniel Watson on 22.01.24.
//

import FirebaseFirestore // Import Firestore

extension MiseboxUserManager {
    
    public struct UserRole {
        public var role: UserDependantDocCollection
        public var name: String
        
        public init(role: UserDependantDocCollection, name: String) {
            self.role = role
            self.name = name
        }

        public init?(fromDictionary fire: [String: Any]) {
            guard let roleString = fire["role"] as? String,
                  let role = UserDependantDocCollection(rawValue: roleString) else { return nil }
            self.role = role
            self.name = fire["name"] as? String ?? ""
        }
        
        public func toFirestore() -> [String: Any] {
            return ["role": role.doc(), "name": name]
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
            ["first": first, "middle": middle, "last": last,]
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

