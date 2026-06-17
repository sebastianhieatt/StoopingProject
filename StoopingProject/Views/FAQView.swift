import SwiftUI

struct FAQView: View {

    @State private var expandedIndex: Int? = nil

    var body: some View {
        ScrollView {

            VStack(spacing: 16) {

                Text("Frequently Asked Questions")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.top)

                FAQItem(
                    index: 0,
                    expandedIndex: $expandedIndex,
                    question: "What is stooping?",
                    answer: "Stooping is the practice of sourcing and reusing usable items that would otherwise go to waste. At Stooping Club, all items are free and available for local pickup in Berkeley."
                )

                FAQItem(
                    index: 1,
                    expandedIndex: $expandedIndex,
                    question: "Are the items really free?",
                    answer: "Yes! All items listed are completely free. There are no prices, fees, or purchases on our platform."
                )

                FAQItem(
                    index: 2,
                    expandedIndex: $expandedIndex,
                    question: "Where do items come from?",
                    answer: "Items come from high-quality curbside finds and community donations. Donors include individuals and organizations who are decluttering or moving."
                )

                FAQItem(
                    index: 3,
                    expandedIndex: $expandedIndex,
                    question: "Do you ship orders?",
                    answer: "No. We operate on a local pickup–only basis. All items must be picked up in person in the Berkeley area."
                )

                FAQItem(
                    index: 4,
                    expandedIndex: $expandedIndex,
                    question: "How does pickup work?",
                    answer: "Once you order an item, you'll receive pickup details via text or email. Orders are held for up to three days before being relisted."
                )

                FAQItem(
                    index: 5,
                    expandedIndex: $expandedIndex,
                    question: "Is everything first come, first served?",
                    answer: "Yes. Items are reserved only after checkout is completed."
                )

                FAQItem(
                    index: 6,
                    expandedIndex: $expandedIndex,
                    question: "Is there a limit to how many items I can order?",
                    answer: "There's no strict limit, but we encourage fairness so everyone can benefit."
                )

                FAQItem(
                    index: 7,
                    expandedIndex: $expandedIndex,
                    question: "Can I resell items from Stooping Club?",
                    answer: "No. Items are for personal use or gifting only and may not be resold."
                )

                FAQItem(
                    index: 8,
                    expandedIndex: $expandedIndex,
                    question: "Do you accept returns?",
                    answer: "All orders are final since items are free. Contact us if there is an issue."
                )

                FAQItem(
                    index: 9,
                    expandedIndex: $expandedIndex,
                    question: "What if an item is no longer available?",
                    answer: "Items are removed once ordered. Availability is not guaranteed until checkout is complete."
                )

                FAQItem(
                    index: 10,
                    expandedIndex: $expandedIndex,
                    question: "What condition are the items in?",
                    answer: "Items are pre-owned or open-box and checked for usability before listing."
                )

                FAQItem(
                    index: 11,
                    expandedIndex: $expandedIndex,
                    question: "How often do you add new inventory?",
                    answer: "We add new inventory weekly."
                )

                FAQItem(
                    index: 12,
                    expandedIndex: $expandedIndex,
                    question: "Can I donate items?",
                    answer: "Yes! We accept gently used household items depending on condition."
                )

                FAQItem(
                    index: 13,
                    expandedIndex: $expandedIndex,
                    question: "Do you accept large items like furniture?",
                    answer: "We may list large items and coordinate pickup directly with donors."
                )

                Spacer(minLength: 20)
            }
            .padding()
        }
        .navigationTitle("FAQ")
    }
}

//
// MARK: - SINGLE OPEN FAQ ITEM
//
struct FAQItem: View {

    let index: Int
    @Binding var expandedIndex: Int?

    let question: String
    let answer: String

    var isExpanded: Bool {
        expandedIndex == index
    }

    var body: some View {

        VStack(spacing: 10) {

            Button(action: {
                withAnimation {
                    if isExpanded {
                        expandedIndex = nil
                    } else {
                        expandedIndex = index
                    }
                }
            }) {

                HStack {

                    Text(question)
                        .font(.headline)
                        .foregroundColor(.primary)

                    Spacer()

                    Image(systemName: isExpanded ? "minus" : "plus")
                        .foregroundColor(.gray)
                }
            }

            if isExpanded {
                Text(answer)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .transition(.opacity)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.08))
        .cornerRadius(12)
    }
}
