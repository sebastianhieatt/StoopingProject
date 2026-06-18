//
//  StoreView.swift
//  StoopingProject
//
//  Created by SebastianHieatt on 6/7/26.
//
// test

import SwiftUI

struct StoreView: View {
    @EnvironmentObject var shopify: ShopifyService
    @State private var viewMode: ViewMode? = nil

    enum ViewMode { case list, carousel }

    var body: some View {
        Group {
            switch viewMode {
            case .list:
                StoreListView(viewMode: $viewMode)
            case .carousel:
                StoreCarouselView(viewMode: $viewMode)
            case .none:
                // Landing screen with two buttons
                VStack(spacing: 20) {
                    Text("Browse the Shop")
                        .font(.title)
                        .fontWeight(.bold)

                    Button(action: { viewMode = .list }) {
                        HStack {
                            Image(systemName: "list.bullet")
                            Text("Browse All Items")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green.opacity(0.15))
                        .cornerRadius(12)
                    }

                    Button(action: { viewMode = .carousel }) {
                        HStack {
                            Image(systemName: "rectangle.stack.fill")
                            Text("Swipe Through Items")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green.opacity(0.15))
                        .cornerRadius(12)
                    }
                }
                .padding()
            }
        }
        .onAppear { shopify.fetchCollections(); shopify.fetchProducts() }
        
    }
}
