//
//  StoreCarouselView.swift
//  StoopingProject
//
//  Created by SebastianHieatt on 6/17/26.
//

import SwiftUI

struct StoreCarouselView: View {
    @EnvironmentObject var shopify: ShopifyService

    var body: some View {
            Text("Carousel View") // your carousel content
                .toolbar {
                }
                .navigationTitle("Browse Items")
        }
    }

