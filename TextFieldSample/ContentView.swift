//
//  ContentView.swift
//  TextFieldSample
//
//  Created by Akifumi Fukaya on 6/10/19.
//  Copyright © 2019 Akifumi Fukaya. All rights reserved.
//

import SwiftUI

struct ContentView : View {
    @State private var text: String = ""

    var body: some View {
        VStack {
            HStack {
                (1...10 ~= text.count) ? Text("OK") : Text("NG")
                Spacer()
            }
            TextField($text, placeholder: Text("Placeholder"), onEditingChanged: { (changed) in
                print("onEditingChanged: \(changed)")
            }, onCommit: {
                print("onCommit")
            })
        }
        .padding(.horizontal)
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
