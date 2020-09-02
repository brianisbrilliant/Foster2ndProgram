//
//  ContentView.swift
//  Foster2ndProgram
//
//  Created by Professor Foster on 9/2/20.
//  Copyright © 2020 Professor Foster. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var data: UserData
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: ListView()) {
                    Text("Foster's Second Program")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                        .padding(10.0)
                        .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/4/*@END_MENU_TOKEN@*/)
                        .shadow(radius: /*@START_MENU_TOKEN@*/3/*@END_MENU_TOKEN@*/)
                        .background(/*@START_MENU_TOKEN@*/Color.blue/*@END_MENU_TOKEN@*/)
                        .cornerRadius(7.0)
                    
                }
                .navigationBarTitle(/*@START_MENU_TOKEN@*/"Navigation Bar"/*@END_MENU_TOKEN@*/)
                Button(action: {
                    self.data.counter += 1
                    if self.data.counter > 25 {
                        self.data.counter = 0
                    }
                }) {
                    Text("Counter = " + String(self.data.counter))
                        
                }
                .padding(20.0)
                .background(/*@START_MENU_TOKEN@*/Color.yellow/*@END_MENU_TOKEN@*/)
                .cornerRadius(7.0)
                TextField("Text", text: $data.asdf)
                    .padding(10.0)
                    .border(Color.gray, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                    .cornerRadius(/*@START_MENU_TOKEN@*/6.0/*@END_MENU_TOKEN@*/)
                Text(self.data.asdf)
                    .foregroundColor(Color.gray)
            }
        .padding(10)
        }
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(UserData())
    }
}
