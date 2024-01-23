//
//  File.swift
//  
//
//  Created by Daniel Watson on 22.01.24.
//

import Foundation
import FirebaseFirestore

public protocol PostType {
    var rawValue: String { get }
    // You can add more requirements if needed
}

public final class PostManager {
    
    private var firestoreManager = FirestoreManager()
    private var rootCollection = "posts"
    private var listener: ListenerRegistration?
    
    @discardableResult
    public func createFeedEntry<T: Postable>(entry: T) async throws -> String {
        try await firestoreManager.createFeedEntry(entry: entry)
    }
    
    public init() {}
    public enum PostableCollectionNames: String {
        case chefs = "chefs"
        case gigs = "gigs"
        case recruiters = "recruiters" // Added 'recruiters' collection
        
        public init?(rawValue: String) {
            switch rawValue {
            case "chefs":
                self = .chefs
            case "gigs":
                self = .gigs
            case "recruiters": // Added case for 'recruiters'
                self = .recruiters
            default:
                return nil
            }
        }
    }

    
    public struct Sender {
        public var id = ""
        public var name = ""
        public var role = ""
        public var imageUrl = ""
        
        public init(fromDictionary fire: [String: Any]? = nil) {
            self.id = fire?["id"] as? String ?? id
            self.name = fire?["name"] as? String ?? name
            self.role = fire?["role"] as? String ?? role
            self.imageUrl = fire?["image_url"] as? String ?? imageUrl
        }
        
        public init(id: String, name: String, role: String, imageUrl: String = "") {
            self.id = id
            self.name = name
            self.role = role
            self.imageUrl = imageUrl
        }
        
        public func toFirestore() -> [String: Any] {
            ["id": id, "name": name, "role": role, "image_url": imageUrl]
        }
    }
    
    public struct PostSubject {
        public var subjectId = ""
        public var collectionName = ""
        
        public init(fromDictionary fire: [String: Any]? = nil) {
            self.subjectId = fire?["subject_id"] as? String ?? subjectId
            self.collectionName = fire?["collection_name"] as? String ?? collectionName
        }
        
        public init(subjectId: String, collectionName: String) {
            self.subjectId = subjectId
            self.collectionName = collectionName
        }
        
        public func toFirestore() -> [String: Any] {
            ["subject_id": subjectId, "collection_name": collectionName]
        }
    }
    
    public struct PostContent {
        public var title = ""
        public var body = ""
        public var imageUrl: String?
        
        public init(fromDictionary fire: [String: Any]? = nil) {
            self.title = fire?["title"] as? String ?? title
            self.body = fire?["body"] as? String ?? body
            self.imageUrl = fire?["image_url"] as? String ?? imageUrl
        }
        
        public init(title: String, body: String, imageUrl: String? = nil) {
            self.title = title
            self.body = body
            self.imageUrl = imageUrl
        }
        
        public func toFirestore() -> [String: Any] {
            return [
                "title": title,
                "body": body,
                "image_url": imageUrl ?? ""
            ]
        }
    }
    
    public func documentListenerChef(chefId: String, completion: @escaping (Result<ChefManager.Chef, Error>) -> Void) -> ListenerRegistration {
        let chef = ChefManager.Chef()
        return firestoreManager.addDocumentListener(for: chef, completion: completion)
    }
    
    
    public  enum PostManagerError: Error {
        case firestoreError(Error)
        case noDocuments
        case invalidData
    }
    
    public func localCollectionListener(completion: @escaping (Result<[Postable], Error>) -> Void) {
        let collectionRef = Firestore.firestore().collection(rootCollection)
        listener = collectionRef.addSnapshotListener { querySnapshot, error in
            print("Firestore snapshot listener triggered") // Add this for debugging
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                completion(.failure(NSError(domain: "PostManager", code: 0, userInfo: [NSLocalizedDescriptionKey: "No documents found"])))
                return
            }
            var posts: [Postable] = []
            for document in documents {
                guard let subjectData = document.data()["subject"] as? [String: Any],
                      let collectionNameRaw = subjectData["collection_name"] as? String,
                      let collectionName = PostableCollectionNames(rawValue: collectionNameRaw) else {
                    continue
                }

                switch collectionName {
                case .chefs:
                    if let post = PostManager.Chef(documentSnapshot: document) {
                        posts.append(post)
                    }
                case .gigs:
                    if let post = PostManager.Gig(documentSnapshot: document) {
                        posts.append(post)
                    }
                case .recruiters:
                    if let post = PostManager.Recruiter(documentSnapshot: document) {
                        posts.append(post)
                    }
                }
            }

            completion(.success(posts))

        }
    }
    
    public static func formattedDate(from date: Date) -> String {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.day], from: date, to: now)
        
        if calendar.isDateInToday(date) {
            return "Today"
        } else if calendar.isDateInYesterday(date) {
            return "Yesterday"
        } else if let dayDifference = components.day, dayDifference <= 6 {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE" // Day of the week
            return formatter.string(from: date)
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "d MMM" // Custom date format
            return formatter.string(from: date)
        }
    }
    public enum ChefPostType: String, PostType {
        case chefCreated = "chef_created"
        case chefDeleted = "chef_deleted"
        case empty = ""
        
        public init?(rawValue: String) {
            switch rawValue {
            case "chef_created":
                self = .chefCreated
            case "chef_deleted":
                self = .chefDeleted
            default:
                self = .empty
            }
        }
    }

    public enum GigPostType: String, PostType {
        case slowGig = "slow_gig"
        case fastGig = "fast_gig"
        case empty = ""
        
        public init?(rawValue: String) {
            switch rawValue {
            case "slow_gig":
                self = .slowGig
            case "fast_gig":
                self = .fastGig
            default:
                self = .empty
            }
        }
    }

    public enum RecruiterPostType: String, PostType {
        case recruiterCreated = "recruiter_created"
        case recruiterDeleted = "recruiter_deleted"
        case empty = ""
        
        public init?(rawValue: String) {
            switch rawValue {
            case "recruiter_created":
                self = .recruiterCreated
            case "recruiter_deleted":
                self = .recruiterDeleted
            default:
                self = .empty
            }
        }
    }
}
