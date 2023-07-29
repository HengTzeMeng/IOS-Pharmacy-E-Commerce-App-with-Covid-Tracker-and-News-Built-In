//
//  ContentView.swift
//  PandaGrab
//
//  Created by Heng Tzemeng on 18/05/2021.
//

import SwiftUI
import CoreData
import Firebase

//Show View from Home.swift
struct ContentView: View {

    var body: some View {
        NavigationView{
            Home()
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

