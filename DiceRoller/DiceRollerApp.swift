//
//  DiceRollerApp.swift
//  DiceRoller
//
//  Created by Yash Poojary on 15/12/21.
//

import SwiftUI

@main
struct DiceRollerApp: App {
    
    @StateObject private var dataContoller = DataController()
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataContoller.container.viewContext)
        }
    }
}
