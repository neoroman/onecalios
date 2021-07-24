//
//  ViewExtension.swift
//  Onecalios
//
//  Created by Henry Kim on 2021/07/24.
//

import SwiftUI

extension View {
    func overlay<Overlay: View>(alignment: Alignment, @ViewBuilder builder: () -> Overlay) -> some View {
        overlay(builder(), alignment: alignment)
    }
}
