//
//  MiseboxUserMockData.swift
//
//
//  Created by Daniel Watson on 26.01.24.
//

import Foundation
import FirebaseFirestore

extension MiseboxUserManager {
    static let tinyImg = "https://firebasestorage.googleapis.com:443/v0/b/misebox-78f9c.appspot.com/o/avatars%2Fdog5.jpg?alt=media&token=c1bf2892-b854-4078-9bed-c8266c5362d9"
    
    public static var exampleSubscription: Subscription {
        var subscription = Subscription()
        
        subscription.type = .basic
        subscription.startDate = Timestamp(date: Date())
        subscription.endDate = Timestamp(date: Calendar.current.date(byAdding: .year, value: 1, to: Date())!)
        
        return subscription
    }
    public static var exampleFullName: FullName {
        var fullName = FullName()
        fullName.first = "Daniel"
        fullName.middle = "Marc"
        fullName.last = "Watson"
        return fullName
    }
    
    public static var exampleUserRole: UserRole {
        let userRole = UserRole(role: .chef, name: "Deano")
        return userRole
    }
    
    public static func mockMiseboxUser() -> MiseboxUser {
        let mockUser = MiseboxUser()
        mockUser.id = "12345trewq"
        mockUser.username = "miseuserone"
        mockUser.imageUrl = tinyImg
        mockUser.verified = true
        mockUser.userRoles = [exampleUserRole]
        return mockUser
    }
    
    public static func mockMiseboxUserProfile() -> MiseboxUserProfile {
        let mockUserProfile = MiseboxUserProfile()
        mockUserProfile.id = mockMiseboxUser().id
        mockUserProfile.fullName = exampleFullName
        mockUserProfile.subscription = exampleSubscription
        mockUserProfile.accountProviders = ["email"]
        return mockUserProfile
    }
    
    public static func mockMiseboxUserManager() -> MiseboxUserManager {
        let mockMiseboxUser = MiseboxUserManager.mockMiseboxUser()
        let mockMiseboxUserProfile = MiseboxUserManager.mockMiseboxUserProfile()
        let mockMiseboxUserManager = MiseboxUserManager(miseboxUser: mockMiseboxUser, miseboxUserProfile: mockMiseboxUserProfile, role: .chef)
        return mockMiseboxUserManager
    }
}


