//
//  WelcomeView.swift
//  onecalios
//
//  Created by Henry Kim on 2021/07/18.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        NavigationView {
            ZStack {
                WelcomeBackgroundImage()
                WelcomeMessageView()
            }
            .navigationBarHidden(true)
            .onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/, perform: {
                let story = UIStoryboard.init(name: "Main", bundle: Bundle.main)
                story.instantiateInitialViewController()
            })
        }
        .navigationViewStyle(StackNavigationViewStyle())
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
