//
//  ListView.swift
//  Foster2ndProgram
//
//  Created by Professor Foster on 9/2/20.
//  Copyright © 2020 Professor Foster. All rights reserved.
//

import SwiftUI

struct ListView: View {
    var body: some View {
        List {
            Text("First thing")
            Text("Second thing")
            NavigationLink(destination: ContentView()) {
            Text("You're Going Places!")
            }
        }
        .navigationBarTitle(Text("Title Thing"))
        
        
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}
