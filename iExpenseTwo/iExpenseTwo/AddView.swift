//
//  AddView.swift
//  iExpenseTwo
//
//  Created by Preju Kanuparthy on 1/9/24.
//

import SwiftUI

struct AddView: View {
    @Environment(\.dismiss) var dismiss
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = 0.0
    @State private var selectedCurrencyIndex = 0
    
let currencies = [ "USD", "EUR", "AUD", "GBP", "NZD"]
    
    var expenses: Expenses
    
    let types = ["Business", "Personal"]
    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)
                
                Picker("Type", selection: $type) {
                    ForEach(types, id: \.self) {
                        Text($0)
                    }
                }
                
                TextField("Amount", value: $amount, formatter: currencyFormatter())
                    .keyboardType(.decimalPad)
                
                Picker("Currency", selection: $selectedCurrencyIndex) {
                    ForEach(0..<currencies.count) { index in
                        Text(self.currencies[index])
                    }
                }
                .pickerStyle(.segmented)
                
                
            }
            .navigationTitle("Add new expense")
            .toolbar {
                Button("Save") {
                    let item = ExpenseItem(name: name, type: type, amount: amount)
                    expenses.items.append(item)
                    dismiss()
                }
            }
        }
        
        }
        
    func currencyFormatter() -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currencies[selectedCurrencyIndex]
        return formatter
    }
}

#Preview {
    AddView(expenses: Expenses())
}

