//
//  ContentView.swift
//  onecalios
//
//  Created by Henry Kim on 2021/07/09.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("Hello, neoroman's world!")
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

class MainCalendarViewController: UIHostingController<ContentView> {
    required init?(coder: NSCoder) {
        super.init(coder: coder, rootView: ContentView())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
