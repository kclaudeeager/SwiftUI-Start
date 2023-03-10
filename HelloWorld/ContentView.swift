//
//  ContentView.swift
//  HelloWorld
//
//  Created by Claude KWIZERA on 3/7/23.
//

import SwiftUI
struct LoginFormView: View {
    @State var userEmail: String = ""
    @State var password: String = ""
    enum Field: Hashable {
        case emailField
        case passwordField
    }
    @FocusState private var focusedField: Field?
    @State private var isEmailValid = true
    var body: some View {
        ZStack {
            Color(UIColor(red: 240/255, green: 238/255, blue: 238/255, alpha: 1.0))
                .ignoresSafeArea()
            VStack(spacing: 30) {
                Text("Restaurant Login")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.top, 50)
                Image(systemName: "building.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.black)
                    .shadow(color: .black, radius: 10, x: 0, y: 0)
                VStack(spacing: 20) {
                    TextField("Enter your email", text: $userEmail)
                        .foregroundColor(.black)
                        .padding(10)
                        .background(Color.white)
                        .cornerRadius(20)
                        .padding(.horizontal, 30)
                        .focused($focusedField, equals: .emailField)
                        .onChange(of: userEmail) { newValue in
                            validateEmail()
                        }
                    if !isEmailValid {
                        Text("Please enter a valid email address")
                            .foregroundColor(.red)
                            .padding(.horizontal, 30)
                    }
                    SecureField("Enter your password", text: $password)
                        .foregroundColor(.black)
                        .padding(10)
                        .background(Color.white)
                        .cornerRadius(20)
                        .padding(.horizontal, 30)
                        .focused($focusedField, equals: .passwordField)
                }
                Button(action: {
                    if userEmail.isEmpty {
                        focusedField = .emailField
                    }
                    else if password.isEmpty {
                        focusedField = .passwordField
                    }
                    else {
                        print("Button tapped")
                    }
                }) {
                    Text("Login")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.vertical, 15)
                        .frame(width: 220)
                        .background(Color.blue)
                        .cornerRadius(20)
                        .shadow(color: .black, radius: 5, x: 0, y: 0)
                }
                Spacer()
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    func validateEmail() {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        isEmailValid = emailPredicate.evaluate(with: userEmail)
    }
}





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


struct ContentView: View {
    var body: some View {
        LoginFormView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
    
        LoginFormView()
    }
}
