//
//  CheckoutPageView.swift
//  StoopingProject
//
//  Created by SebastianHieatt on 6/7/26.
//

import SwiftUI
import Buy
import ShopifyCheckoutSheetKit
import Foundation

struct CheckoutPageView: View {
    @EnvironmentObject var shopify: ShopifyService
    @State private var fetchedProducts: [String: Storefront.Product] = [:]
    @State private var isSubmitting = false
    @State private var showCheckoutSheet = false
    @State private var errorMessage: String? = nil
    
    func resolvedProduct(for item: ShopifyService.CartItem) -> Storefront.Product? {
        if let cached = fetchedProducts[item.productID] {
            return cached
        }
        if let local = shopify.products.first(where: { $0.id.rawValue == item.productID }) {
            return local
        }
        if let local = shopify.collectionProducts.first(where: { $0.id.rawValue == item.productID }) {
            return local
        }
        fetchMissingProduct(productID: item.productID)
        return nil
    }

    func fetchMissingProduct(productID: String) {
        guard fetchedProducts[productID] == nil else { return }
        shopify.fetchProduct(by: GraphQL.ID(rawValue: productID)) { product in
            if let product = product {
                fetchedProducts[productID] = product
            }
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                // MARK: - Cart Summary
                SectionHeader(title: "Order Summary")

                VStack(spacing: 0) {
                    if shopify.cartItems.isEmpty {
                        Text("Your cart is empty.")
                            .foregroundColor(.secondary)
                            .padding()
                    } else {
                        ForEach(shopify.cartItems, id: \.variantID) { item in
                            if let product = resolvedProduct(for: item) {
                                HStack(spacing: 12) {
                                    if let imageURL = product.images.edges.first?.node.url {
                                        CachedAsyncImage(url: imageURL)
                                            .frame(width: 50, height: 50)
                                            .clipped()
                                            .cornerRadius(8)
                                    } else {
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.gray.opacity(0.2))
                                            .frame(width: 50, height: 50)
                                    }

                                    Text(product.title)
                                        .font(.subheadline)
                                        .lineLimit(2)

                                    Spacer()

                                    Text("Free")
                                        .font(.subheadline)
                                        .foregroundColor(.green)

                                    Button(action: {
                                        shopify.removeFromCart(variantID: GraphQL.ID(rawValue: item.variantID))
                                    }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.gray)
                                    }
                                }
                                .padding()
                            } else {
                                HStack {
                                    ProgressView()
                                    Text("Loading item...")
                                        .foregroundColor(.secondary)
                                }
                                .padding()
                            }
                        }

                        Divider()

                        HStack {
                            Text("\(shopify.cartCount) item\(shopify.cartCount == 1 ? "" : "s")")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            Spacer()
                            Text("Free")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.green)
                        }
                        .padding()
                    }
                }
                .checkoutCard()

                // MARK: - Pickup Details
                SectionHeader(title: "Pickup Details")
                Text("There is 1 location with your item")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text("Security Public Storage parking lot")
                            .fontWeight(.semibold)
                        Spacer()
                        Text("FREE")
                            .fontWeight(.bold)
                    }
                    Text("1711 Eastshore Boulevard, El Cerrito CA 94530, United States")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    HStack(alignment: .top, spacing: 6) {
                        Image(systemName: "clock")
                            .foregroundColor(.secondary)
                            .font(.caption)
                            .padding(.top, 2)
                        Text("Pickup Sundays, 2–3 PM only. No alternate times. Please reply to your order confirmation message (via text and/or email) by end of day Friday or your order will be canceled and items relisted. No returns or exchanges.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)

                // MARK: - Payment
                SectionHeader(title: "Payment")
                Text("Local pickup only. Shopify requires an address to complete checkout. We do not ship items. A campus or nearby address is acceptable.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Text("Your order is free. No payment is required.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)

                // MARK: - Error
                if let error = errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.caption)
                }

                // MARK: - Complete Order Button
                Button(action: completeOrder) {
                    HStack {
                        if isSubmitting {
                            ProgressView()
                                .tint(.white)
                        }
                        Text(isSubmitting ? "Placing Order..." : "Complete order")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isFormValid ? Color.green : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .disabled(!isFormValid || isSubmitting)
                
                
            }
            .padding()
        }
        .navigationTitle("Checkout")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showCheckoutSheet) {
            if let url = shopify.checkoutURL {
                CheckoutSheet(checkout: url)
                    .onCancel {
                        print("🔴 onCancel FIRED")
                        showCheckoutSheet = false
                        NotificationManager.scheduleCheckoutConfirmation()
                    }
                    .onComplete { event in
                        print("Order placed successfully!")
                        shopify.recordCheckout()
                        fetchedProducts = [:]
                        NotificationManager.scheduleCheckoutConfirmation()
                        NotificationManager.schedulePickupNotificationsForOrder(sundayDate: Date())
                    }
                    .onFail { error in
                        print("⚠️ Checkout failed: \(error)")
                    }
                    .edgesIgnoringSafeArea(.all)
            }
        }
    }
    
        
    // MARK: - Validation
    var isFormValid: Bool {
        !shopify.cartItems.isEmpty
    }

    // MARK: - Complete Order
    func completeOrder() {
        guard isFormValid else { return }

        guard shopify.checkoutURL != nil else {
            errorMessage = "No items in cart. Please add an item first."
            return
        }
        

        isSubmitting = true
        errorMessage = nil
        isSubmitting = false
        showCheckoutSheet = true
        
    }

    var nextCheckoutDateString: String {
        guard let last = shopify.lastCheckoutDate else { return "" }
        let next = Calendar.current.date(byAdding: .day, value: 7, to: last) ?? last
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: next)
    }
        
}

// MARK: - Section Header
struct SectionHeader: View {
    let title: String
    var body: some View {
        Text(title)
            .font(.title2)
            .fontWeight(.bold)
    }
}

// MARK: - Card Modifier
extension View {
    func checkoutCard() -> some View {
        self
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)
    }
}
