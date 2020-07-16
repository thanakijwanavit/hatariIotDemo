//
//  ContentView.swift
//  hatariIotDemo
//
//  Created by nic wanavit on 7/16/20.
//  Copyright © 2020 nic wanavit. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView{
            
            TabView{
                DeviceControlView()
                .tabItem {
                    Image(systemName: "house")
                    .renderingMode(.original)
                }
                
                
                Image(systemName: "person")
                .tabItem {
                    Image(systemName: "person")
                }
                
                Text("menu")
                .tabItem {
                    Image(systemName: "square.grid.2x2")
                }
                
                
            }
            .navigationBarItems(leading: Image(systemName: "line.horizontal.3"), trailing: Image(systemName: "gear"))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
