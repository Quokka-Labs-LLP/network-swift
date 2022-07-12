//
//  ContentView.swift
//  NetworkHandler
//
//  Created by Pavnish Kumar Rana on 05/07/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("Hello, world!")
            .padding()
            .onAppear {
                let request = URLRequest(url: <#T##URL#>, method: <#T##HttpMethod#>, useHeaders: <#T##URLRequest.Headers#>, params: <#T##Encodable#>)
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
