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

    private let client = Graph.Client(
        shopDomain: "stooping-club-berkeley.myshopify.com",
        apiKey: "efde750d94d72e1a383e34ed9da89005"
    )

    func fetchProducts() {
            let query = Storefront.buildQuery { $0
                .products(first: 10) { $0
                    .edges { $0
                        .node { $0
                            .title()
                            .description()
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

            let task = client.queryGraphWith(query) { [weak self] response, error in
                if let products = response?.products.edges.map({ $0.node }) {
                    DispatchQueue.main.async {
                        self?.products = products
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
