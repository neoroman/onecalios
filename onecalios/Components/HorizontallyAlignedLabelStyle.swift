//
//  HorizontallyAlignedLabelStyle.swift
//  onecalios
//
//  Created by Henry Kim on 2021/07/18.
//

import Foundation
import SwiftUI

struct HorizontallyAlignedLabelStyle: LabelStyle {
  func makeBody(configuration: Configuration) -> some View {
    HStack {
      configuration.icon
      configuration.title
    }
  }
}
