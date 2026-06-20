//
//  StoreListView.swift
//  StoopingProject
//
//  Created by SebastianHieatt on 6/17/26.
//

import SwiftUI
import Buy

struct StoreListView: View {
    @EnvironmentObject var shopify: ShopifyService
    @State private var selectedCategory: String = "All"
    @State private var viewMode: ViewMode? = nil
    @State private var showCarousel = false
    
    enum ViewMode { case list, carousel }
    
    let categories = ["All", "Accessories", "Apparel", "Art", "Baby", "Books & DVDs", "Cal Merch", "Calendars", "Collectibles", "Costume Jewelry", "Dorm Essentials", "Electronics", "Food", "Furniture", "Health & Beauty", "Holiday", "Home Decor", "Home Improvement", "Household Items", "Kitchenware", "Music & Instruments", "Party Supplies", "Pet Supplies", "School & Office Supplies", "Sports", "Toys & Games", "Water Bottles"]
    var filteredProducts: [Storefront.Product] {
        if selectedCategory == "All" {
            return shopify.products
        }
        return shopify.collectionProducts
    }

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
            VStack(spacing: 0) {

                // MARK: - Category Chips
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(categories, id: \.self) { category in
                            Button(action: {
                                selectedCategory = category
                                if category != "All",
                                   let collection = shopify.collections.first(where: { $0.title == category }) {
                                    shopify.fetchProductsForCollection(collection)
                                }
                            }) {
                                Text(category)
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 8)
                                    .background(selectedCategory == category ? Color.green : Color.gray.opacity(0.15))
                                    .foregroundColor(selectedCategory == category ? .white : .primary)
                                    .cornerRadius(20)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                }

                Divider()

                // MARK: - Product Grid
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(filteredProducts, id: \.id) { product in
                            ProductCardView(product: product)
                        }

                        // Pagination trigger
                        paginationView
                    }
                    .padding()
                }
            }
            .navigationTitle("All Items")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showCarousel = true }) {
                        Image(systemName: "rectangle.stack.fill")
                    }
                    .background(
                        NavigationLink(destination: StoreCarouselView(), isActive: $showCarousel) {
                            EmptyView()
                        }
                    )
                }
                
                
            }
    }
    // MARK: - Pagination View
    var paginationView: some View {
        let isLoadingAny = selectedCategory == "All" ? shopify.isLoadingMore : shopify.isLoadingCollection
        let hasMore = selectedCategory == "All" ? shopify.hasNextPage : shopify.collectionHasNextPage

        return Group {
            if isLoadingAny {
                ProgressView().padding()
            } else if hasMore {
                Color.clear
                    .frame(height: 1)
                    .onAppear {
                        if selectedCategory == "All" {
                            shopify.fetchNextPage()
                        } else if let collection = shopify.collections.last(where: { $0.title == selectedCategory }) {
                            shopify.fetchProductsForCollection(collection)
                            
                        }
                    }
            }
        }
    }
    // MARK: - Product Card
    struct ProductCardView: View {
        let product: Storefront.Product

        var body: some View {
            
            NavigationLink(destination: ItemDescriptionView(product: product)) {
                VStack(spacing: 8) {
                    if let imageURL = product.images.edges.first?.node.url {
                        CachedAsyncImage(url: imageURL)
                            .frame(height: 150)
                            .clipped()
                            .cornerRadius(12)
                    } else {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 150)
                    }

                    Text(product.title)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .foregroundColor(.primary)
                }
                .padding(8)
                .background(Color.white)
                .cornerRadius(16)
                .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)
            }
        }
    }
}
