//
//  ContentView.swift
//  iExpenseTwo
//
//  Created by Preju Kanuparthy on 1/8/24.
//

import SwiftUI

struct ExpenseItem: Identifiable, Codable {
    var id = UUID ()
    let name: String
    let type: String
    let amount: Double
}

@Observable
class Expenses {
    var items = [ExpenseItem]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
                items = decodedItems
                return
            }
        }
        
        items = []
    }
    
}

class CurrencySelection: ObservableObject {
    @Published var selectedCurrencyIndex = 0
    let currencies = ["USD", "EUR", "GBP", "JPY", "AUD"]
}

struct ContentView: View {
    @State private var expenses = Expenses()
    @State private var showingAddExpense = false
    @ObservedObject var currencySelection = CurrencySelection()
    
    
    enum ExpenseTypeFilter: String, CaseIterable {
            case personal = "Personal"
            case business = "Business"
        }
    
    @State private var selectedExpenseType: ExpenseTypeFilter = .personal
    
    var body: some View {
        NavigationStack{
            VStack {
                            // Segmented control to switch between Personal and Business items
                            Picker("Expense Type", selection: $selectedExpenseType) {
                                ForEach(ExpenseTypeFilter.allCases, id: \.self) { type in
                                    Text(type.rawValue)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .padding()
                            
            
            List {
                ForEach(expenses.items) { item in
                    HStack{
                        VStack(alignment: .leading){
                            Text(item.name)
                                .font(.headline)
                            
                            Text(item.type)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                    
                        
                        Text(item.amount, format: .currency(code: currencySelection.currencies[currencySelection.selectedCurrencyIndex]))
                    }
                }
                .onDelete(perform: removeItems)
            }
            .navigationTitle("iExpense")
            .toolbar {
                Button("Add Expense", systemImage: "plus") {
                    showingAddExpense = true
                }
                
            }
            }
            .sheet(isPresented: $showingAddExpense) {
                AddView(expenses: expenses)
            }
            
            
             var filteredItems: [ExpenseItem] {
                   switch selectedExpenseType {
                   case .personal:
                       return expenses.items.filter { $0.type == ExpenseTypeFilter.personal.rawValue }
                   case .business:
                       return expenses.items.filter { $0.type == ExpenseTypeFilter.business.rawValue }
            
            
            
            
            
            
            
            
            
            
        }
        
    }
    
   func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
}

#Preview {
    ContentView()
}
