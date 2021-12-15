//
//  DataController.swift
//  DiceRoller
//
//  Created by Yash Poojary on 15/12/21.
//

import CoreData
import Foundation


class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "DiceRoller")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}
