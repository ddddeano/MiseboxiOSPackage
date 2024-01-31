//
//  MiseboxUserProfile.swift
//
//
//  Created by Daniel Watson on 26.01.24.
//

import Foundation
import FirebaseFirestore

extension MiseboxUserManager {
    
    public final class MiseboxUserProfile: ObservableObject, Identifiable, Listenable {
        public var collectionName = "misebox-user-profiles"

        @Published public var id = ""
        @Published public var fullName = FullName()
        @Published public var subscription = Subscription()
        @Published public var accountProviders: [String] = []

        public init() {}

        public init?(documentSnapshot: DocumentSnapshot) {
            guard let data = documentSnapshot.data() else { return nil }
            self.id = documentSnapshot.documentID
            print("printong misebox user profile data", data)
            update(with: data)
        }

        public func update(with data: [String: Any]) {
            self.fullName = fireObject(from: data["full_name"] as? [String: Any] ?? [:], using: FullName.init) ?? FullName()
            self.subscription = fireObject(from: data["subscription"] as? [String: Any] ?? [:], using: Subscription.init) ?? Subscription()
            self.accountProviders = data["account_providers"] as? [String] ?? []
        }

        public func toFirestore() -> [String: Any] {
            [
                "full_name": fullName.toFirestore(),
                "subscription": subscription.toFirestore(),
                "account_providers": accountProviders
            ]
        }
    }
}
