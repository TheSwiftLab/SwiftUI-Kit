//
//  TabBarView.swift
//  SampleApp
//
//  Created by 김동현 on 4/8/26.
//

import SwiftUI
import SwiftUI_Kit

struct TabBarView: View {
    @State private var selectedTab: Int = 0
    var body: some View {
        TabView(selection: $selectedTab) {
            WrapperListView()
                .tabItem {
                    Label("Wrapper", systemImage: "0.square.fill")
                }
                .tag(0)
            
            NativeListView()
                .tabItem {
                    Label("Native", systemImage: "1.square.fill")
                }
                .tag(1)
        }
    }
}

#Preview {
    TabBarView()
}

