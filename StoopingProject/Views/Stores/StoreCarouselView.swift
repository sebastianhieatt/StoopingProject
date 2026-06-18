//
//  StoreCarouselView.swift
//  StoopingProject
//
//  Created by SebastianHieatt on 6/17/26.
//

import SwiftUI

struct StoreCarouselView: View {
    @EnvironmentObject var shopify: ShopifyService
    @Binding var viewMode: StoreView.ViewMode?

    var body: some View {
        NavigationView {
            Text("Carousel View") // your carousel content goes here
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: { viewMode = .list }) {
                            Image(systemName: "list.bullet")
                        }
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: { viewMode = nil }) {
                            Image(systemName: "chevron.left")
                        }
                    }
                }
                .navigationTitle("Browse Items")
        }
    }
}
