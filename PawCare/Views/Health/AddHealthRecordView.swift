import SwiftUI
import PhotosUI

struct AddHealthRecordView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dataService: DataService
    
    let cat: Cat
    
    @State private var title = ""
    @State private var recordType = HealthRecord.RecordType.vaccination
    @State private var date = Date()
    @State private var veterinarian = ""
    @State private var notes = ""
    @State private var validUntil: Date? = nil
    @State private var selectedPhotosItems: [PhotosPickerItem] = []
    @State private var selectedPhotosData: [Data] = []
    @State private var documentName = ""
    @State private var isLoading = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Record Type", selection: $recordType) {
                        ForEach(HealthRecord.RecordType.allCases) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .onChange(of: recordType) { newValue in
                        // Reset valid until date if not a vaccination
                        if newValue != .vaccination {
                            validUntil = nil
                        }
                    }
                }
                
                Section(header: Text("Record Details")) {
                    TextField("Title", text: $title)
                    
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                    
                    TextField("Veterinarian", text: $veterinarian)
                    
                    if recordType == .vaccination {
                        DatePicker("Valid Until", selection: Binding(
                            get: { validUntil ?? Calendar.current.date(byAdding: .year, value: 1, to: date)! },
                            set: { validUntil = $0 }
                        ), displayedComponents: .date)
                    }
                }
                
                Section(header: Text("Notes")) {
                    TextEditor(text: $notes)
                        .frame(minHeight: 100)
                }
                
                Section(header: Text("Attachments")) {
                    // Photos picker
                    PhotosPicker(
                        selection: $selectedPhotosItems,
                        matching: .images,
                        photoLibrary: .shared()) {
                            Label("Add Photos", systemImage: "photo")
                        }
                        .onChange(of: selectedPhotosItems) { newItems in
                            Task {
                                selectedPhotosData.removeAll()
                                
                                for item in newItems {
                                    if let data = try? await item.loadTransferable(type: Data.self) {
                                        selectedPhotosData.append(data)
                                    }
                                }
                            }
                        }
                    
                    // Document upload placeholder (in a real app, you would use UIDocumentPickerViewController)
                    Button {
                        // Document picker would go here
                    } label: {
                        Label("Add Document", systemImage: "doc")
                    }
                    
                    // Preview selected photos
                    if !selectedPhotosData.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(selectedPhotosData.indices, id: \.self) { index in
                                    if let uiImage = UIImage(data: selectedPhotosData[index]) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 80, height: 80)
                                            .clipShape(RoundedRectangle(cornerRadius: 8))
                                            .overlay(
                                                Button {
                                                    selectedPhotosData.remove(at: index)
                                                    selectedPhotosItems.remove(at: index)
                                                } label: {
                                                    Image(systemName: "xmark.circle.fill")
                                                        .foregroundColor(.white)
                                                        .background(Circle().fill(Color.black.opacity(0.7)))
                                                }
                                                .padding(4),
                                                alignment: .topTrailing
                                            )
                                    }
                                }
                            }
                            .padding(.vertical, 8)
                        }
                    }
                }
            }
            .navigationTitle("Add Health Record")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveHealthRecord()
                    }
                    .disabled(title.isEmpty || isLoading)
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
    
    private func saveHealthRecord() {
        guard !title.isEmpty else {
            errorMessage = "Please enter a title for the health record"
            showError = true
            return
        }
        
        isLoading = true
        
        // In a real app, you would upload images to a server and get URLs back
        // For now, we'll create attachments with placeholder URLs
        var attachments: [HealthRecord.Attachment] = []
        
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // Create mock attachments for demo purposes
            for (index, _) in selectedPhotosData.enumerated() {
                let attachment = HealthRecord.Attachment(
                    id: UUID().uuidString,
                    name: "photo_\(index + 1).jpg",
                    type: .image,
                    url: URL(string: "https://example.com/photo_\(index + 1).jpg")!,
                    size: nil
                )
                attachments.append(attachment)
            }
            
            let newRecord = HealthRecord(
                id: UUID().uuidString,
                catId: cat.id,
                title: title,
                date: date,
                type: recordType,
                veterinarian: veterinarian.isEmpty ? nil : veterinarian,
                notes: notes.isEmpty ? nil : notes,
                attachments: attachments,
                validUntil: recordType == .vaccination ? validUntil : nil
            )
            
            dataService.addHealthRecord(newRecord)
            isLoading = false
            dismiss()
        }
    }
}

struct AddHealthRecordView_Previews: PreviewProvider {
    static var previews: some View {
        AddHealthRecordView(cat: Cat.sample)
            .environmentObject(DataService())
    }
}
