//
//  WelcomeBackgroundImage.swift
//  onecalios
//
//  Created by Henry Kim on 2021/07/18.
//

import SwiftUI

struct WelcomeBackgroundImage: View {
    var body: some View {
      Image("onecalios-logo")
        .resizable()
        .aspectRatio(1 / 1, contentMode: .fill)
        .edgesIgnoringSafeArea(.all)
        .saturation(0.5)
        .blur(radius: 5)
        .opacity(0.09)
    }
}

struct WelcomeBackgroundImage_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeBackgroundImage()
    }
}
