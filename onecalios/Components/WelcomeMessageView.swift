//
//  WelcomeMessageView.swift
//  onecalios
//
//  Created by Henry Kim on 2021/07/18.
//

import SwiftUI

struct WelcomeMessageView: View {
    var body: some View {
        Label {
            VStack(alignment: .leading) {
                Text("Welcome to")
                    .font(.headline)
                    .bold()
                    .foregroundColor(Color(.systemIndigo))
                Text("OneCaliOS")
                    .font(.largeTitle)
                    .bold()
            }
            .foregroundColor(Color(#colorLiteral(red: 1, green: 0.5401149988, blue: 0.8455886245, alpha: 1)))
            .lineLimit(2)
            .multilineTextAlignment(.leading)
            .padding(.horizontal)
        } icon: {
            LogoImage()
        }
        .labelStyle(HorizontallyAlignedLabelStyle())
    }
}

struct WelcomeMessageView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeMessageView()
    }
}
