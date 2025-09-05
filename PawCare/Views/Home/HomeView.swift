import SwiftUI
import Charts

struct HomeView: View {
    @EnvironmentObject var dataService: DataService
    @State private var selectedCat: Cat?
    @State private var isShowingAddCat = false
    @State private var isShowingAddHealthRecord = false
    @State private var isShowingAddWeightRecord = false
    @State private var isShowingActionSheet = false
    
    var body: some View {
        NavigationView {
            Group {
                if dataService.cats.isEmpty {
                    // Empty state when no cats are added
                    VStack(spacing: 24) {
                        Spacer()
                        
                        Image(systemName: "pawprint.circle.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.blue.opacity(0.8))
                        
                        Text("Welcome to PawCare")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("Add your first cat to start tracking their health records, weight, and more.")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                        
                        Button(action: {
                            isShowingAddCat = true
                        }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                Text("Add Your First Cat")
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(12)
                            .padding(.horizontal, 40)
                        }
                        .padding(.top, 16)
                        
                        Spacer()
                    }
                    .navigationTitle("PawCare")
                } else {
                    // Regular view when cats are available
                    ScrollView {
                        VStack(spacing: 16) {
                            // Cat selector
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(dataService.cats) { cat in
                                        CatAvatarView(cat: cat, isSelected: selectedCat?.id == cat.id)
                                            .onTapGesture {
                                                selectedCat = cat
                                            }
                                    }
                                    
                                    Button(action: {
                                        isShowingAddCat = true
                                    }) {
                                        VStack {
                                            ZStack {
                                                Circle()
                                                    .fill(Color.blue.opacity(0.1))
                                                    .frame(width: 60, height: 60)
                                                
                                                Image(systemName: "plus")
                                                    .font(.system(size: 24))
                                                    .foregroundColor(.blue)
                                            }
                                            
                                            Text("Add Cat")
                                                .font(.caption)
                                                .fontWeight(.medium)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                            .padding(.top, 8)
                            
                            if let cat = selectedCat ?? dataService.cats.first {
                                // Overview card
                                VStack(spacing: 0) {
                                    HStack {
                                        Text("Today's Overview")
                                            .font(.headline)
                                        
                                        Spacer()
                                        
                                        Text(cat.name)
                                            .font(.subheadline)
                                            .foregroundColor(.blue)
                                    }
                                    .padding()
                                    .background(Color.white)
                                    
                                    CatStatsGrid(cat: cat)
                                        .environmentObject(dataService)
                                        .padding()
                                        .background(Color.white)
                                }
                                .cornerRadius(12)
                                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
                                .padding(.horizontal)
                                
                                // Reminders
                                CardView(title: "Today's Reminders", actionText: "View All") {
                                    if dataService.healthRecords.filter({ $0.catId == cat.id }).isEmpty {
                                        VStack(spacing: 20) {
                                            Image(systemName: "bell.slash")
                                                .font(.system(size: 40))
                                                .foregroundColor(.gray)
                                            
                                            Text("No Reminders")
                                                .font(.headline)
                                            
                                            Text("You don't have any reminders for today")
                                                .font(.subheadline)
                                                .foregroundColor(.secondary)
                                                .multilineTextAlignment(.center)
                                        }
                                        .frame(height: 150)
                                    } else {
                                        VStack(spacing: 0) {
                                            ListItemView(
                                                icon: "pills",
                                                iconColor: .red,
                                                title: "Morning Medication",
                                                subtitle: "8:00 AM - Antibiotic"
                                            )
                                            
                                            Divider()
                                            
                                            ListItemView(
                                                icon: "fork.knife",
                                                iconColor: .green,
                                                title: "Evening Meal",
                                                subtitle: "6:00 PM - 1/2 cup dry food"
                                            )
                                        }
                                    }
                                }
                                .padding(.horizontal)
                                
                                // Recent activity
                                CardView(title: "Recent Activity", actionText: "View All") {
                                    if dataService.healthRecords.filter({ $0.catId == cat.id }).isEmpty {
                                        VStack(spacing: 20) {
                                            Image(systemName: "list.bullet.clipboard")
                                                .font(.system(size: 40))
                                                .foregroundColor(.gray)
                                            
                                            Text("No Activity")
                                                .font(.headline)
                                            
                                            Text("Add health records to track your cat's activity")
                                                .font(.subheadline)
                                                .foregroundColor(.secondary)
                                                .multilineTextAlignment(.center)
                                            
                                            Button(action: {
                                                isShowingAddHealthRecord = true
                                            }) {
                                                Text("Add Health Record")
                                                    .font(.subheadline)
                                                    .fontWeight(.medium)
                                                    .foregroundColor(.blue)
                                                    .padding(.vertical, 8)
                                                    .padding(.horizontal, 16)
                                                    .background(Color.blue.opacity(0.1))
                                                    .cornerRadius(8)
                                            }
                                        }
                                        .frame(height: 200)
                                    } else {
                                        VStack(spacing: 0) {
                                            ForEach(dataService.healthRecords.filter { $0.catId == cat.id }.prefix(3)) { record in
                                                ListItemView(
                                                    icon: record.type.icon,
                                                    iconColor: record.type.color,
                                                    title: record.title,
                                                    subtitle: formatDate(record.date) + (record.veterinarian != nil ? " • \(record.veterinarian!)" : "")
                                                )
                                                
                                                if record.id != dataService.healthRecords.filter({ $0.catId == cat.id }).prefix(3).last?.id {
                                                    Divider()
                                                }
                                            }
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        .padding(.bottom, 100)
                    }
                    .navigationTitle("PawCare")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {}) {
                                Image(systemName: "bell")
                                    .foregroundColor(.primary)
                            }
                        }
                    }
                    .overlay(alignment: .bottomTrailing) {
                        Button(action: {
                            isShowingActionSheet = true
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
                        .padding(.bottom, 100)
                    }
                    .confirmationDialog("Add New", isPresented: $isShowingActionSheet, titleVisibility: .visible) {
                        Button("Add Health Record") {
                            if let cat = selectedCat ?? dataService.cats.first {
                                isShowingAddHealthRecord = true
                            }
                        }
                        
                        Button("Add Weight Record") {
                            if let cat = selectedCat ?? dataService.cats.first {
                                isShowingAddWeightRecord = true
                            }
                        }
                        
                        Button("Add Cat") {
                            isShowingAddCat = true
                        }
                        
                        Button("Cancel", role: .cancel) {}
                    }
                }
            }
            .sheet(isPresented: $isShowingAddCat) {
                AddCatView()
            }
            .sheet(isPresented: $isShowingAddHealthRecord) {
                if let cat = selectedCat ?? dataService.cats.first {
                    AddHealthRecordView(cat: cat)
                }
            }
            .sheet(isPresented: $isShowingAddWeightRecord) {
                if let cat = selectedCat ?? dataService.cats.first {
                    AddWeightView(cat: cat)
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
    
    private func formatDate(_ date: Date) -> String {
        if Calendar.current.isDateInToday(date) {
            return "Today"
        } else if Calendar.current.isDateInYesterday(date) {
            return "Yesterday"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d, yyyy"
            return formatter.string(from: date)
        }
    }
}

// MARK: - Extracted CatStatsGrid View

struct CatStatsGrid: View {
    @EnvironmentObject var dataService: DataService
    let cat: Cat
    
    // Computed properties to determine what to display
    private var weightInfo: (icon: String, color: Color, value: String) {
        if let latestWeight = dataService.getLatestWeight(catId: cat.id) {
            return ("scalemass", .blue, String(format: "%.1f kg", latestWeight.weight))
        } else {
            return ("scalemass", .gray, "No data")
        }
    }
    
    private var vaccineInfo: (icon: String, color: Color, value: String) {
        if let nextVaccination = dataService.healthRecords
            .filter({ $0.catId == cat.id && $0.type == .vaccination && $0.validUntil != nil })
            .sorted(by: { ($0.validUntil ?? Date()) < ($1.validUntil ?? Date()) })
            .first {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d"
            return ("syringe", .orange, dateFormatter.string(from: nextVaccination.validUntil ?? Date()))
        } else {
            return ("syringe", .gray, "None")
        }
    }
    
    var body: some View {
        let columns = [GridItem(.flexible()), GridItem(.flexible())]
        
        return LazyVGrid(columns: columns, spacing: 12) {
            // Weight stat
            StatItemView(
                icon: weightInfo.icon,
                iconColor: weightInfo.color,
                value: weightInfo.value,
                label: "Current Weight"
            )
            
            // Health status stat
            StatItemView(
                icon: "heart",
                iconColor: .green,
                value: "Good",
                label: "Health Status"
            )
            
            // Vaccination stat
            StatItemView(
                icon: vaccineInfo.icon,
                iconColor: vaccineInfo.color,
                value: vaccineInfo.value,
                label: "Next Vaccine"
            )
            
            // Vet visit stat
            StatItemView(
                icon: "calendar.badge.clock",
                iconColor: .purple,
                value: "None",
                label: "Vet Visit"
            )
        }
    }
}