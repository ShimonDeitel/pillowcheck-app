import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: Store
    @EnvironmentObject var purchases: PurchaseManager
    @State private var showAddSheet = false
    @State private var showSettings = false
    @State private var showPaywall = false

    @State private var newName = ""
    @State private var newDate = Date()
    @State private var newInterval = 18

    private func age(for item: Item) -> Int {
        Calendar.current.dateComponents([.month], from: item.purchaseDate, to: Date()).month ?? 0
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(store.items) { item in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.name).font(Theme.headlineFont).foregroundStyle(Theme.primary)
                        let months = age(for: item)
                        Text("\(months) months old · replace every \(item.replaceIntervalMonths) months")
                            .font(Theme.captionFont)
                            .foregroundStyle(months >= item.replaceIntervalMonths ? Theme.accent : Theme.secondary)
                    }
                    .listRowBackground(Theme.cardBackground)
                }
                .onDelete(perform: store.delete)
            }
            .scrollContentBackground(.hidden)
            .background(Theme.background.ignoresSafeArea())
            .navigationTitle("Pillowcheck")

            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showSettings = true
                    } label: {
                        Image(systemName: "gearshape")
                    }
                    .accessibilityIdentifier("settingsButton")
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if store.isAtLimit && !purchases.isPro {
                            showPaywall = true
                        } else {
                            showAddSheet = true
                        }
                    } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityIdentifier("addEntryButton")
                }
            }
            .sheet(isPresented: $showSettings) { SettingsView() }
            .sheet(isPresented: $showPaywall) { PaywallView() }

            .sheet(isPresented: $showAddSheet) {
                NavigationStack {
                    Form {
                        TextField("Bedding Item", text: $newName)
                            .accessibilityIdentifier("itemNameField")
                        DatePicker("Purchase Date", selection: $newDate, displayedComponents: .date)
                        Stepper("Replace Every (months): \(newInterval)", value: $newInterval, in: 1...60)
                            .accessibilityIdentifier("intervalStepper")
                    }
                    .navigationTitle("New Item")
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") { showAddSheet = false }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Save") {
                                guard !newName.isEmpty else { return }
                                store.add(Item(name: newName, purchaseDate: newDate, replaceIntervalMonths: newInterval))
                                newName = ""; newDate = Date(); newInterval = 18
                                showAddSheet = false
                            }
                            .accessibilityIdentifier("saveEntryButton")
                        }
                    }
                    .background(
                        Color.clear.contentShape(Rectangle())
                            .onTapGesture { hideKeyboard() }
                    )
                }
            }
        }
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
