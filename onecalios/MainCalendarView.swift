//
//  MainCalendarView.swift
//  onecalios
//
//  Created by Henry Kim on 2021/07/09.
//

import SwiftUI

struct MainCalendarView: View {
    var body: some View {
        Text("Hello, neoroman's world!")
            .padding()
    }
}

struct MainCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        MainCalendarView()
    }
}

class MainCalendarViewController: UIHostingController<MainCalendarView> {
    required init?(coder: NSCoder) {
        super.init(coder: coder, rootView: MainCalendarView())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
