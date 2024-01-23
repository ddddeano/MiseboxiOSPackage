//
//  SwiftUIView.swift
//  
//
//  Created by Daniel Watson on 23.01.24.
//

import SwiftUI

struct PostView: View {
    var post: Postable
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            PostHeader(post: post)
            PostContentView(post: post)
        }
        .padding(10)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

@ViewBuilder
private func PostContentView(post: Postable) -> some View {
    if let collectionName = PostManager.PostableCollectionNames(rawValue: post.subject.collectionName) {
        switch collectionName {
        case .chefs:
            ChefPostContent(post: post as! PostManager.Chef)
        case .gigs:
            Text("gig")
        case .recruiters:
            Text("recruiter Post")
    } else {
        Text("Unknown Collection")
            .foregroundColor(.red) // Display in red text for error
    }
}


struct PostHeader: View {
    var post: Postable
    
    var body: some View {
        HStack(spacing: 10) {
            AvatarView(imageUrl: post.sender.imageUrl, width: 30, height: 30, onSelect: { print("Avatar clicked") })
            
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .bottom, spacing: 2) {
                    Text(post.sender.name)
                        .font(.subheadline)
                    Text(post.sender.role.uppercased())
                        .font(.system(size: 10))
                        .foregroundColor(.gray)
                        .baselineOffset(2)
                }
                Text(PostManager.formattedDate(from: post.timestamp))
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}



struct PostDetailView: View {
    var post: Postable
    @Binding var navigationPath: NavigationPath

    var body: some View {

        Text("Subject Detail: \(post.sender.name)")
    }
}


