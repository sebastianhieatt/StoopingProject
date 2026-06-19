//
//  ShopifyService.swift
//  StoopingProject
//
//  Created by SebastianHieatt on 6/17/26.
//

import Buy
import Combine
import Foundation

class ShopifyService: ObservableObject {
    @Published var products: [Storefront.Product] = []
    @Published var cart: Storefront.Cart?
    @Published var checkoutURL: URL?
    @Published var collections: [Storefront.Collection] = []
    @Published var isLoadingMore = false
    @Published var collectionProducts: [Storefront.Product] = []
    @Published var isLoadingCollection = false
    var collectionLastCursor: String? = nil
    var collectionHasNextPage = true
    var currentCollectionID: GraphQL.ID? = nil
    var lastCursor: String? = nil
    var hasNextPage = true
    
    init() {
        loadSavedState()
    }
    
    private let client = Graph.Client(
        shopDomain: "stooping-club-berkeley.myshopify.com",
        apiKey: "efde750d94d72e1a383e34ed9da89005"
    )
    // MARK: - Cart & Checkout Limits
    
    @Published var cartItems: [GraphQL.ID] = [] {
        didSet {
            // Save cart to UserDefaults whenever it changes
            let stringIDs = cartItems.map { $0.rawValue }
            UserDefaults.standard.set(stringIDs, forKey: "cartItems")
        }
    }

    @Published var lastCheckoutDate: Date? {
        didSet {
            UserDefaults.standard.set(lastCheckoutDate, forKey: "lastCheckoutDate")
        }
    }

    var cartIsFull: Bool { cartItems.count >= 10 }

    var canCheckoutThisWeek: Bool {
        guard let lastDate = lastCheckoutDate else { return true }
        let daysSinceLastCheckout = Calendar.current.dateComponents([.day], from: lastDate, to: Date()).day ?? 0
        return daysSinceLastCheckout >= 7
    }

    var cartCount: Int { cartItems.count }

    // Call this in init() to restore saved state
    func loadSavedState() {
        if let savedIDs = UserDefaults.standard.array(forKey: "cartItems") as? [String] {
            cartItems = savedIDs.map { GraphQL.ID(rawValue: $0) }
        }
        lastCheckoutDate = UserDefaults.standard.object(forKey: "lastCheckoutDate") as? Date
    }

    func addToCart(variantID: GraphQL.ID) -> Bool {
        guard !cartIsFull else { return false }
        guard !cartItems.contains(variantID) else { return false } // no duplicates
        cartItems.append(variantID)
        addToCartAndCheckout(variantID: variantID)
        return true
    }

    func recordCheckout() {
        lastCheckoutDate = Date()
        cartItems = [] // clear cart after checkout
    }
    
    func fetchProductsForCollection(_ collection: Storefront.Collection) {
        // Reset if switching collections
        if collection.id != currentCollectionID {
                collectionProducts = []
                collectionLastCursor = nil
                collectionHasNextPage = true
                currentCollectionID = collection.id
                print("🔄 Switched to collection: \(collection.title)")
            }
            
            guard !isLoadingCollection && collectionHasNextPage else {
                print("⏭️ Skipping fetch — isLoading: \(isLoadingCollection), hasNext: \(collectionHasNextPage)")
                return
            }
            
            print("📦 Fetching collection products, cursor: \(collectionLastCursor ?? "none")")
            isLoadingCollection = true

        let after: String? = collectionLastCursor
        print("COLLECTION ID:  \(collection.id)")
        let query = Storefront.buildQuery { $0
            .collection(id: collection.id) { $0
                .products(first: 50, after: after) { $0
                    .pageInfo { $0
                        .hasNextPage()
                        .endCursor()
                    }
                    .edges { $0
                        .node { $0
                            .id()
                            .title()
                            .productType()
                            .description()
                            .tags()
                            .images(first: 5) { $0
                                .edges { $0
                                    .node { $0
                                        .url()
                                    }
                                }
                            }
                            .variants(first: 1) { $0
                                .edges { $0
                                    .node { $0
                                        .price { $0.amount().currencyCode() }
                                        .id()
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
        }

        let task = client.queryGraphWith(query) { [weak self] response, error in
                guard let self = self else { return }
                if let error = error {
                    print("❌ Collection fetch error: \(error)")
                }
                if let productsData = response?.collection?.products {
                    let newProducts = productsData.edges.map { $0.node }
                    print("✅ Got \(newProducts.count) products, hasNextPage: \(productsData.pageInfo.hasNextPage)")
                    if let productsData = response?.collection?.products {
                        let newProducts = productsData.edges.map { $0.node }
                        newProducts.forEach { product in
                            print("🏷️ \(product.title)")
                        }
                    }
                    newProducts.forEach { product in
                        print("🏷️ \(product.title)")
                        print("   📝 Description: \(product.description)")
                        print("   🔖 Tags: \(product.tags)")
                        print("   💰 Price: \(product.variants.edges.first?.node.price.amount ?? 0)")
                    }
                    DispatchQueue.main.async {
                        self.collectionProducts.append(contentsOf: newProducts)
                        self.collectionHasNextPage = productsData.pageInfo.hasNextPage
                        self.collectionLastCursor = productsData.pageInfo.endCursor
                        self.isLoadingCollection = false
                    }
                } else {
                    print("⚠️ No products data in response")
                    DispatchQueue.main.async { self.isLoadingCollection = false }
                }
            }
        task.resume()
    }
    
    func fetchCollections() {
        let query = Storefront.buildQuery { $0
            .collections(first: 50) { $0
                .edges { $0
                    .node { $0
                        .id()
                        .title()
                        .products(first: 250) { $0
                            .edges { $0
                                .node { $0
                                    .id()
                                    .title()
                                    .productType()
                                    .description()
                                    .images(first: 5) { $0
                                        .edges { $0
                                            .node { $0
                                                .url()
                                            }
                                        }
                                    }
                                    .variants(first: 1) { $0
                                        .edges { $0
                                            .node { $0
                                                .price { $0.amount().currencyCode() }
                                                .id()
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
                let task = client.queryGraphWith(query) { [weak self] response, error in
            if let error = error {
                print("❌ Collections error: \(error)")
            }
            if let collections = response?.collections.edges.map({ $0.node }) {
                print("✅ Collections fetched: \(collections.count)")
                collections.forEach { print("  - \($0.title)") }
                DispatchQueue.main.async {
                    self?.collections = collections
                }
            }
        }
        task.resume()
    }
    func fetchNextPage() {
        guard !isLoadingMore && hasNextPage else { return }
        isLoadingMore = true
        
        let after: String? = lastCursor

        let query = Storefront.buildQuery { $0
                .products(first: 250, after: after) { $0
                    .pageInfo { $0
                        .hasNextPage()
                        .endCursor()
                    }
                .edges { $0
                    .node { $0
                        .id()
                        .title()
                        .productType()
                        .description()
                        .images(first: 5) { $0
                            .edges { $0
                                .node { $0
                                    .url()
                                }
                            }
                        }
                        .variants(first: 1) { $0
                            .edges { $0
                                .node { $0
                                    .id()
                                }
                            }
                        }
                    }
                }
            }
        }

        let task = client.queryGraphWith(query) { [weak self] response, error in
            guard let self = self else { return }

            if let error = error {
                print("❌ Fetch error: \(error)")
                DispatchQueue.main.async { self.isLoadingMore = false }
                return
            }

            if let productsData = response?.products {
                let newProducts = productsData.edges.map { $0.node }
                DispatchQueue.main.async {
                    self.products.append(contentsOf: newProducts)
                    self.hasNextPage = productsData.pageInfo.hasNextPage
                    self.lastCursor = productsData.pageInfo.endCursor
                    self.isLoadingMore = false
                    print("✅ Loaded \(self.products.count) products so far")
                }
            }
        }
        task.resume()
    }
    func addToCartAndCheckout(variantID: GraphQL.ID) {
        let lineItem = Storefront.CartLineInput.create(merchandiseId: variantID)
        
        let cartInput = Storefront.CartInput.create(
            lines: .value([lineItem])
        )
        
        let mutation = Storefront.buildMutation { $0
            .cartCreate(input: cartInput) { $0
                .cart { $0
                    .checkoutUrl()
                    .id()
                }
            }
        }

        let task = client.mutateGraphWith(mutation) { [weak self] response, error in
            if let url = response?.cartCreate?.cart?.checkoutUrl {
                DispatchQueue.main.async {
                    self?.checkoutURL = url
                }
            }
        }
        task.resume()
    }
}
