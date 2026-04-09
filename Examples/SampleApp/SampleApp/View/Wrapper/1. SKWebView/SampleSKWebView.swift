//
//  SampleSKWebView.swift
//  SampleApp
//
//  Created by 김동현 on 4/8/26.
//

import SwiftUI
import SwiftUI_Kit

struct SampleSKWebView: View {
    var body: some View {
        SKWebView(url: URL(string: "https://www.naver.com")!)
            .refreshable()
            .refreshText("새로고침")
            .refreshIndicatorColor(.blue)
            .refreshTextColor(.blue)
            .refreshIndicatorScale(1.0)
            .ignoresSafeArea()
    }
}

#Preview {
    SampleSKWebView()
}
