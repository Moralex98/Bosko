//
//  StatefulPreviewWrapper.swift
//  ProjectSwift
//
//  Created by Freddy Morales on 27/03/25.
//

import Foundation
import SwiftUI

import SwiftUI

struct StatefulPreviewWrapper<T>: View {
    @State private var value: T
    var content: (Binding<T>) -> AnyView

    init(_ value: T, content: @escaping (Binding<T>) -> some View) {
        _value = State(initialValue: value)
        self.content = { binding in AnyView(content(binding)) }
    }

    var body: some View {
        content($value)
    }
}

