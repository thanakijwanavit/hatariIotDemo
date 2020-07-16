//
//  DeviceControlView.swift
//  hatariIotDemo
//
//  Created by nic wanavit on 7/16/20.
//  Copyright © 2020 nic wanavit. All rights reserved.
//

import SwiftUI

struct InputButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
        .padding()
        .foregroundColor(.white)
        .background(configuration.isPressed ? Color.red : Color.blue)
        .clipShape(Circle())
        
    }
    
    
}

struct DeviceControlView: View {
    @State var presentGraph:Bool = false
    @State var speed:Int = 1
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack{
//            displays
            
            HStack{
                Text("speed: \(self.speed)")
                .font(.headline)
                    .onReceive(timer) { (_) in
                        debugPrint("timer is called")
                        AirPurifier.getStatus { (state) in
                            let purifierStatus = state as PurifierStatus
                            self.speed = purifierStatus.state.speed
                        }
                }
                
                
            }
            
            
            
            
            
//            buttons
            HStack{
                self.inputButton(label: "power")
                self.inputButton(label: "auto")
                self.inputButton(label: "plus")
            }
            HStack{
                self.inputButton(label: "timer")
                self.inputButton(label: "chart")
                self.inputButton(label: "minus")
            }
                
            self.chartButton()
            .padding()
                
            .sheet(isPresented: self.$presentGraph) {
                self.chartView()
            }
            
            
            
        }
        .navigationBarTitle("Air Purifier M")
    }
    
    func inputButton(label:String)-> some View {
        return Button(action: {
            
        }) {
            Image(label)
            .resizable()
                .aspectRatio(contentMode: .fit)
        }
        .buttonStyle(InputButtonStyle())
        .padding()
    }
    
    func chartButton()-> some View {
        Button(action: {
            self.presentGraph.toggle()
        }, label: {
            Image("chart")
            .renderingMode(.original)
            .resizable()
            .scaledToFit()
        })
        .buttonStyle(BorderlessButtonStyle())
    }
    func chartView()-> some View {
        Image("chart")
        .resizable()
        .scaledToFit()
    }
}

struct DeviceControlView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            DeviceControlView()
            ContentView()
            ContentView()
            .previewDevice("iPad Pro (12.9-inch)")
            ContentView()
            .previewDevice("iPhone 11 Pro Max")
            ContentView()

        }
        
    }
}
