//
//  SwiftUIView.swift
//  
//
//  Created by Daniel Watson on 23.01.24.
//

import SwiftUI

import SwiftUI

@ViewBuilder
public func ChefPostContent(post: PostManager.Chef) -> some View {
    switch post.postType {
    case .chefCreated:
        ChefCreatedView(post: post)
    case .chefDeleted:
        ChefDeletedView(post: post)
    case .empty:
        Text("Empty Post")
    }
}

public struct ChefCreatedView: View {
    public var post: PostManager.Chef

    public init(post: PostManager.Chef) {
        self.post = post
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(post.content.title)
                .font(.headline)
            Text(post.content.body)
                .font(.body)
        }
    }
}

public struct ChefDeletedView: View {
    public var post: PostManager.Chef

    public init(post: PostManager.Chef) {
        self.post = post
    }

    public var body: some View {
        Text("Chef Deleted\(post.sender.username)")
    }
}
