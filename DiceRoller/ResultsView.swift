//
//  ResultsView.swift
//  DiceRoller
//
//  Created by Yash Poojary on 15/12/21.
//

import SwiftUI

struct ResultsView: View {
    
    @FetchRequest(sortDescriptors: []) var results: FetchedResults<Result>
    @Environment(\.managedObjectContext) var moc
    
    var body: some View {
        NavigationView {
            List() {

                    ForEach(results, id: \.self) { result in
                    
                    VStack(alignment: .leading) {
                        Text("Number of sides: \(result.sides)")
                            .font(.headline)
                        Text("Total sum: \(result.sum)")
                    }
                    
                }
                    .onDelete(perform: delete)
            }
            .navigationTitle("Results")
            .toolbar {
                EditButton()
            }
        }
    }
    
    func delete(at offsets: IndexSet) {
        for offset in offsets {
            let result = results[offset]

            moc.delete(result)
        }
        
        try? moc.save()
    }
}

//struct ResultsView_Previews: PreviewProvider {
//    static var previews: some View {
//        ResultsView(fetchrequest: <#FetchRequest<Result>#>)
//    }
//}
