import SwiftUI

struct HealthRecordDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var dataService: DataService
    
    let record: HealthRecord
    @State private var isEditing = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header with icon and title
                    HStack(spacing: 16) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(record.type.color)
                                .frame(width: 60, height: 60)
                            
                            Image(systemName: record.type.icon)
                                .font(.system(size: 28))
                                .foregroundColor(.white)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(record.title)
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Text(formatDate(record.date))
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    Divider()
                        .padding(.horizontal)
                    
                    // Record details
                    VStack(alignment: .leading, spacing: 16) {
                        // Veterinarian
                        if let veterinarian = record.veterinarian {
                            DetailRow(icon: "person.crop.circle.fill", title: "Veterinarian", value: veterinarian)
                        }
                        
                        // Reminder date
                        if let reminderDate = record.reminderDate {
                            DetailRow(icon: "calendar.badge.clock", title: "Reminder Date", value: formatDate(reminderDate))
                        }
                        
                        // Notes
                        if let notes = record.notes, !notes.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Notes")
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                                
                                Text(notes)
                                    .font(.body)
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                            }
                            .padding(.horizontal)
                        }
                        
                        // Attachments
                        if !record.attachments.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Attachments")
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                                    .padding(.horizontal)
                                
                                // Images
                                let imageAttachments = record.attachments.filter { $0.type == .image }
                                if !imageAttachments.isEmpty {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Images")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                            .padding(.horizontal)
                                        
                                        ScrollView(.horizontal, showsIndicators: false) {
                                            HStack(spacing: 12) {
                                                ForEach(imageAttachments) { attachment in
                                                    AsyncImage(url: attachment.url) { phase in
                                                        if let image = phase.image {
                                                            image
                                                                .resizable()
                                                                .scaledToFill()
                                                        } else if phase.error != nil {
                                                            Image(systemName: "photo")
                                                                .font(.system(size: 30))
                                                                .foregroundColor(.secondary)
                                                        } else {
                                                            ProgressView()
                                                        }
                                                    }
                                                    .frame(width: 120, height: 120)
                                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                                }
                                            }
                                            .padding(.horizontal)
                                        }
                                    }
                                }
                                
                                // Documents
                                let docAttachments = record.attachments.filter { $0.type != .image }
                                if !docAttachments.isEmpty {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Documents")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                            .padding(.horizontal)
                                        
                                        ForEach(docAttachments) { attachment in
                                            HStack {
                                                ZStack {
                                                    RoundedRectangle(cornerRadius: 8)
                                                        .fill(Color.blue)
                                                        .frame(width: 40, height: 40)
                                                    
                                                    Image(systemName: attachment.type.icon)
                                                        .font(.system(size: 20))
                                                        .foregroundColor(.white)
                                                }
                                                
                                                VStack(alignment: .leading, spacing: 2) {
                                                    Text(attachment.name)
                                                        .font(.body)
                                                        .fontWeight(.medium)
                                                    
                                                    if let size = attachment.size {
                                                        Text(formatFileSize(size))
                                                            .font(.caption)
                                                            .foregroundColor(.secondary)
                                                    }
                                                }
                                                
                                                Spacer()
                                                
                                                Button(action: {
                                                    // Open document
                                                }) {
                                                    Image(systemName: "arrow.down.circle")
                                                        .font(.title2)
                                                        .foregroundColor(.blue)
                                                }
                                            }
                                            .padding()
                                            .background(Color(.systemGray6))
                                            .cornerRadius(12)
                                            .padding(.horizontal)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Record Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.primary)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(action: {
                            isEditing = true
                        }) {
                            Label("Edit", systemImage: "pencil")
                        }
                        
                        Button(role: .destructive, action: {
                            // Delete record
                            dataService.deleteHealthRecord(id: record.id)
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Label("Delete", systemImage: "trash")
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundColor(.primary)
                    }
                }
            }
            .sheet(isPresented: $isEditing) {
                // This would be the edit record view
                Text("Edit Record")
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    private func formatFileSize(_ size: Int) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useKB, .useMB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: Int64(size))
    }
}

struct DetailRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(.blue)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text(value)
                    .font(.body)
            }
            
            Spacer()
        }
        .padding(.horizontal)
    }
}

struct HealthRecordDetailView_Previews: PreviewProvider {
    static var previews: some View {
        HealthRecordDetailView(record: HealthRecord.samples[0])
            .environmentObject(DataService())
    }
}

