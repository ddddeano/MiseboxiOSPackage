//
//  SwiftUIView.swift
//  
//
//  Created by Daniel Watson on 23.01.

import SwiftUI

@ViewBuilder
public func RecruiterPostContent(post: PostManager.Recruiter) -> some View {
    switch post.postType {
    case .recruiterCreated:
        RecruiterCreatedView(post: post)
    case .recruiterDeleted:
        RecruiterDeletedView(post: post)
    case .empty:
        Text("Empty Post")
    }
}

public struct RecruiterCreatedView: View {
    public var post: PostManager.Recruiter

    public init(post: PostManager.Recruiter) {
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

public struct RecruiterDeletedView: View {
    public var post: PostManager.Recruiter

    public init(post: PostManager.Recruiter) {
        self.post = post
    }

    public var body: some View {
        Text("Recruiter Deleted\(post.sender.username)")
    }
}
