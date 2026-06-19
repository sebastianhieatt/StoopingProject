//
//  StoreCarouselView.swift
//  StoopingProject
//
//  Created by SebastianHieatt on 6/17/26.
//

import SwiftUI
import Buy

struct StoreCarouselView: View {
    @EnvironmentObject var shopify: ShopifyService
        @State private var currentIndex = 0
        @State private var dragOffset: CGFloat = 0
        @State private var shuffledProducts: [Storefront.Product] = []

        var products: [Storefront.Product] { shuffledProducts }

        var body: some View {
            GeometryReader { geo in
                ZStack {
                    if products.isEmpty {
                        ProgressView()
                    } else {
                        ForEach(visibleIndices, id: \.self) { index in
                            CarouselCard(product: products[index])
                                .frame(width: geo.size.width, height: geo.size.height)
                                .offset(y: offset(for: index, height: geo.size.height))
                                .zIndex(index == currentIndex ? 1 : 0)
                        }
                    }
                }
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            dragOffset = value.translation.height
                        }
                        .onEnded { value in
                            let threshold: CGFloat = 100
                            withAnimation(.spring()) {
                                if value.translation.height < -threshold {
                                    goToNext()
                                } else if value.translation.height > threshold {
                                    goToPrevious()
                                }
                                dragOffset = 0
                            }
                        }
                )
            }
            .navigationTitle("Browse Items")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                if shopify.products.isEmpty {
                    shopify.fetchNextPage()
                }
                if shuffledProducts.isEmpty {
                    shuffledProducts = shopify.products.shuffled()
                }
            }
            .onChange(of: shopify.products.count) { _ in
                // Reshuffle once new products finish loading in
                if shuffledProducts.count != shopify.products.count {
                    shuffledProducts = shopify.products.shuffled()
                }
            }
        }

    // MARK: - Circular index helpers
    var visibleIndices: [Int] {
        guard !products.isEmpty else { return [] }
        return [previousIndex(), currentIndex, nextIndex()]
    }

    func nextIndex() -> Int {
        (currentIndex + 1) % products.count
    }

    func previousIndex() -> Int {
        (currentIndex - 1 + products.count) % products.count
    }

    func goToNext() {
        currentIndex = nextIndex()
    }

    func goToPrevious() {
        currentIndex = previousIndex()
    }

    func offset(for index: Int, height: CGFloat) -> CGFloat {
        if index == currentIndex {
            return dragOffset
        } else if index == nextIndex() {
            return height + dragOffset
        } else if index == previousIndex() {
            return -height + dragOffset
        }
        return height * 2 // off-screen
    }
}

// MARK: - Carousel Card
struct CarouselCard: View {
    let product: Storefront.Product
    @EnvironmentObject var shopify: ShopifyService
    @State private var addedToCart = false
    @State private var cartError: String? = nil

    var condition: String {
        let desc = product.description
        if desc.lowercased().hasPrefix("condition:") {
            return String(desc.dropFirst("condition:".count)).trimmingCharacters(in: .whitespaces)
        }
        return desc.isEmpty ? "Not specified" : desc
    }

    var body: some View {
        VStack(spacing: 16) {
            Spacer()

            if let imageURL = product.images.edges.first?.node.url {
                CachedAsyncImage(url: imageURL)
                    .scaledToFit()
                    .cornerRadius(16)
                    .frame(maxHeight: 350)
                    .padding(.horizontal)
            } else {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 350)
                    .padding(.horizontal)
            }

            VStack(spacing: 8) {
                Text(product.title)
                    .font(.title3)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                Label(condition.capitalized, systemImage: "checkmark.seal.fill")
                    .font(.subheadline)
                    .foregroundColor(.green)

                Text("Free")
                    .font(.headline)
                    .foregroundColor(.green)
            }

            if let error = cartError {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
            }

            Button(action: {
                guard let variantID = product.variants.edges.first?.node.id else { return }
                let success = shopify.addToCart(variantID: variantID)
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
                    Text(addedToCart ? "Added to Cart" : "Add to Cart")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(addedToCart || shopify.cartIsFull ? Color.gray : Color.green)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            .disabled(addedToCart || shopify.cartIsFull)
            .padding(.horizontal)

            Spacer()

            Text("Swipe up for next • Swipe down for previous")
                .font(.caption2)
                .foregroundColor(.gray)
                .padding(.bottom, 8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}
