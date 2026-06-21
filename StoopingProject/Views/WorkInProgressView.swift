import SwiftUI

struct WorkInProgressView: View {
    let title: String

    var body: some View {
        ScrollView {

            VStack(spacing: 24) {

                // MARK: - RULES + HOW IT WORKS
                if title == "How it Works" {

                    VStack(spacing: 24) {


                        // MARK: - HOW IT WORKS
                        VStack(alignment: .leading, spacing: 12) {

                            Text("Process")
                                .font(.title3)
                                .fontWeight(.bold)

                            StepRow(
                                number: "1",
                                title: "Browse",
                                text: "Customers shop on the app. Everything is free!"
                            )

                            StepRow(
                                number: "2",
                                title: "Order",
                                text: "Place an order."
                            )

                            StepRow(
                                number: "3",
                                title: "Confirm",
                                text: "Reply to confirmation by Friday end of day or the order is relisted."
                            )

                            StepRow(
                                number: "4",
                                title: "Pick Up",
                                text: "Every Sunday 2–3 PM in El Cerrito. Local pickup only."
                            )
                        }

                        // MARK: - RULES
                        VStack(alignment: .leading, spacing: 12) {

                            Text("Rules")
                                .font(.title3)
                                .fontWeight(.bold)

                            RuleRow(number: "1", text: "10 items per checkout")
                            RuleRow(number: "2", text: "1 checkout per week")
                            RuleRow(number: "3", text: "Everything is free")
                            RuleRow(number: "4", text: "No reselling")
                            RuleRow(number: "5", text: "Repeated no shows results in a 30 day ban")
                        }
                    }
                    .frame(maxWidth: .infinity)

                }

                // MARK: - ABOUT US
                else if title == "About Us" {

                    VStack(alignment: .leading, spacing: 16) {

                        Text("Stooping Club is the world's first free online chain store. We offer new and preloved household items at no cost to promote sustainability and community sharing.")

                        VStack(alignment: .leading, spacing: 6) {
                            Text("Our Vision")
                                .font(.headline)

                            Text("To transform society's throwaway culture into a reuse culture and build a circular economy.")
                        }

                        VStack(alignment: .leading, spacing: 6) {
                            Text("Our Mission")
                                .font(.headline)

                            Text("To give useful items a second life by making reuse free and accessible for everyone.")
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                }

                // MARK: - DEFAULT
                else {

                    VStack {
                        Spacer()
                        Text("Work in Progress 🚧")
                            .font(.title2)
                            .foregroundColor(.gray)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding()
        }
        .navigationTitle(title)
    }
}

// MARK: - STEP ROW
struct StepRow: View {
    let number: String
    let title: String
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {

            Text(number)
                .font(.headline)
                .fontWeight(.bold)
                .frame(width: 34, height: 34)
                .background(Color.blue.opacity(0.15))
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 4) {

                Text(title)
                    .font(.headline)

                Text(text)
                    .font(.body)
                    .foregroundColor(.secondary)
            }

            Spacer(minLength: 0)
        }
        .padding()
        .background(AppTheme.cardBackground)
        .cornerRadius(12)
    }
}

// MARK: - RULE ROW
struct RuleRow: View {
    let number: String
    let text: String

    var body: some View {
        HStack(alignment: .center, spacing: 12) {

            Text(number)
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(.green)
                .frame(width: 34, height: 34)
                .background(Color.green.opacity(0.15))
                .clipShape(Circle())

            Text(text)
                .font(.body)
                .foregroundColor(.primary)

            Spacer(minLength: 0)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 12)
        .background(AppTheme.cardBackground)
        .cornerRadius(12)
    }
}
