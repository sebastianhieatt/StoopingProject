//
//  ItemDescriptionView.swift
//  StoopingProject
//
//  Created by SebastianHieatt on 6/7/26.
//

import SwiftUI
import Buy

struct ItemDescriptionView: View {
    let product: Storefront.Product
    @EnvironmentObject var shopify: ShopifyService
    @State private var cartError: String? = nil
    @State private var selectedImageIndex = 0
    @State private var isPickupExpanded = false
    @State private var isAIExpanded = false
    @State private var addedToCart = false

    var condition: String {
        let desc = product.description
        if desc.lowercased().hasPrefix("condition:") {
            return String(desc.dropFirst("condition:".count)).trimmingCharacters(in: .whitespaces)
        }
        return desc.isEmpty ? "Not specified" : desc
    }

    var images: [URL] {
        product.images.edges.compactMap { $0.node.url }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

                // MARK: - Image Gallery
                if !images.isEmpty {
                    TabView(selection: $selectedImageIndex) {
                        ForEach(images.indices, id: \.self) { index in
                            CachedAsyncImage(url: images[index])
                                .scaledToFit()
                                .cornerRadius(12)
                                .tag(index)
                        }
                    }
                    .tabViewStyle(.page)
                    .frame(height: 300)

                    // Image dots indicator
                    if images.count > 1 {
                        HStack(spacing: 6) {
                            ForEach(images.indices, id: \.self) { index in
                                Circle()
                                    .fill(index == selectedImageIndex ? Color.green : Color.gray.opacity(0.4))
                                    .frame(width: 8, height: 8)
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                } else {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 300)
                }

                VStack(alignment: .leading, spacing: 16) {
                    
                    // MARK: - Title
                    if let error = cartError {
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                    Text(product.title)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    // MARK: - Condition & Price
                    HStack {
                        Label(condition.capitalized, systemImage: "checkmark.seal.fill")
                            .font(.subheadline)
                            .foregroundColor(.green)
                        
                        Spacer()
                        
                        Text("Free")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                    }
                    
                    Divider()
                    
                    // MARK: - Expandable Tab 1
                    ExpandableTab(
                        title: "Local Pickup Only",
                        content: "All items are available for local pickup only. Once you place your order, we'll text and/or email you with pickup details.",
                        isExpanded: $isPickupExpanded
                    )
                    
                    Divider()
                    
                    // MARK: - Expandable Tab 2
                    ExpandableTab(
                        title: "Image Editing & AI Use",
                        content: "Images may be edited with AI for clarity. All items are real.",
                        isExpanded: $isAIExpanded
                    )
                    
                    Divider()
                    
                    // MARK: - Add to Cart Button
                    Button(action: {
                        let success = shopify.addToCart(variantID: product.variants.edges.first!.node.id)
                        if success {
                            addedToCart = true
                            cartError = nil
                        } else if shopify.cartIsFull {
                            cartError = "Your cart is full (10 item maximum)."
                        } else {
                            cartError = "This item is already in your cart."
                        }
                    }) {
                        HStack {
                            Image(systemName: addedToCart ? "checkmark" : "cart.badge.plus")
                            Text(addedToCart ? "Added to Cart (\(shopify.cartCount)/10)" : "Add to Cart")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(addedToCart || shopify.cartIsFull ? Color.gray : Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    .disabled(addedToCart || shopify.cartIsFull)

                    // MARK: - Checkout Button
                    NavigationLink(destination: CheckoutPageView()) {
                        HStack {
                            Image(systemName: "creditcard.fill")
                            Text("Proceed to Checkout")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green.opacity(0.15))
                        .foregroundColor(.green)
                        .cornerRadius(12)
                    }
                }
                .padding(.horizontal)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Expandable Tab
struct ExpandableTab: View {
    let title: String
    let content: String
    @Binding var isExpanded: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Button(action: { withAnimation { isExpanded.toggle() } }) {
                HStack {
                    Text(title)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.gray)
                }
            }

            if isExpanded {
                Text(content)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .transition(.opacity)
            }
        }
    }
}
