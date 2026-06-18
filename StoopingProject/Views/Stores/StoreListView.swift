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
    @Binding var viewMode: StoreView.ViewMode?
    @State private var selectedCategory: String = "All"

    let categories = ["All", "Accessories", "Apparel", "Art", "Baby", "Books & DVDs", "Cal Merch", "Calendars", "Collectibles", "Costume Jewelry", "Dorm Essentials", "Electronics", "Food", "Furniture", "Health & Beauty", "Holiday", "Home Decor", "Home Improvement", "Household Items", "Kitchenware", "Music & Instruments", "Party Supplies", "Pet Supplies", "School & Office Supplies", "Sports", "Toys & Games", "Water Bottles"]
    var filteredProducts: [Storefront.Product] {
        guard selectedCategory != "All" else { return shopify.products }
        
        guard let collection = shopify.collections.first(where: {
            $0.title == selectedCategory
        }) else { return [] }
        
        return collection.products.edges.map { $0.node }
    }

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {

                // MARK: - Category Chips
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(categories, id: \.self) { category in
                            Button(action: { selectedCategory = category }) {
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
                            VStack(spacing: 8) {
                                Text(product.productType)
                                    .font(.caption2)
                                    .foregroundColor(.red)

                                // Product Image
                                if let imageURL = product.images.edges.first?.node.url {
                                    AsyncImage(url: imageURL) { image in
                                        image
                                            .resizable()
                                            .scaledToFill()
                                    } placeholder: {
                                        Color.gray.opacity(0.2)
                                    }
                                    .frame(height: 150)
                                    .clipped()
                                    .cornerRadius(12)
                                } else {
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.gray.opacity(0.2))
                                        .frame(height: 150)
                                }

                                // Product Name
                                Text(product.title)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .multilineTextAlignment(.center)
                                    .lineLimit(2)
                                                            }
                            .padding(8)
                            .background(Color.white)
                            .cornerRadius(16)
                            .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("All Items")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { viewMode = .carousel }) {
                        Image(systemName: "rectangle.stack.fill")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { viewMode = nil }) {
                        Image(systemName: "chevron.left")
                    }
                }
            }
        }
    }
}
