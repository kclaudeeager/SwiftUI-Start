//
//  CrossedForksView.swift
//  HelloWorld
//
//  Created by Claude KWIZERA on 3/26/23.
//

import Foundation
import SwiftUI

struct CrossedForksView: View {
    var body: some View {
        CrossedKnifeAndForkShape()
            .foregroundColor(.black)
            .frame(width: 100, height: 100)
            .padding(.top, 50)
    }
}
struct CrossedForksView_Previews: PreviewProvider {
    static var previews: some View {
    
        CrossedForksView()
    }
}

