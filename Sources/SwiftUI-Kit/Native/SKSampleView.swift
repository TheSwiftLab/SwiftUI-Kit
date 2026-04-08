//
//  SwiftUIView.swift
//  SwiftUI-Kit
//
//  Created by 김동현 on 4/8/26.
//

import SwiftUI

public struct SKSampleView: View {
    
    public init () {}
    
    public var body: some View {
        Text(String(describing: Self.self))
    }
}

#Preview {
    SKSampleView()
}
