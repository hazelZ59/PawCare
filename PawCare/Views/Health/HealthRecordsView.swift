import SwiftUI
import Charts

struct HealthRecordsView: View {
    @EnvironmentObject var dataService: DataService
    @State private var selectedCat: Cat?
    @State private var selectedTab: HealthRecord.RecordType?
    @State private var searchText = ""
    @State private var isShowingFilters = false
    @State private var isShowingAddRecord = false
    @State private var isShowingEmptyState = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Cat selector (if multiple cats)
                if dataService.cats.count > 1 {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(dataService.cats) { cat in
                                CatAvatarView(cat: cat, isSelected: selectedCat?.id == cat.id)
                                    .onTapGesture {
                                        selectedCat = cat
                                    }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical, 8)
                    .background(Color.white)
                }
                
                // Tab bar for filtering by record type
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 0) {
                        TabButton(title: "All", isSelected: selectedTab == nil) {
                            selectedTab = nil
                        }
                        
                        ForEach(HealthRecord.RecordType.allCases) { type in
                            TabButton(title: type.rawValue, isSelected: selectedTab == type) {
                                selectedTab = type
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 8)
                .background(Color.white)
                
                if filteredRecords.isEmpty {
                    // Empty state
                    VStack(spacing: 20) {
                        Spacer()
                        
                        Image(systemName: "clipboard")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        
                        Text("No Health Records")
                            .font(.title2)
                            .fontWeight(.medium)
                        
                        Text(selectedTab == nil ? 
                             "Add your cat's health records to keep track of their medical history" :
                                "No \(selectedTab!.rawValue) records found")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                        
                        Button(action: {
                            isShowingAddRecord = true
                        }) {
                            Text("Add Health Record")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .padding(.vertical, 12)
                                .padding(.horizontal, 24)
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        .padding(.top, 10)
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemGray6))
                } else {
                    // Health records list
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(filteredRecords) { record in
                                HealthRecordCard(record: record)
                                    .padding(.horizontal)
                            }
                        }
                        .padding(.vertical)
                    }
                    .background(Color(.systemGray6))
                }
            }
            .navigationTitle("Health Records")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 12) {
                        Button(action: {
                            // Show search
                        }) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.primary)
                        }
                        
                        Button(action: {
                            isShowingFilters.toggle()
                        }) {
                            Image(systemName: "line.3.horizontal.decrease.circle")
                                .foregroundColor(.primary)
                        }
                    }
                }
            }
            .overlay(alignment: .bottomTrailing) {
                Button(action: {
                    isShowingAddRecord = true
                }) {
                    Image(systemName: "plus")
                        .font(.title2)
                        .foregroundColor(.white)
                        .frame(width: 56, height: 56)
                        .background(Color.blue)
                        .clipShape(Circle())
                        .shadow(color: Color.blue.opacity(0.3), radius: 10, x: 0, y: 5)
                }
                .padding(.trailing, 24)
                .padding(.bottom, 100) // Position above tab bar
            }
            .sheet(isPresented: $isShowingAddRecord) {
                if let cat = selectedCat ?? dataService.cats.first {
                    AddHealthRecordView(cat: cat)
                }
            }
        }
        .onAppear {
            // Set the default selected cat if none is selected
            if selectedCat == nil && !dataService.cats.isEmpty {
                selectedCat = dataService.cats.first
            }
        }
    }
    
    private var filteredRecords: [HealthRecord] {
        let catId = selectedCat?.id ?? dataService.cats.first?.id
        
        guard let catId = catId else {
            return []
        }
        
        var records = dataService.healthRecords.filter { $0.catId == catId }
        
        if let selectedTab = selectedTab {
            records = records.filter { $0.type == selectedTab }
        }
        
        if !searchText.isEmpty {
            records = records.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.notes?.localizedCaseInsensitiveContains(searchText) ?? false ||
                $0.veterinarian?.localizedCaseInsensitiveContains(searchText) ?? false
            }
        }
        
        return records.sorted(by: { $0.date > $1.date })
    }
}

struct TabButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
                .foregroundColor(isSelected ? .blue : .secondary)
        }
        .background(
            VStack {
                Spacer()
                if isSelected {
                    Rectangle()
                        .fill(Color.blue)
                        .frame(height: 2)
                }
            }
        )
    }
}

struct HealthRecordCard: View {
    let record: HealthRecord
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(record.type.color)
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: record.type.icon)
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(record.title)
                        .font(.headline)
                    
                    Text(formatDate(record.date) + (record.veterinarian != nil ? " • \(record.veterinarian!)" : ""))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.blue)
            }
            .padding()
            
            if let notes = record.notes, !notes.isEmpty {
                Text(notes)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
                    .padding(.bottom, record.attachments.isEmpty ? 16 : 8)
            }
            
            // Attachments
            if !record.attachments.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    // Images
                    let imageAttachments = record.attachments.filter { $0.type == .image }
                    if !imageAttachments.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(imageAttachments) { attachment in
                                    AsyncImage(url: attachment.url) { phase in
                                        if let image = phase.image {
                                            image
                                                .resizable()
                                                .scaledToFill()
                                        } else if phase.error != nil {
                                            Image(systemName: "photo")
                                                .font(.system(size: 24))
                                                .foregroundColor(.secondary)
                                        } else {
                                            ProgressView()
                                        }
                                    }
                                    .frame(width: 60, height: 60)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    // Files
                    let fileAttachments = record.attachments.filter { $0.type != .image }
                    ForEach(fileAttachments) { attachment in
                        HStack {
                            ZStack {
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color.blue)
                                    .frame(width: 32, height: 32)
                                
                                Image(systemName: attachment.type.icon)
                                    .font(.system(size: 16))
                                    .foregroundColor(.white)
                            }
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(attachment.name)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                
                                if let size = attachment.size {
                                    Text(formatFileSize(size))
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                            
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 4)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .padding(.horizontal)
                    }
                }
                .padding(.bottom, 16)
            }
            
            // Valid until date for vaccinations
            if record.type == .vaccination, let validUntil = record.validUntil {
                Text("Valid until \(formatDate(validUntil))")
                    .font(.footnote)
                    .foregroundColor(.blue)
                    .padding(.horizontal)
                    .padding(.bottom, 16)
            }
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    private func formatFileSize(_ size: Int) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useKB, .useMB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: Int64(size))
    }
}

struct HealthRecordsView_Previews: PreviewProvider {
    static var previews: some View {
        HealthRecordsView()
            .environmentObject(DataService())
    }
}