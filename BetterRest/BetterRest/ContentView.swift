//
//  ContentView.swift
//  BetterRest
//
//  Created by Murat Han on 15.04.2020.
//  Copyright © 2020 mracipayam. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    @State private var Title = ""
    @State private var Message = ""
    
    let coffeeIntake = [1,2,3,4,5,6,7,8,9,10]
    
    var body: some View {
        NavigationView{
            Form{
                Section(header: Text("When do you want to wake up?")){
                    DatePicker("Please enter a time",selection: $wakeUp,displayedComponents: .hourAndMinute)
                    .labelsHidden()
                    .datePickerStyle(WheelDatePickerStyle())
                }
                Section(header : Text("Desired amount of sleep")){
                    Stepper(value: $sleepAmount, in: 4...12,step: 0.25){
                        Text("\(sleepAmount,specifier: "%g") hours ")
                    }
                }
                Section(header: Text("Daily coffee intake")){
                    
                    Picker("Select how much cup of coffee",selection: $coffeeAmount){
                        ForEach(0..<coffeeIntake.count){
                            Text("\(self.coffeeIntake[$0]) cup")
                        }
                    }
                }
                Section(header : Text("Your ideal bedtime is :")){
                    Text("\(Title + Message)")
                    Button(action:calculateBedtime){
                        Text("Calculate")
                    }
                    
                }
                
            }
            .navigationBarTitle("Better Rest")
            
                
        }
    }
    
    static var defaultWakeTime : Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components ) ?? Date()
    }
    
    
    func calculateBedtime() {
        let model = SleepCalculator()
        
        let components = Calendar.current.dateComponents([.hour,.minute],from: wakeUp)
        
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60
        
        do{
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            // more code here
            let sleepTime = wakeUp - prediction.actualSleep
            
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            
            Message = formatter.string(from: sleepTime)
            Title = "Bed time is "
        }catch{
            Title = "Error"
            Message = "Sorry, there was a problem calculating your bedtime."
        }
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
