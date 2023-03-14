//
//  ContentView.swift
//  WeatherApp
//
//  Created by Devinely on 14.03.2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Home()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("BG"))
            .padding(.top, -90)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
