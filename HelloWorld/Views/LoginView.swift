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
    @State private var showToast = false
    @State private var toastMessage = ""
    enum Field: Hashable {
        case emailField
        case passwordField
    }
    @FocusState private var focusedField: Field?
    @State private var isEmailValid = true
    @State private var buttonScale: CGFloat = 1.0
    @State private var isLoggingIn = false // Add state variable
    @State private var isLoggedin = false
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.gray, .white]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            VStack(spacing: 30) {
                Image(systemName: "building.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.black)
                    .shadow(color: .black, radius: 10, x: 0, y: 0)
                    .padding(.top,70)
                Text("Restaurant Login")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 20)
              
                VStack(spacing: 20) {
                    TextField("Enter your email", text: $userEmail)
                        .foregroundColor(.blue)
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
                        .foregroundColor(.blue)
                        .padding(10)
                        .background(Color.white)
                        .cornerRadius(20)
                        .padding(.horizontal, 30)
                        .focused($focusedField, equals: .passwordField)
                }
                
                // Update button text and add ProgressView
                Button(action: {
                    if userEmail.isEmpty {
                        focusedField = .emailField
                    }
                    else if password.isEmpty {
                        focusedField = .passwordField
                    }
                    else {
                        isLoggingIn = true
                        login()
                    }
                }) {
                    if isLoggingIn {
                        ProgressView() // Show progress view while logging in
                            .progressViewStyle(CircularProgressViewStyle())
                            .foregroundColor(.white)
                    } else {
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
                }
                .scaleEffect(buttonScale) // Move scale effect here
                if showToast {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        ToastMessageView(message: toastMessage)
                            .transition(.move(edge: .bottom))
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                    showToast = false
                                }
                            }
                    }
                }


                Spacer()
               
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    func validateEmail() {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        isEmailValid=emailPredicate.evaluate(with: userEmail)
    }
    
    func login() {
        let endpointURL = URL(string: "https://uncle.itec.rw/RestaurantApi/management.php/login")!
        var request = URLRequest(url: endpointURL)
        request.httpMethod = "POST"
        let requestBody: [String: Any] = [
            "email": userEmail,
            "password": password
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Login request failed with error: \(error.localizedDescription)")
                toastMessage = "Login request failed"
                showToast = true
                isLoggingIn = false
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response received")
                isLoggingIn = false
                return
            }
          
            if (200...299).contains(httpResponse.statusCode), let data = data {
                // login successful, handle the response data
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    
                    guard let userDataJSON = json?["user_data"] as? [String: Any] else {
                        print("User data not found in response")
                        toastMessage = "Login request failed"
                        showToast = true
                        isLoggingIn = false
                        return
                    }
                        
                    let companyDataJSON = json?["company_data"] as? [String: Any] ?? [:]
                    
                    guard let userData = try? JSONDecoder().decode(User.self, from: JSONSerialization.data(withJSONObject: userDataJSON)),
                          let companyData = try? JSONDecoder().decode(Company.self, from: JSONSerialization.data(withJSONObject: companyDataJSON)) else {
                        print("Error decoding user or company data")
                        toastMessage = "Login request failed"
                        showToast = true
                        isLoggingIn = false
                        return
                    }
                    
                    // set a success message to be shown to the user
                    withAnimation {
                        buttonScale = 0.9
                    }
                    withAnimation(Animation.easeInOut(duration: 0.2).delay(0.2)) {
                        buttonScale = 1.0
                    }
                    
                   
                    // navigate to home page
                    DispatchQueue.main.async {
                        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                            let mainWindow = windowScene.windows.first(where: { $0.isKeyWindow }) else {
                                fatalError("Unable to retrieve main window")
                            
                        }
                        toastMessage = "Login successful!"
                                   showToast = true
                        let homePageView = HomePageView(userData: userData, companyData: companyData)
                        let homePageViewController = UIHostingController(rootView: homePageView)
                        mainWindow.rootViewController = UINavigationController(rootViewController: homePageViewController)
                    }
                   
                    isLoggingIn = false

                } catch {
                    print("Error decoding login response: \(error.localizedDescription)")
                    toastMessage = "Login request failed"
                    showToast = true
                    isLoggingIn = false
                }
            }

           else {
                // login failed, handle the response status code
                print("Login request failed with status code: \(httpResponse.statusCode)")
               toastMessage = "Login request failed"
               showToast = true
                isLoggingIn = false
            }
        }
        task.resume()
    }

}


struct LoginFormView_Previews: PreviewProvider {
    static var previews: some View {
    
        LoginFormView()
    }
}




