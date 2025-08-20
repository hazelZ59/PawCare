    import SwiftUI

    struct IllnessListView: View {
        @StateObject private var vm = IllnessViewModel()
        @State private var showingAdd = false

        var body: some View {
            NavigationStack {
                List {
                    ForEach(vm.illnesses) { ill in
                        VStack(alignment: .leading) {
                            Text(ill.name).font(.headline)
                            Text(ill.category.displayName).foregroundColor(.secondary)
                        }
                    }
                }
                .navigationTitle("Illnesses")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: { showingAdd = true }) {
                            Image(systemName: "plus")
                        }
                    }
                }
                .sheet(isPresented: $showingAdd) {
                    AddIllnessView { name, desc, category in
                        vm.addCustom(name: name, description: desc, category: category)
                    }
                }
                .onAppear { vm.load() }
            }
        }
    }

    struct AddIllnessView: View {
        var onSave: (String, String, Illness.IllnessCategory) -> Void
        @Environment(\.dismiss) private var dismiss
        @State private var name = ""
        @State private var desc = ""
        @State private var category: Illness.IllnessCategory = .other

        var body: some View {
            NavigationStack {
                Form {
                    TextField("Name", text: $name)
                    TextField("Description", text: $desc)
                    Picker("Category", selection: $category) {
                        ForEach(Illness.IllnessCategory.allCases, id: \.self) { Text($0.displayName).tag($0) }
                    }
                }
                .navigationTitle("Add Illness")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) { Button("Cancel") { dismiss() } }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Save") {
                            guard !name.isEmpty, !desc.isEmpty else { return }
                            onSave(name, desc, category)
                            dismiss()
                        }
                    }
                }
            }
        }
    }
