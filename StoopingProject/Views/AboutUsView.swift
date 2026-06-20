//
//  AboutUsView.swift
//  StoopingProject
//
//  Created by SebastianHieatt on 6/7/26.
//

import Foundation

import SwiftUI

struct AboutUsView: View {

    var body: some View {

        ScrollView {

            VStack(spacing: 30) {

                // Title
                Text("About Us")
                    .font(AppTheme.pageTitle)
                    .padding(.top, 20)

                // Description
                Text("""
                Stooping Club is the world's first free online chain store. We offer new and preloved household items at no cost to promote sustainability and community sharing.
                """)
                .font(.title3)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 700)

                // Vision Card
                InfoCard(
                    title: "Our Vision",
                    description: "To transform society's throwaway culture into a reuse culture and build a circular economy."
                )

                // Mission Card
                InfoCard(
                    title: "Our Mission",
                    description: "To give useful items a second life by making reuse free and accessible for everyone."
                )

                Spacer(minLength: 40)
            }
            .padding(.horizontal, 24)
        }
        .background(
            Color(.systemGray6)
                .ignoresSafeArea()
        )
    }
}

struct InfoCard: View {

    let title: String
    let description: String

    var body: some View {

        VStack(alignment: .leading, spacing: 40) {

            Text(title)
                .font(.system(size: 28, weight: .medium))

            Text(description)
                .font(.title3)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(30)
        .background(AppTheme.cardBackground)
        .cornerRadius(20)
    }
}

#Preview {
    AboutUsView()
}
