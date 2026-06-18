//
//  CheckoutPageView.swift
//  StoopingProject
//
//  Created by SebastianHieatt on 6/7/26.
//

import SwiftUI
import Buy
import ShopifyCheckoutSheetKit

struct CheckoutPageView: View {
    @EnvironmentObject var shopify: ShopifyService
    
    // Contact
    @State private var email = ""
    
    // Address
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var address = ""
    @State private var city = ""
    @State private var state = ""
    @State private var zip = ""
    @State private var mobile = ""
    
    @State private var isSubmitting = false
    @State private var showCheckoutSheet = false
    @State private var errorMessage: String? = nil

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                // MARK: - Contact
                SectionHeader(title: "Contact")
                VStack(spacing: 0) {
                    CheckoutTextField(placeholder: "Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
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

                // MARK: - Address
                SectionHeader(title: "Address")
                VStack(spacing: 0) {
                    // Country (static)
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Country/Region")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        HStack {
                            Text("United States")
                            Spacer()
                            Image(systemName: "chevron.down")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding()
                    
                    Divider().padding(.leading)

                    // First & Last Name
                    HStack(spacing: 0) {
                        CheckoutTextField(placeholder: "First name", text: $firstName)
                        Divider()
                        CheckoutTextField(placeholder: "Last name", text: $lastName)
                    }

                    Divider().padding(.leading)

                    // Address
                    HStack {
                        CheckoutTextField(placeholder: "Address (campus or nearby address is acceptable)", text: $address)
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .padding(.trailing)
                    }

                    Divider().padding(.leading)

                    // City, State, ZIP
                    HStack(spacing: 0) {
                        CheckoutTextField(placeholder: "City (Berkeley or nearby)", text: $city)
                        Divider()
                        CheckoutTextField(placeholder: "State", text: $state)
                        Divider()
                        CheckoutTextField(placeholder: "ZIP code (local)", text: $zip)
                            .keyboardType(.numberPad)
                    }

                    Divider().padding(.leading)

                    // Mobile
                    HStack {
                        CheckoutTextField(placeholder: "Mobile number (required for pickup coordination)", text: $mobile)
                            .keyboardType(.phonePad)
                        Image(systemName: "questionmark.circle")
                            .foregroundColor(.gray)
                            .padding(.trailing)
                    }
                }
                .checkoutCard()

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
            }
        }
    }

    // MARK: - Validation
    var isFormValid: Bool {
        !email.isEmpty &&
        !firstName.isEmpty &&
        !lastName.isEmpty &&
        !address.isEmpty &&
        !city.isEmpty &&
        !state.isEmpty &&
        !zip.isEmpty &&
        !mobile.isEmpty
    }

    // MARK: - Complete Order
    func completeOrder() {
        guard isFormValid else { return }
        
        // Check weekly limit
        guard shopify.canCheckoutThisWeek else {
            errorMessage = "You can only place one order per week. Please wait until \(nextCheckoutDateString) to order again."
            return
        }

        guard shopify.checkoutURL != nil else {
            errorMessage = "No items in cart. Please add an item first."
            return
        }

        isSubmitting = true
        errorMessage = nil
        isSubmitting = false
        shopify.recordCheckout() // records date and clears cart
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

// MARK: - Checkout Text Field
struct CheckoutTextField: View {
    let placeholder: String
    @Binding var text: String

    var body: some View {
        TextField(placeholder, text: $text)
            .padding()
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
