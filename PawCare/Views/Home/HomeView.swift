import SwiftUI
import Charts

struct HomeView: View {
    @EnvironmentObject var dataService: DataService
    @State private var selectedCat: Cat?

    var body: some View {
        NavigationView {
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
                                // Navigate to add cat view
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
                                ContentUnavailableView(
                                    "No Reminders",
                                    systemImage: "bell.slash",
                                    description: Text("You don't have any reminders for today")
                                )
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
                        .padding(.horizontal)
                    } else {
                        ContentUnavailableView(
                            "No Cats Added",
                            systemImage: "pawprint",
                            description: Text("Add your first cat to get started")
                        )
                        .padding(.top, 50)
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
                    // Show add action sheet
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
