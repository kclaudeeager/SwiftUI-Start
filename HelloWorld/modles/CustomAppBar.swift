//
//  CustomAppBar.swift
//  HelloWorld
//
//  Created by Claude KWIZERA on 3/10/23.
//

import SwiftUI

struct CustomAppBar: View {
    let company: Company

    var body: some View {
        ZStack {
            HStack {
                Image(systemName: "house")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                Text(company.cmp_sn)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Spacer()
            }
            .padding()
            .background(Color.blue)

            GeometryReader { geometry in
                VStack {
                    Spacer()
                    Capsule()
                        .fill(Color.white)
                        .frame(width: 60, height: 6)
                        .padding(.bottom, geometry.safeAreaInsets.bottom) // use safeAreaInsets of current window scene
                }
            }
        }
        .ignoresSafeArea(.all, edges: .top)
    }
}


struct CustomTheme: ViewModifier {
    func body(content: Content) -> some View {
        content
            .accentColor(.blue)
            .background(Color.white.edgesIgnoringSafeArea(.all))
    }
}

extension View {
    func customTheme() -> some View {
        self.modifier(CustomTheme())
    }
}
