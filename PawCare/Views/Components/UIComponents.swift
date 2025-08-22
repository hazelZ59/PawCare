import SwiftUI

// MARK: - CatAvatarView
struct CatAvatarView: View {
    let cat: Cat
    let isSelected: Bool
    
    var body: some View {
        VStack {
            if let imageURL = cat.imageURL {
                AsyncImage(url: imageURL) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFill()
                    } else if phase.error != nil {
                        Image(systemName: "pawprint.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                    } else {
                        ProgressView()
                    }
                }
                .frame(width: 60, height: 60)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 3)
                )
            } else {
                Circle()
                    .fill(Color.blue.opacity(0.2))
                    .frame(width: 60, height: 60)
                    .overlay(
                        Image(systemName: "pawprint.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.blue)
                    )
                    .overlay(
                        Circle()
                            .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 3)
                    )
            }
            
            Text(cat.name)
                .font(.caption)
                .fontWeight(.medium)
                .lineLimit(1)
        }
    }
}

// MARK: - StatItemView
struct StatItemView: View {
    let icon: String
    let iconColor: Color
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(iconColor)
            
            Text(value)
                .font(.system(size: 20, weight: .bold))
            
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

// MARK: - ListItemView
struct ListItemView: View {
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String
    
    var body: some View {
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(iconColor)
                    .frame(width: 36, height: 36)
                
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.blue)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
    }
}

// MARK: - CardView
struct CardView<Content: View>: View {
    let title: String
    let actionText: String?
    let content: Content
    
    init(title: String, actionText: String? = nil, @ViewBuilder content: () -> Content) {
        self.title = title
        self.actionText = actionText
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(title)
                    .font(.headline)
                
                Spacer()
                
                if let actionText = actionText {
                    Button(action: {}) {
                        Text(actionText)
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }
                }
            }
            .padding()
            
            content
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
        .padding(.vertical, 8)
    }
}
