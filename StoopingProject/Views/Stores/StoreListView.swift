//
//  StoreListView.swift
//  StoopingProject
//
//  Created by SebastianHieatt on 6/17/26.
//

import SwiftUI

struct StoreListView: View {
    @EnvironmentObject var shopify: ShopifyService
    @Binding var viewMode: StoreView.ViewMode?

    var body: some View {
        NavigationView {
            Text("List View") // your list content goes here
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
                .navigationTitle("All Items")
        }
    }
}
