import SwiftUI

struct HelpSupportView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // App info section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("About PawCare")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("PawCare is a comprehensive cat health tracking app designed to help cat owners monitor and maintain their cats' health records, weight, and more.")
                            .font(.body)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    // Contact section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Contact Us")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("If you have any questions, feedback, or need assistance, please don't hesitate to reach out to our support team.")
                            .font(.body)
                        
                        HStack {
                            Image(systemName: "envelope")
                                .foregroundColor(.blue)
                            
                            Text("support@pawcare.example.com")
                                .font(.body)
                        }
                        
                        HStack {
                            Image(systemName: "globe")
                                .foregroundColor(.blue)
                            
                            Text("www.pawcare.example.com")
                                .font(.body)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    // FAQ section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Frequently Asked Questions")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        FAQItem(question: "How do I add a new cat?", 
                                answer: "Tap the '+' button on the home screen and select 'Add Cat'. Fill in your cat's details and tap 'Save'.")
                        
                        FAQItem(question: "How do I track my cat's weight?", 
                                answer: "Navigate to the 'Weight' tab, then tap the '+' button to add a new weight record.")
                        
                        FAQItem(question: "How do I add a health record?", 
                                answer: "Navigate to the 'Health' tab, then tap the '+' button to add a new health record.")
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                }
                .padding()
            }
            .navigationTitle("Help & Support")
            .navigationBarItems(leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "xmark")
                    .foregroundColor(.primary)
            })
        }
    }
}

struct FAQItem: View {
    let question: String
    let answer: String
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Button(action: {
                withAnimation {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Text(question)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.blue)
                }
            }
            
            if isExpanded {
                Text(answer)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .padding(.top, 4)
            }
        }
        .padding(.vertical, 8)
    }
}

struct HelpSupportView_Previews: PreviewProvider {
    static var previews: some View {
        HelpSupportView()
    }
}

