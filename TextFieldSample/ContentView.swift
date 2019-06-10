//
//  ContentView.swift
//  TextFieldSample
//
//  Created by Akifumi Fukaya on 6/10/19.
//  Copyright © 2019 Akifumi Fukaya. All rights reserved.
//

import SwiftUI
import Combine

final class ContentViewModel : BindableObject {
    var didChange = PassthroughSubject<Void, Never>()
    var username: String = "" {
        didSet {
            didChange.send(())
            usernameSubject.send(username)
        }
    }
    private let usernameSubject = PassthroughSubject<String, Never>()
    private var validatedUsername: AnyPublisher<String?, Never> {
        return usernameSubject
//            .debounce(for: 0.5, scheduler: ImmediateScheduler.shared)
//            .removeDuplicates()
            .flatMap { (username) -> AnyPublisher<String?, Never> in
                Publishers.Future<String?, Never> { (promise) in
                    // FIXME: API request
                    if 1...10 ~= username.count {
                        promise(.success(username))
                    } else {
                        promise(.success(nil))
                    }
                }
                .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }

    lazy var onAppear: () -> Void = { [weak self] in
        _ = self?.validatedUsername.sink(receiveCompletion: { (completion) in
            print("validatedUsername.receiveCompletion: \(completion)")
        }, receiveValue: { (value) in
            print("validatedUsername.receiveValue: \(value ?? "nil")")
        })
    }
}

struct ContentView : View {
    @ObjectBinding var viewModel: ContentViewModel

    var body: some View {
        VStack {
            HStack {
                (1...10 ~= viewModel.username.count)
                    ? Text("OK").color(.green)
                    : Text("NG").color(.red)
                Spacer()
            }
            TextField($viewModel.username, placeholder: Text("Placeholder"), onEditingChanged: { (changed) in
                print("onEditingChanged: \(changed)")
            }, onCommit: {
                print("onCommit")
            })
        }
        .padding(.horizontal)
        .onAppear(perform: viewModel.onAppear)
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: ContentViewModel())
    }
}
#endif
