//
//  OtherPartView.swift
//  HelloWorld
//
//  Created by Claude KWIZERA on 3/25/23.
//

import Foundation

import SwiftUI
struct OtherPart:View{
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!").foregroundColor(.blue)
            Text("This is Claude and I am enjoying learning swiftUI").multilineTextAlignment(.center).padding(EdgeInsets(top: 3, leading: 5, bottom: 10, trailing: 20)).border(Color.cyan,width:2).font(Font.title)
            HStack{
                Text("I'm happy").foregroundColor(.red)
                Text("Learning to code!").foregroundColor(.orange)
                        .font(Font.custom("Helvetica", size: 24))
                
                    
            }.padding().background(Color.gray)
           
            ZStack(alignment: Alignment(horizontal: .leading, vertical: .bottom)) {
                VStack {
                    Text("Inner  box has lower z index").foregroundColor(.yellow).multilineTextAlignment(.center)
                }
                    .frame(width: 300, height: 300)
                    .background(Color.blue)
                VStack {
                    Text("Inner  box has higher z index").foregroundColor(.blue).multilineTextAlignment(.center).font(Font.caption).bold()
                }
                    .frame(width: 150, height: 100)
                    .background(Color.yellow)
            }
            Button(action: {
                print("Clicked me")
            }, label: {
                Text("Click me")
            }).font(Font.title3).padding()
                .background(Color.blue)
                .foregroundColor(.white)
           
        }
        .padding()
    }
}
