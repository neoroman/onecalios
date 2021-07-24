//
//  WelcomeBackgroundImage.swift
//  onecalios
//
//  Created by Henry Kim on 2021/07/18.
//

import SwiftUI

struct WelcomeBackgroundImage: View {
    var body: some View {
        VStack {
            Image("onecalios-logo")
                .resizable()
                .aspectRatio(1 / 1, contentMode: .fill)
                .edgesIgnoringSafeArea(.top)
                .saturation(0.5)
                .blur(radius: 5)
                .opacity(0.09)
                .padding(.bottom, 80)
            
            Spacer()
        }
    }
}

struct WelcomeBackgroundImage_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeBackgroundImage()
    }
}
