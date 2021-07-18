//
//  LogoImage.swift
//  onecalios
//
//  Created by Henry Kim on 2021/07/18.
//

import SwiftUI

let bgColor = Color(#colorLiteral(red: 1, green: 0.5401149988, blue: 0.8455886245, alpha: 1)) 

struct LogoImage: View {
  var body: some View {
    Image("onecalios-logo")
      .resizable()
      .frame(width: 60, height: 60)
      .overlay(Circle().stroke(Color.gray, lineWidth: 1))
      .background(Color(white: 0.9))
      .clipShape(Circle())
      .foregroundColor(.red)
  }
}

struct LogoImage_Previews: PreviewProvider {
  static var previews: some View {
    LogoImage()
  }
}
