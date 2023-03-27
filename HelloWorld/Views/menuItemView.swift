import SwiftUI

import SwiftUI

struct MenuItemView: View {
    @State private var isAddedToCart = false
    @State private var isZoomed = false
    @State private var scale: CGFloat = 1.0
    var item: MenuItem
    var handleMenuItemViewClicked: (MenuItem) -> Void
    @Binding var cart: [CartItem]
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16.0)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.2), radius: 8.0, x: 0, y: 2)
                .scaleEffect(isZoomed ? 1.05 : 1.0)
                .onHover { hover in
                    withAnimation(.easeInOut(duration: 0.5)) {
                        isZoomed = hover
                    }
                }


            VStack(spacing: 8) {
                Text("\(item.catg_name)")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color.black)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                if let imageUrlString = item.image?.replacingOccurrences(of: " ", with: "%20"), let imageUrl = URL(string: "\(Urls.startUrl)\(imageUrlString)") {
                    URLImage(url: imageUrl)
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 80)
                        .clipShape(RoundedRectangle(cornerRadius: 16.0))
                        .padding(.top, 8)
                } else {
                    Text("No Image")
                        .font(.system(size: 12))
                        .foregroundColor(Color.black)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 8)
                }

                HStack(spacing: 8) {
                    Text("\(item.price) RWF")
                        .font(.system(size: 14))
                        .foregroundColor(Color.white)
                        .frame(maxWidth:100,maxHeight: 24, alignment: .center)
                        .background(Color.blue)
                        .cornerRadius(4.0)
                   
                     Button(action: {
                        toggleAddOrRemoveItem()
                       
                    }, label: {
                        Image(systemName: isAddedToCart ? "checkmark.circle.fill" : "plus.circle.fill")
                            .foregroundColor(Color.blue)
                    })
                    .frame(width: 24, height: 24)
                    .background(Color.white)
                    .clipShape(Circle())
                    .shadow(color: Color.black.opacity(0.2), radius: 4.0, x: 0, y: 2)
                } .frame(maxWidth: .infinity, alignment: .center)
                Text(item.unit_name == "" ? "\(item.catg_name)" : "\(item.catg_name) _ \(item.unit_name)")
                    .font(.system(size: 12))
                    .foregroundColor(Color.black)
                    .lineLimit(3)
                    .padding(.top, 4)
                    .multilineTextAlignment(.center)
            }
            .padding(8)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .gesture(
            MagnificationGesture()
                .onChanged { value in
                    scale = value.magnitude
                }
                .onEnded { value in
                    scale = 1.0
                }
        ).onAppear {
            isAddedToCart = cart.contains(where: { $0.menuItem.assign_id == item.assign_id })
        }
    }
    
    func toggleAddOrRemoveItem(){
        isAddedToCart.toggle()
        handleMenuItemViewClicked(item)
    }

}


struct MenuItemView_Previews: PreviewProvider {
    
    @State static var menuItem = MenuItem(assign_id: "6", item: "3", catg_id: "3", unit_id: "7", image: "/img/products/paradboxotot.png", site_id: "1", dep_id: "2", has_parent: "5", piece_no: nil, orderable: nil, type: "1", status: "1", catg_name: "Pandoras Box Meloit(South Africa)", item_id: "3", item_name: "Red Wines", class_item: "1", reg_date: "2023-03-14 07:04:29", delete_flag: "0", unit_name: "ToT", price: "6000")
    
    @State static var cartItems = [CartItem(menuItem: menuItem, quantity: 1,consumed_amount:20.0,accompaniment: nil,sauce: nil,comment: "Hy")]
    static var previews: some View {
        MenuItemView(item: menuItem, handleMenuItemViewClicked: { _ in },cart: $cartItems)
            .padding()
            .previewLayout(.sizeThatFits)
            .environment(\.colorScheme, .light)
            .previewDisplayName("Light Mode")
        
        MenuItemView(item: menuItem, handleMenuItemViewClicked: { _ in },cart: $cartItems)
            .padding()
            .previewLayout(.sizeThatFits)
            .environment(\.colorScheme, .dark)
            .previewDisplayName("Dark Mode")
    }
}

