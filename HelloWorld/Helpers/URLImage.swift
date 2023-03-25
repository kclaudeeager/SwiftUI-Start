//
//  URLImage.swift
//  HelloWorld
//
//  Created by Claude KWIZERA on 3/25/23.
//

import Foundation
import SwiftUI
struct URLImage: View {
    let url: URL
    
    @State private var image: UIImage?
    @State private var error: Error?
    
    var body: some View {
        Group {
            if let image = image {
                         Image(uiImage: image)
                             .resizable()
                             .aspectRatio(contentMode: .fill)
                             .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                             .clipped()
            } else if let error = error {
                // Error message
                Text("Error: \(error.localizedDescription)")
            } else {
                // Placeholder image
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 4.0))
            }
        }
        .onAppear {
            downloadImage(from: url)
        }
    }
    
    private func downloadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                // Handle the error
                DispatchQueue.main.async {
                    self.error = error
                }
            } else if let data = data, let image = UIImage(data: data) {
                // Set the image
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }.resume()
    }
}
