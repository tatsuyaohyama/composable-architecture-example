
import SDWebImageSwiftUI
import SwiftUI

struct SearchRowView: View {
    
    let repository: Repository
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                if let ownerImageURL = URL(string: repository.owner.avatarURL) {
                    WebImage(url: ownerImageURL)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 42, height: 42)
                        .clipShape(Circle())
                }
                Text(repository.owner.login)
            }
            
            Text(repository.fullName)
                .foregroundColor(.blue)
            Text(repository.itemDescription ?? "")
            
            HStack {
                Image(systemName: "star")
                Text("\(repository.stargazersCount)")
                Text(repository.language ?? "")
            }
            .foregroundColor(.gray)
        }
        .padding()
    }
}
