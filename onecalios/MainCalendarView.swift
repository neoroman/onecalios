//
//  MainCalendarView.swift
//  onecalios
//
//  Created by Henry Kim on 2021/07/09.
//

import SwiftUI
import UIKit


// TODO: (2021.07.18) make this storyboard view into SwiftUI view
struct MainCalendarView: UIViewControllerRepresentable {
    typealias UIViewControllerType = DayEventListViewController
    
    let story = UIStoryboard.init(name: "Main", bundle: Bundle.main)

    func makeUIViewController(context: Context) -> DayEventListViewController {
        guard let dayEventList = story.instantiateViewController(withIdentifier: "DayEventListViewController") as? DayEventListViewController  else {
            return DayEventListViewController()
        }
        return dayEventList
    }
    func updateUIViewController(_ uiViewController: DayEventListViewController, context: Context) {
        // code
    }
}

struct MainCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        MainCalendarView()
    }
}

// class MainCalendarViewController: UIHostingController<MainCalendarView> {
//    required init?(coder: NSCoder) {
//        super.init(coder: coder, rootView: MainCalendarView())
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//    }
// }
