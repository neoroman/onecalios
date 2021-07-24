//
//  WelcomeView.swift
//  onecalios
//
//  Created by Henry Kim on 2021/07/18.
//

import SwiftUI

struct WelcomeView: View {
    @State private var showingMain = false
    
    var body: some View {
        NavigationView {
            ZStack {
                WelcomeMessageView()
                WelcomeBackgroundImage()
            }
            .navigationBarHidden(true)
            .onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/, perform: {
                self.showingMain = true
            })
            .sheet(isPresented: $showingMain) {
                NavigationView {
                    MainCalendarView()
                        .navigationTitle("💳 Calendar")
                }
            }
            .onAppear(perform: {
                startMain()
            })
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .overlay(alignment: .bottomTrailing) {
            VStack(alignment: .trailing) {
                HStack(alignment: .bottom) {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    FloatingMenu()                    
                }
            }            
            .padding()
            .zIndex(100)
        }
    }
    
    func startMain() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) { 
            self.showingMain = true
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}

class WelcomeViewController: UIHostingController<WelcomeView> {
    required init?(coder: NSCoder) {
        super.init(coder: coder, rootView: WelcomeView())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
