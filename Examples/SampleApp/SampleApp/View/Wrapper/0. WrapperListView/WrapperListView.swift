//
//  WrapperListView.swift
//  SampleApp
//
//  Created by 김동현 on 4/8/26.
//

import SwiftUI

struct WrapperListView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("") {
                    NavigationLink("SKWebView") {
                        SampleSKWebView()
                    }
                }
            }
        }
    }
}

#Preview {
    WrapperListView()
}
