//
//  MiseboxUserManagerFunctions.swift
//
//
//  Created by Daniel Watson on 22.01.24.
//

import Foundation

extension MiseboxUserManager {
    
    public func checkMiseboxUserExistsInFirestore(doc: MiseboxUserDocCollectionMarker) async throws -> Bool {
        return try await firestoreManager.checkDocumentExists(collection: doc.collection(), documentID: self.id)
    }
    
    public func setMiseboxUserAndCreateProfile() async throws {
        try await firestoreManager.setDoc(inCollection: MiseboxUserDocCollectionMarker.miseboxUser.collection(), entity: self.miseboxUser)
        self.miseboxUserProfile.id = self.id
        try await firestoreManager.setDoc(inCollection: MiseboxUserDocCollectionMarker.miseboxUserProfile.collection(), entity: self.miseboxUserProfile)
    }
    
    public func documentListener(for doc: MiseboxUserDocCollectionMarker, completion: @escaping (Result<Void, Error>) -> Void) {
        switch doc {
        case .miseboxUser:
            self.listener = firestoreManager.addDocumentListener(for: self.miseboxUser) { result in
                switch result {
                case .success(_):
                    Task {
                        try await self.updateMiseboxUser(fieldName: "verified", newValue: true)
                    }
                    completion(.success(()))
                case .failure(let error):
                    print("Misebox User document listener failed with error: \(error.localizedDescription)")
                    
                }
            }
        case .miseboxUserProfile:
            self.listener = firestoreManager.addDocumentListener(for: self.miseboxUserProfile) { result in
                switch result {
                case .success(_):
                    print("Listening to Misebox User Profile success")
                case .failure(let error):
                    print("Misebox User Profile document listener failed with error: \(error.localizedDescription)")
                    
                }
            }
        }
    }
    
    public func collectionListener(for collection: MiseboxUserDocCollectionMarker, completion: @escaping (Result<[MiseboxUser], Error>) -> Void) {
        switch collection {
        case .miseboxUser:
            self.listener = firestoreManager.addCollectionListener(collection: MiseboxUserDocCollectionMarker.miseboxUser.collection(), completion: completion)
        case .miseboxUserProfile:
            self.listener = firestoreManager.addCollectionListener(collection: MiseboxUserDocCollectionMarker.miseboxUserProfile.collection(), completion: completion)
        }
    }
}
