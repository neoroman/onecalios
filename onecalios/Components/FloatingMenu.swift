//
//  FloatingMenu.swift
//  Onecalios
//
//  Created by Henry Kim on 2021/07/24.
//

import SwiftUI

struct FloatingMenu: View {
    @State var showMenuItem1 = false
    @State var showMenuItem2 = false
    @State var showMenuItem3 = false

    @State var offset: CGSize = .zero
    @GestureState var isLongPressed = false

    var body: some View {
        let drag = DragGesture()
            .onChanged { self.offset = $0.translation }
            .onEnded {_ in 
                self.offset = .zero
            }
        
        //        let longPress = LongPressGesture()
        //            .updating($isLongPressed) { value, state, transition in
        //                state = value
        //            }
        //            .simultaneously(with: drag)
        
        VStack {
            Spacer()
            if showMenuItem1 {
                MenuItem(icon: "camera.fill")
            }
            if showMenuItem2 {
                MenuItem(icon: "photo.on.rectangle")
            }
            if showMenuItem3 {
                MenuItem(icon: "square.and.arrow.up.fill")
            }

            Button(action: { 
                self.showMenu() 
            }) {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .foregroundColor(Color(red: 153/255, green: 102/255, blue: 255/255))
                    .shadow(color: .gray, radius: 0.2, x: 1, y: 1)
                    .animation(.spring()) // WHY ?!?
                    .offset(self.offset)
                    .gesture(drag)
                    .scaleEffect(isLongPressed ? 1.1 : 1)
            }
        }
    }
    
    func showMenu() {
        withAnimation {
            showMenuItem3.toggle()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            withAnimation {
                self.showMenuItem2.toggle()
            }
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            withAnimation {
                self.showMenuItem1.toggle()
            }
        })
    }
}


struct FloatingMenu_Previews: PreviewProvider {
    static var previews: some View {
        FloatingMenu()
    }
}

struct MenuItem: View {
    var icon: String
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(Color(red: 153/255, green: 102/255, blue: 255/255))
                .frame(width: 55, height: 55)
            Image(systemName: icon)
                .imageScale(.large)
                .foregroundColor(.white)
        }
        .shadow(color: .gray, radius: 0.2, x: 1, y: 1)
        .transition(.move(edge: .trailing))
    }
}
