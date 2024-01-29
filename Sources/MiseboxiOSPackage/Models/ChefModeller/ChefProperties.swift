//
//  ChefProperties.swift
//
//
//  Created by Daniel Watson on 25.01.24.
//

import Foundation

extension ChefManager {
    
    public var id: String {
        return chef.id
    }
    public var name: String {
        return chef.name
    }
    public var miseboxUser: ChefManager.MiseboxUser {
        return chef.miseboxUser
    }
    public var primaryKitchen: ChefManager.Kitchen? {
        return chef.primaryKitchen
    }
    public var kitchens: [ChefManager.Kitchen] {
        return chef.kitchens
    }
    public var username: String {
        return chef.generalInfo.username
    }
    public var nickname: String {
        return chef.generalInfo.nickname
    }
    public var imageUrl: String {
        return chef.generalInfo.imageUrl
    }
    public var toMiseboxUser: MiseboxUserManager.UserRole {
        return MiseboxUserManager.UserRole(role: .chef, name: name)
    }
}
