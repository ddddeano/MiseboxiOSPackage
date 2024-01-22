//
//  File.swift
//  
//
//  Created by Daniel Watson on 22.01.24.
//

import Foundation
import Combine
import Firebase
import FirebaseStorage
import FirebaseFirestore



public class FirestoreManager {
    private let db = Firestore.firestore()
    
    // MARK: - Enums
    public enum FirestoreError: Error {
        case unknown, invalidSnapshot, networkError, documentNotFound
    }
    
    public init() {}
    // MARK: - Document Management
    
    public func checkDocumentExists(collection: String, documentID: String) async throws -> Bool {
        let docRef = db.collection(collection).document(documentID)
        let documentSnapshot = try await docRef.getDocument()
        return documentSnapshot.exists
    }
    
    // Add a new document to the specified collection
    public func createDoc<T: FirestoreEntity>(collection: String, entity: T) async throws -> String {
        do {
            let document = try await db.collection(collection).addDocument(data: entity.toFirestore())
            return document.documentID
        } catch {
            throw error // Re-throw the error to be handled by the caller
        }
    }
    
    public func setDoc<T: FirestoreEntity>(collection: String, entity: T, merge: Bool = false) async throws {
        let docRef = db.collection(collection).document(entity.id)
        try await docRef.setData(entity.toFirestore(), merge: merge)
    }
    
    @discardableResult
    public func createFeedEntry<T: Postable>(entry: T) async throws -> String {
         do {
             let document = try await db.collection("posts").addDocument(data: entry.toFeedEntry())
             print("Post entry created successfully. Document ID: \(document.documentID)")
             print("Entry details: \(entry.toFeedEntry())")
             return document.documentID
         } catch {
             print("Error creating feed entry: \(error)")
             throw error
         }
     }
    
    public func addDocumentListener<T: Listenable>(for entity: T, completion: @escaping (Result<T, Error>) -> Void) -> ListenerRegistration {
        let docRef = db.collection(entity.collectionName).document(entity.id)
        return docRef.addSnapshotListener { documentSnapshot, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Firestore error: \(error.localizedDescription)")
                    completion(.failure(error))
                    return
                }
                guard let document = documentSnapshot, document.exists, let data = document.data() else {
                    print("Document does not exist or no data found")
                    completion(.failure(NSError(domain: "FirestoreManager", code: -2, userInfo: [NSLocalizedDescriptionKey: "Document does not exist or no data found"])))
                    return
                }
                
                print("Received document data: \(data)")
                var updatedEntity = entity
                updatedEntity.update(with: data)
                completion(.success(updatedEntity))
            }
        }
    }

    public func addCollectionListener<T: FirestoreEntity>(collection: String, completion: @escaping (Result<[T], Error>) -> Void) -> ListenerRegistration {
        let collectionRef = db.collection(collection)
        return collectionRef.addSnapshotListener { querySnapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let snapshot = querySnapshot else {
                completion(.failure(NSError(domain: "FirestoreManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Snapshot is nil"])))
                return
            }
            var entities = [T]()
            for document in snapshot.documents {
                if let entity = T(documentSnapshot: document) {
                    entities.append(entity)
                }
            }
            completion(.success(entities))
        }
    }
    
    public func updateDocument(collection: String, documentID: String, updateData: [String: Any], merge: Bool = true) {
        let docRef = db.collection(collection).document(documentID)
        docRef.setData(updateData, merge: merge) { error in
            if let error = error {
                print("FirestoreManager[updateDocument] Error updating document: \(error.localizedDescription)")
            }
        }
    }
    
    public func updateDocumentSection(collection: String, documentID: String, section: String, updateData: [String: Any]) {
            let docRef = db.collection(collection).document(documentID)
            var dataToUpdate = [String: Any]()
            dataToUpdate[section] = updateData

            docRef.updateData(dataToUpdate) { error in
                if let error = error {
                    print("Firestore error in updateDocumentSection: \(error.localizedDescription)")
                }
            }
        }
    public func updateDocumentDependant(collection: String, documentID: String, field: String, value: Any, operation: FirestoreFieldValueOperation) async {
        let docRef = db.collection(collection).document(documentID)
        do {
            switch operation {
            case .arrayUnion:
                try await docRef.updateData([field: FieldValue.arrayUnion([value])])
            case .arrayRemove:
                try await docRef.updateData([field: FieldValue.arrayRemove([value])])
            case .replaceArray:
                try await docRef.updateData([field: value])
            }
        } catch {
            print("Firestore error: \(error)")
        }
    }

    public func deleteDocument(collection: String, documentID: String) async throws {
        let docRef = db.collection(collection).document(documentID)
        do {
            try await docRef.delete()
            // Optionally, handle successful deletion here
        } catch {
            // Internal error handling
            print("Firestore error in deleteDocument: \(error)")
            // Further handling, such as logging or notifying a monitoring service
        }
    }

    public enum FirestoreFieldValueOperation {
        case arrayUnion, arrayRemove, replaceArray
    }
    
   public func fetchBucket(bucket: String) async throws -> [String] {
        let storage = Storage.storage()
        let storageReference = storage.reference().child(bucket) // Adjust the path as necessary

        let result = try await storageReference.listAll()

        return try await withThrowingTaskGroup(of: String?.self, returning: [String].self) { group in
            var urls = [String]()

            for item in result.items {
                group.addTask {
                    let url = try? await item.downloadURL()
                    return url?.absoluteString
                }
            }

            for try await url in group {
                if let url = url {
                    urls.append(url)
                }
            }

            return urls
        }
    }

}

public protocol FirestoreEntity {
    var id: String { get set }
    init?(documentSnapshot: DocumentSnapshot)
    func toFirestore() -> [String: Any]
    var collectionName: String { get } // Add this line
}

public protocol Postable {
    var id: String { get }
    var sender: PostManager.Sender { get }
    var subject: PostManager.PostSubject { get }
    var content: PostManager.PostContent { get }
    var timestamp: Date { get }
    
    init(sender: PostManager.Sender, subject: PostManager.PostSubject, content: PostManager.PostContent, postType: any PostType)
    init?(documentSnapshot: DocumentSnapshot)
    func toFeedEntry() -> [String: Any]
}

public protocol Listenable: FirestoreEntity {
    mutating func update(with data: [String: Any])
}

public func fireObject<T>(from dictionaryData: [String: Any], using initializer: (Dictionary<String, Any>) -> T?) -> T? {
    return initializer(dictionaryData)
}
public func fireArray<T>(from arrayData: [[String: Any]], using initializer: (Dictionary<String, Any>) -> T?) -> [T] {
    return arrayData.compactMap(initializer)
}

