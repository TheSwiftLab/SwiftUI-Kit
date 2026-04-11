//
//  SampleSKTextFieldView.swift
//  SwiftUI-Kit
//
//  Created by opfic on 4/10/26.
//

import SwiftUI

public struct SampleSKTextFieldView: View {
    
    public var body: some View {
        TabView {
            SampleSKTextFieldLocalizedStringKeyTabView()
                .tabItem {
                    Label("키", systemImage: "textformat")
                }
            
            SampleSKTextFieldLocalizedStringResourceTabView()
                .tabItem {
                    Label("리소스", systemImage: "text.badge.star")
                }
            
            SampleSKTextFieldStringProtocolTabView()
                .tabItem {
                    Label("문자열", systemImage: "character")
                }
        }
    }
}

#Preview {
    SampleSKTextFieldView()
}
