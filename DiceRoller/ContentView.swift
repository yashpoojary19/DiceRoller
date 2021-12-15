//
//  ContentView.swift
//  DiceRoller
//
//  Created by Yash Poojary on 15/12/21.
//

import SwiftUI

struct ContentView: View {
  
    
    var body: some View {
        TabView {
            
            DiceView()
                .tabItem {
                    Image(systemName: "dice.fill")
                    Text("Roll the Dice")
                }
            
            ResultsView()
                .tabItem {
                    Image(systemName: "list.bullet.rectangle.portrait.fill")
                    Text("Results")
                }
            
        }
        .onAppear {
            if #available(iOS 15.0, *) {
                let appearance = UITabBarAppearance()
                UITabBar.appearance().scrollEdgeAppearance = appearance
                }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
