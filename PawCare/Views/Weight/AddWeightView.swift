import SwiftUI

struct AddWeightView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dataService: DataService
    
    let cat: Cat
    
    @State private var weight = 5.0
    @State private var date = Date()
    @State private var notes = ""
    @State private var isLoading = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    private let minWeight = 0.5
    private let maxWeight = 15.0
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Weight Information")) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Weight (kg)")
                            .font(.headline)
                        
                        HStack {
                            Text(String(format: "%.1f", weight))
                                .font(.system(size: 36, weight: .bold))
                                .frame(width: 100, alignment: .leading)
                            
                            Spacer()
                            
                            HStack(spacing: 16) {
                                Button(action: {
                                    if weight > minWeight {
                                        weight -= 0.1
                                    }
                                }) {
                                    Image(systemName: "minus.circle.fill")
                                        .font(.title)
                                        .foregroundColor(.blue)
                                }
                                
                                Button(action: {
                                    if weight < maxWeight {
                                        weight += 0.1
                                    }
                                }) {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.title)
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                        
                        Slider(
                            value: $weight,
                            in: minWeight...maxWeight,
                            step: 0.1
                        )
                        .accentColor(.blue)
                        
                        HStack {
                            Text("\(String(format: "%.1f", minWeight)) kg")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                            Text("\(String(format: "%.1f", maxWeight)) kg")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 8)
                    
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                }
                
                Section(header: Text("Notes (Optional)")) {
                    TextEditor(text: $notes)
                        .frame(minHeight: 100)
                }
            }
            .navigationTitle("Add Weight Record")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveWeightRecord()
                    }
                    .disabled(isLoading)
                }
            }
            .overlay {
                if isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.black.opacity(0.2))
                }
            }
            .alert("Error", isPresented: $showError) {
                Button("OK") { }
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    private func saveWeightRecord() {
        guard weight >= minWeight && weight <= maxWeight else {
            errorMessage = "Weight must be between \(minWeight) and \(maxWeight) kg"
            showError = true
            return
        }
        
        isLoading = true
        
        let newRecord = WeightRecord(
            id: UUID().uuidString,
            catId: cat.id,
            weight: weight,
            date: date,
            notes: notes.isEmpty ? nil : notes
        )
        
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            dataService.addWeightRecord(newRecord)
            isLoading = false
            dismiss()
        }
    }
}

struct AddWeightView_Previews: PreviewProvider {
    static var previews: some View {
        AddWeightView(cat: Cat.sample)
            .environmentObject(DataService())
    }
}
