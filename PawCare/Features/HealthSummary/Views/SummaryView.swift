import SwiftUI

struct SummaryView: View {
    @StateObject private var vm = SummaryViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Picker("Range", selection: $vm.selectedRange) {
                    ForEach(SummaryService.TimeRange.allCases, id: \.self) { Text($0.displayName).tag($0) }
                }.pickerStyle(.segmented)

                if let s = vm.current {
                    Text("Total records: \(s.totalRecords)").font(.headline)
                } else {
                    Text("No summary yet")
                }
                Spacer()
            }
            .padding()
            .navigationTitle("Summary")
        }
    }
}
