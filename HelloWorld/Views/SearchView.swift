import SwiftUI
struct SearchView: View {
    @Binding var searchText: String
    @State private var isEditing = false
    
    var body: some View {
        HStack {
            TextField("Search menu", text: $searchText, onEditingChanged: { isEditing in
                withAnimation {
                    self.isEditing = isEditing
                }
            })
            .padding(8)
            .padding(.horizontal, 25)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .overlay(
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 8)
                    if isEditing {
                        Button(action: {
                            withAnimation {
                                searchText = ""
                                isEditing = false
                            }
                        }) {
                            Image(systemName: "multiply.circle.fill")
                                .foregroundColor(.gray)
                                .padding(.trailing, 8)
                        }
                    }
                }
            )
            if isEditing {
                Button("Cancel") {
                    withAnimation {
                        searchText = ""
                        isEditing = false
                    }
                }
                .foregroundColor(.blue)
                .padding(.trailing, 10)
            }
        }
        .padding()
    }
}

