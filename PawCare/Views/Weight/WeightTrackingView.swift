import SwiftUI
import Charts

struct WeightTrackingView: View {
    @EnvironmentObject var dataService: DataService
    @State private var selectedCat: Cat?
    @State private var isShowingCalendar = false
    @State private var isShowingAddWeight = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
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
                    }
                    
                    if let cat = selectedCat ?? dataService.cats.first {
                        // Current weight card
                        VStack {
                            HStack {
                                Text("Current Weight")
                                    .font(.headline)
                                
                                Spacer()
                                
                                Text(cat.name)
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                            }
                            .padding()
                            
                            if let latestWeight = dataService.getLatestWeight(catId: cat.id) {
                                VStack(spacing: 4) {
                                    Text(String(format: "%.1f kg", latestWeight.weight))
                                        .font(.system(size: 36, weight: .bold))
                                    
                                    if let weightChange = dataService.getWeightChange(catId: cat.id) {
                                        HStack(spacing: 4) {
                                            Image(systemName: weightChange < 0 ? "arrow.down" : "arrow.up")
                                            Text(String(format: "%.1f kg from last month", abs(weightChange)))
                                        }
                                        .font(.subheadline)
                                        .foregroundColor(weightChange < 0 ? .green : .red)
                                    }
                                }
                                .padding(.bottom)
                            } else {
                                Text("No weight data available")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .padding()
                            }
                        }
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                        .padding(.horizontal)
                        
                        // Weight history chart
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Weight History")
                                    .font(.headline)
                                
                                Spacer()
                                
                                Text("Last 9 Months")
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                            }
                            .padding()
                            
                            let catWeights = dataService.getWeightRecords(catId: cat.id)
                            
                            if !catWeights.isEmpty {
                                // Weight chart
                                Chart {
                                    ForEach(catWeights) { record in
                                        BarMark(
                                            x: .value("Month", formatMonth(record.date)),
                                            y: .value("Weight", record.weight)
                                        )
                                        .foregroundStyle(Color.blue)
                                        .cornerRadius(4)
                                    }
                                }
                                .frame(height: 200)
                                .padding(.horizontal)
                                
                                // Weight history list
                                VStack(spacing: 0) {
                                    ForEach(catWeights) { record in
                                        HStack {
                                            Text(formatDate(record.date))
                                                .font(.subheadline)
                                                .foregroundColor(.secondary)
                                            
                                            Spacer()
                                            
                                            Text(String(format: "%.1f kg", record.weight))
                                                .font(.subheadline)
                                                .fontWeight(.semibold)
                                        }
                                        .padding()
                                        
                                        if record.id != catWeights.last?.id {
                                            Divider()
                                                .padding(.horizontal)
                                        }
                                    }
                                }
                                .padding(.top)
                            } else {
                                VStack(spacing: 20) {
                                    Image(systemName: "scalemass")
                                        .font(.system(size: 60))
                                        .foregroundColor(.gray)
                                    
                                    Text("No Weight Data")
                                        .font(.title2)
                                        .fontWeight(.medium)
                                    
                                    Text("Add your first weight record to start tracking")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal, 40)
                                    
                                    Button(action: {
                                        isShowingAddWeight = true
                                    }) {
                                        Text("Add Weight Record")
                                            .fontWeight(.semibold)
                                            .foregroundColor(.white)
                                            .padding(.vertical, 12)
                                            .padding(.horizontal, 24)
                                            .background(Color.blue)
                                            .cornerRadius(10)
                                    }
                                    .padding(.top, 10)
                                }
                                .frame(height: 300)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical)
                            }
                        }
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                        .padding(.horizontal)
                    } else {
                        VStack(spacing: 20) {
                            Image(systemName: "pawprint")
                                .font(.system(size: 60))
                                .foregroundColor(.gray)
                            
                            Text("No Cats Added")
                                .font(.title2)
                                .fontWeight(.medium)
                            
                            Text("Add your first cat to get started")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 50)
                    }
                }
                .padding(.bottom, 100) // Extra padding for the bottom to account for the tab bar
            }
            .navigationTitle("Weight Tracking")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isShowingCalendar.toggle()
                    }) {
                        Image(systemName: "calendar")
                            .foregroundColor(.primary)
                    }
                }
            }
            .overlay(alignment: .bottomTrailing) {
                Button(action: {
                    if let cat = selectedCat ?? dataService.cats.first {
                        isShowingAddWeight = true
                    }
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
                .opacity(dataService.cats.isEmpty ? 0 : 1)
            }
            .sheet(isPresented: $isShowingAddWeight) {
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
    
    private func formatMonth(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        return formatter.string(from: date)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        return formatter.string(from: date)
    }
}

struct WeightTrackingView_Previews: PreviewProvider {
    static var previews: some View {
        WeightTrackingView()
            .environmentObject(DataService())
    }
}