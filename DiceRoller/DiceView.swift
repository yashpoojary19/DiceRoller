//
//  DiceView.swift
//  DiceRoller
//
//  Created by Yash Poojary on 15/12/21.
//

import SwiftUI
import CoreHaptics

struct DiceView: View {
    
    @FetchRequest(sortDescriptors: []) var results: FetchedResults<Result>
    
    @Environment(\.managedObjectContext) var moc
    
    @State private var calculateTotal = false
    
    
    let diceSides: [Int] = [4, 6, 8, 10, 12, 20, 100]
    
    @State private var engine: CHHapticEngine?
    
    
    @State private var currentSelection = 2
    @State private var numberOfTimes = 0
    @State private var resultingCombination = ""
    @State private var finalResult = 2

    
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
            .onAppear {
                saveData()
            }
            .alert("Here's what you got", isPresented: $calculateTotal) {
                Button("Your result is \(finalResult)", role: .cancel, action: {
                    prepareHaptics()
                    complexSuccess()
                    saveData()
                })
            }
            
        }
    }
    
    func saveData() {
        finalResult =  result(in: currentSelection, for: numberOfTimes)
        let context = Result(context: moc)
        context.sum = Int64(finalResult)
        context.sides = Int64(diceSides[currentSelection])

        
        try? moc.save()
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
    
    func prepareHaptics() {
        
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
            return
        }
        
        
        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func complexSuccess() {
        
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
            return
        }
        
        var events = [CHHapticEvent]()
        
        for i in stride(from: 0, to: 1, by: 0.1) {
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(i))
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(i))
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: i)
            events.append(event)
        }
        
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct DiceView_Previews: PreviewProvider {
    static var previews: some View {
        DiceView()
    }
}
