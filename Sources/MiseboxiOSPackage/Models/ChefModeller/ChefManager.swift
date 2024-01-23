//
//  File.swift
//  
//
//  Created by Daniel Watson on 22.01.24.
//

import Foundation
import FirebaseFirestore

public final class ChefManager: ObservableObject {
        
    var firestoreManager = FirestoreManager()
    var rootCollection = "chefs"
    
    var dependants = ["misebox-users", "chef-profiles"]
    
    var listener: ListenerRegistration?
    deinit {
        listener?.remove()
    }
    
    @Published public var chef: Chef
    
    public init(chef: Chef) {
        self.chef = chef
    }
}
public protocol CanChef {
    var miseboxUserManager: MiseboxUserManager { get }
    var chefManager: ChefManager { get }
    func createChef(skip: Bool) async throws
    func onboardChef() async
}
