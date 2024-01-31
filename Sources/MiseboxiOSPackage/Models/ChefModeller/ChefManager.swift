//
//  CentralChefManager.swift
//
//
//  Created by Daniel Watson on 22.01.24.
//

import Foundation
import FirebaseFirestore

public final class ChefManager: ObservableObject {
    var firestoreManager = FirestoreManager()
    
    public enum ChefDocCollectionMarker: String {
        case chef, chefProfile
        
        public func collection() -> String {
            switch self {
            case .chef:
                return "chefs"
            case .chefProfile:
                return "chef-profiles"
            }
        }
        public func doc() -> String {
            switch self {
            case .chef:
                return "chef"
            case .chefProfile:
                return "chef-profile"
            }
        }
    }
    
    var listener: ListenerRegistration?
    deinit {
        listener?.remove()
    }
    @Published public var chef: Chef
    @Published public var chefExists: Bool = false
    @Published public var chefProfile: ChefProfile
    
    public init(chef: Chef, chefProfile: ChefProfile) {
        self.chef = chef
        self.chefProfile = chefProfile

    }
    public func reset() {
        self.chef = Chef()
        self.chefProfile = ChefProfile()
        listener?.remove()
    }
    
    public enum ChefDependentCollections: String, CaseIterable {
        case miseboxUser, kitchen
        func toCollectionAndDocument() -> (collection: String, document: String) {
            switch self {
            case .miseboxUser:
                return ("misebox-users", "misebox-user")
            case .kitchen:
                return ("kitchens", "kitchen")
            }
        }
    }
}
public protocol CanChef {
    var miseboxUserManager: MiseboxUserManager { get }
    var chefManager: ChefManager { get }
    func createChef(skip: Bool) async throws
    func onboardChef() async
}

extension ChefManager {
    // developer funcs
    public func fetchAvatars() async throws -> [String] {
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
