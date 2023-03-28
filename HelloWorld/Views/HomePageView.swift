//
//  HomePageView.swift
//  HelloWorld
//
//  Created by Claude KWIZERA on 3/25/23.
//

import Foundation
import SwiftUI
struct HomePageView: View {
    let userData: User
    let companyData: Company
    
    var body: some View {
        VStack {
            VStack {
                Image(systemName: "building.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.black)
                    .shadow(color: .black, radius: 10, x: 0, y: 0)
                    .padding(.top,70)
                Text("\(companyData.cmp_sn)")
                    .font(.headline)
                    .foregroundColor(.black)
            }


            Spacer()
            Text("Welcome \(userData.f_name) \(userData.l_name)!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .padding(.top, 50)
            
            Spacer()
            NavigationLink(destination: ActivitiesView(userData:userData,companyData:companyData,menuViewModel: MenuViewModel())) {
                Text("Go to Activities")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.vertical, 15)
                    .frame(width: 220)
                    .background(Color.blue)
                    .cornerRadius(20)
                    .shadow(color: .black, radius: 5, x: 0, y: 0)
            }
            
            Button(action: {
                // Logout logic goes here
            }) {
                Text("Logout")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 220)
                    .background(Color.red)
                    .cornerRadius(20)
                    .shadow(color: .black, radius: 5, x: 0, y: 0)
            }
            Spacer()
        }
    }
}
