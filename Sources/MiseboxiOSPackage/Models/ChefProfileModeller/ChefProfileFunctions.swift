//
//  File.swift
//  
//
//  Created by Daniel Watson on 22.01.24.
//

import Foundation
extension ChefProfileManager {
   
    public func documentListener() {
        print("listning with: \(self.id)" )

        self.listener = firestoreManager.addDocumentListener(for: self.chefProfile) { result in
            print("listning with: \(self.id)" )
            switch result {
            case .success(_):
                print("Listening to Chef Profile \(self.nickname) success")
            case .failure(let error):
                print("Document listener failed with error: \(error.localizedDescription)")
            }
        }
    }
    
    public func update(data: [String: Any]) async throws  {
        print("[ChefProfileManager] updating \(id) with: \(data)" )
        firestoreManager.updateDocument(collection: rootCollection, documentID: id, updateData: data)
    }
    
    public func updateSection(section: String, data: [[String: Any]]) async throws {
        firestoreManager.updateDocumentSection(
            collection: rootCollection,
            documentID: self.id,
            section: section,
            updateData: data
        )
    }
    
    public func fetchAvatars() async throws -> [String] {
        //place holder avatars
        do {
            let urls = try await firestoreManager.fetchBucket(bucket: "avatars")
            print("Avatars fetched:")
            for url in urls {
                print(url)
            }
            return urls
        } catch {
            print("Error fetching chef avatars: \(error.localizedDescription)")
            throw error
        }
    }
}
