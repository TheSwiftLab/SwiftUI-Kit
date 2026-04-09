//
//  SKWebViewTests.swift
//  SwiftUI-Kit
//
//  Created by 김동현 on 4/8/26.
//

import Testing
import UIKit
@testable import SwiftUI_Kit

@MainActor
struct SKWebViewTests {
    
    // MARK: - Modifier
    @Test("refreshable()는 새로고침 기능을 활성화한다")
    func refreshable_enableRefresh() {
        let sut = SKWebView(url: "https://www.apple.com")
            .refreshable()
        #expect(sut.isRefreshEnabled == true)
    }
    
    @Test("refreshTitle()은 새로고침 텍스트를 변경한다")
    func refreshTitle_updatesText() {
        let sut = SKWebView(url: "https://www.apple.com")
            .refreshTitle("새로고침...")
        #expect(sut.refreshTitle == "새로고침...")
    }
    
    @Test("refreshTextColor()는 텍스트 색상을 변경한다")
    func refreshTextColor_updatesColor() {
        let sut = SKWebView(url: "https://www.apple.com")
            .refreshTextColor(.blue)
        
        #expect(sut.refreshTextColor == .systemBlue)
    }
    
    @Test("refreshIndicatorColor()는 인디케이터 색상을 변경한다")
    func refreshIndicatorColor_updatesColor() {
        let sut = SKWebView(url: "https://www.apple.com")
            .refreshIndicatorColor(.red)
        
        #expect(sut.refreshIndicatorColor == UIColor(.red))
    }
    
    @Test("refreshIndicatorScale()은 인디케이터 크기를 변경한다")
    func refreshIndicatorScale_updatesScale() {
        let sut = SKWebView(url: "https://www.apple.com")
            .refreshIndicatorScale(1.0)
        
        #expect(sut.refreshIndicatorScale == 1.0)
    }
    
    @Test("modifier는 체이닝되어 모든 설정값을 반영한다")
    func modifiers_chain_appliesAllConfigurations() {
        let sut = SKWebView(url: "https://www.apple.com")
            .refreshable()
            .refreshTitle("당겨서 새로고침")
            .refreshTextColor(.blue)
            .refreshIndicatorColor(.green)
            .refreshIndicatorScale(0.9)
        
        #expect(sut.isRefreshEnabled == true)
        #expect(sut.refreshTitle == "당겨서 새로고침")
        #expect(sut.refreshTextColor == UIColor(.blue))
        #expect(sut.refreshIndicatorColor == UIColor(.green))
        #expect(sut.refreshIndicatorScale == 0.9)
    }
}
