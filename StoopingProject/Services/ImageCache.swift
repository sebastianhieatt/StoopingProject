//
//  ImageCache.swift
//  StoopingProject
//
//  Created by SebastianHieatt on 6/17/26.
//
import SwiftUI

class ImageCache {
    static let shared = NSCache<NSURL, UIImage>()
}

struct CachedAsyncImage: View {
    let url: URL
    @State private var image: UIImage? = nil

    // Add this to request a smaller image from Shopify's CDN
    var thumbnailURL: URL {
        let urlString = url.absoluteString
        // Shopify CDN supports size parameters like _100x100, _200x200
        if let range = urlString.range(of: ".", options: .backwards) {
            let base = String(urlString[..<range.lowerBound])
            let ext = String(urlString[range.lowerBound...])
            return URL(string: "\(base)_200x200\(ext)") ?? url
        }
        return url
    }

    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                Color.gray.opacity(0.2)
                    .onAppear { loadImage() }
            }
        }
    }

    private func loadImage() {
        if let cached = ImageCache.shared.object(forKey: thumbnailURL as NSURL) {
            self.image = cached
            return
        }
        URLSession.shared.dataTask(with: thumbnailURL) { data, _, _ in
            if let data = data, let img = UIImage(data: data) {
                ImageCache.shared.setObject(img, forKey: thumbnailURL as NSURL)
                DispatchQueue.main.async { self.image = img }
            }
        }.resume()
    }
}
