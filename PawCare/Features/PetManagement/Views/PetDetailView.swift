import SwiftUI

struct PetDetailView: View {
    let pet: Pet
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var records = HealthRecordService.shared
    @State private var showingAdd = false

    var body: some View {
        NavigationStack {
            List {
                Section("Health Records") {
                    let petRecords = records.records(for: pet.id).sorted(by: { $0.timestamp > $1.timestamp })
                    if petRecords.isEmpty {
                        Text("No records yet")
                            .foregroundColor(.secondary)
                    } else {
                        ForEach(petRecords) { r in
                            VStack(alignment: .leading, spacing: 6) {
                                Text(r.description).font(.body)
                                HStack {
                                    Text(r.severity.displayName)
                                    Spacer()
                                    Text(r.timestamp.formatted(date: .abbreviated, time: .shortened))
                                }.font(.caption).foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }
            .navigationTitle(pet.name)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAdd = true }) {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showingAdd) { AddHealthRecordView(pet: pet) }
        }
    }
}

struct AddHealthRecordView: View {
    let pet: Pet
    @Environment(\.dismiss) private var dismiss
    @State private var description = ""
    @State private var severity: HealthRecord.Severity = .mild
    @State private var illnessId: String = ""

    var body: some View {
        NavigationStack {
            Form {
                TextField("Description", text: $description)
                Picker("Severity", selection: $severity) {
                    ForEach(HealthRecord.Severity.allCases, id: \.self) { Text($0.displayName).tag($0) }
                }
                TextField("Illness ID (optional)", text: $illnessId)
            }
            .navigationTitle("Add Record")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let record = HealthRecord(petId: pet.id, illnessId: illnessId, description: description, attachments: [], severity: severity, notes: nil)
                        HealthRecordService.shared.add(record)
                        dismiss()
                    }.disabled(description.isEmpty)
                }
            }
        }
    }
}
