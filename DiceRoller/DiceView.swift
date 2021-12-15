//
//  DiceView.swift
//  DiceRoller
//
//  Created by Yash Poojary on 15/12/21.
//

import SwiftUI

struct DiceView: View {
    
    @FetchRequest(sortDescriptors: []) var results: FetchedResults<Result>
    
    @Environment(\.managedObjectContext) var moc
    
    @State private var calculateTotal = false
    
    
    let diceSides: [Int] = [4, 6, 8, 10, 12, 20, 100]
    
    
    @State private var currentSelection = 1
    @State private var numberOfTimes = 1
    @State private var resultingCombination = ""
    var totaledResult: Int {
        result(in: currentSelection, for:numberOfTimes)
    }
    
    var body: some View {
        NavigationView {
            
            VStack {
            List {
                Section(header: Text("Number of sides").font(.headline)) {
                    Picker("Pick a dice", selection: $currentSelection) {
                        ForEach(0..<diceSides.count) { index in
                            Text("\(diceSides[index])")
                        }
                    }
            
                    .pickerStyle(.segmented)
                }
                
                Section(header: Text("Number of dice").font(.headline)) {
                    
                    Picker("Number of times", selection: $numberOfTimes) {
                        ForEach(1..<4) {
                            Text("\($0)")
                        }
                        
                    }
                    .pickerStyle(.segmented)
                }
                
                Section(header: Text("Calculate it")) {
                    Button(action: {
                        calculateTotal = true
                    }) {
                        HStack {
                            Image(systemName: "dice")
                                .font(.largeTitle)
                                .foregroundColor(.blue)
                            Text("Hit me up")
                           
                        }
                    }
                }
                
            }
                
                
                
                
                   
                
                
                
      
            .navigationTitle("Roll Them!")
            }
            .alert("Here's what you got", isPresented: $calculateTotal) {
                Button("Your result is \(totaledResult)", role: .cancel, action: {
                    let context = Result(context: moc)
                    context.sum = Int64(totaledResult)
                    context.sides = Int64(diceSides[currentSelection])

                    
                    try? moc.save()
                })
            }
        }
    }
    
    
    func result(in selection: Int, for numberOftimes: Int) -> Int {
        
        let numberOfSides = diceSides[selection]
        
        var possibleOutcomes = [Int]()
        
        var finalArray = [Int]()
        
        for _  in 0..<numberOftimes + 1 {
            
            for numberOfSide in 0..<numberOfSides + 1 {
                possibleOutcomes.append(numberOfSide)
            }
            
            possibleOutcomes.removeAll(where: {
                $0 == 0
            })
            
            let result = possibleOutcomes.randomElement()!
            
            finalArray.append(result)
            
        }
        
            print(finalArray)
            let sum = finalArray.reduce(0, +)
            return sum
    }
}

struct DiceView_Previews: PreviewProvider {
    static var previews: some View {
        DiceView()
    }
}
