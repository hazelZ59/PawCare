import SwiftUI

struct RecordsListView: View {
    @ObservedObject private var records = HealthRecordService.shared
    @StateObject private var petVM = PetViewModel()
    @State private var showingAdd = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(records.records.sorted(by: { $0.timestamp > $1.timestamp })) { r in
                    RecordCard(record: r, pet: petVM.pets.first(where: { $0.id == r.petId }))
                }
            }
            .navigationTitle("Records")
            .toolbar { ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showingAdd = true }) {
                    Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAdd) { AddRecordView() }
            .onAppear { petVM.loadPets() }
        }
    }
}

struct RecordCard: View {
    let record: HealthRecord
    let pet: Pet?
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(pet?.name ?? "Unknown Pet").font(.headline)
                Spacer()
                Text(record.timestamp.formatted(date: .abbreviated, time: .shortened)).foregroundColor(.secondary)
            }
            Text(record.description)
            HStack { Text(record.severity.displayName).font(.caption).foregroundColor(.secondary); Spacer() }
        }
        .padding(.vertical, 6)
    }
}

struct AddRecordView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var records = HealthRecordService.shared
    @StateObject private var petVM = PetViewModel()
    @State private var description = ""
    @State private var severity: HealthRecord.Severity = .mild
    @State private var selectedPetId: String = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Pet") {
                    Picker("Select Pet", selection: $selectedPetId) {
                        ForEach(petVM.pets) { p in Text(p.name).tag(p.id) }
                    }
                }
                Section("Details") {
                    TextField("Description", text: $description)
                    Picker("Severity", selection: $severity) { ForEach(HealthRecord.Severity.allCases, id: \.self) { Text($0.displayName).tag($0) } }
                }
            }
            .navigationTitle("Add Record")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let record = HealthRecord(petId: selectedPetId, illnessId: "", description: description, attachments: [], severity: severity, notes: nil)
                        records.add(record)
                        dismiss()
                    }.disabled(description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || selectedPetId.isEmpty)
                }
            }
            .onAppear {
                petVM.loadPets()
                if selectedPetId.isEmpty, let only = petVM.pets.only { selectedPetId = only.id }
            }
        }
    }
}

extension Array {
    var only: Element? { count == 1 ? first : nil }
}
