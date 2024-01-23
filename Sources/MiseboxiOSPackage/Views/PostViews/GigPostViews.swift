//
//  SwiftUIView.swift
//  
//
//  Created by Daniel Watson on 23.01.24.
//


import SwiftUI

public struct GigPost: View {
    let gig: PostManager.Gig

    public var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            GigFeedContent(gig: gig)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}

@ViewBuilder
private func GigFeedContent(gig: PostManager.Gig) -> some View {
    switch gig.postType {
    case .slowGig:
        Text("slow gig")
    case .fastGig:
        Text("fast gig")
    case .empty:
        Text("Empty")
    }
}


private struct GigDeletedView: View {
    let gig: PostManager.Gig

    public var body: some View {
        Text("Gig Removed 👋").font(.headline)
    }
}

private struct GigImageView: View {
    let imageUrl: String

    public var body: some View {
        if let url = URL(string: imageUrl), !imageUrl.isEmpty {
            AsyncImage(url: url) { image in
                image.resizable()
            } placeholder: {
                Color.gray
            }
            .frame(width: 100, height: 100)
            .clipShape(Circle())
        }
    }
}
