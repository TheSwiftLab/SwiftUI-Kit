//
//  SKWebView.swift
//  SwiftUI-Kit
//
//  Created by 김동현 on 4/8/26.
//

import SwiftUI
import WebKit

/// SwiftUI에서 `WKWebView`를 사용할 수 있도록 감싼 웹뷰 래퍼입니다.
///
/// `URL`을 입력받아 웹 페이지를 로드하며,
/// 필요에 따라 Pull to Refresh 기능을 활성화할 수 있습니다.
///
/// 기본적으로 아래 기능을 제공합니다.
/// - URL 로드
/// - 선택적 Pull to Refresh
/// - `WKNavigationDelegate` 연결
///
/// ## 사용 예시
/// ```swift
/// SKWebView(url: URL(string: "https://www.naver.com")!)
///     .refreshable()
///     .refreshTitle("새로고침")
///     .refreshIndicatorColor(.blue)
///     .refreshTextColor(.blue)
///     .refreshIndicatorScale(1.0)
///     .ignoresSafeArea()
/// ```
public struct SKWebView: UIViewRepresentable {
    
    // MARK: - Configuration
    let url: URL
    var refreshTitle: String
    var refreshTextColor: UIColor
    var refreshIndicatorColor: UIColor
    var refreshIndicatorScale: CGFloat
    var isRefreshEnabled: Bool
    
    public init(url: URL) {
        self.url = url
        self.refreshTitle = ""
        self.refreshTextColor = .label
        self.refreshIndicatorColor = .label
        self.refreshIndicatorScale = 0.7
        self.isRefreshEnabled = false
    }
}

// MARK: - WebView Lifecycle
public extension SKWebView {
    
    /// UIKit View를 최초 1회 생성합니다.
    ///
    /// `makeUIView`는 실제 UIKit 뷰 인스턴스를 만드는 역할을 담당합니다.
    /// `WKWebView`를 생성하고 초기 UI 설정을 적용합니다.
    ///
    /// - Parameter context:
    ///   - `Coordinator` 및 SwiftUI 환경 정보에 접근할 수 있는 컨텍스트
    ///   - 추후 delegate 연결이나 상태 전달 시 활용
    ///
    /// - Returns: 초기 설정이 적용된 `WKWebView`
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView(frame: .zero)
        webView.navigationDelegate = context.coordinator
        
        if isRefreshEnabled {
            
            // Pull to Refresh 구성
            let refreshControl = UIRefreshControl()
            
            // 새로고침 시 보여줄 텍스트 스타일 지정
            refreshControl.attributedTitle = NSAttributedString(
                string: refreshTitle,
                attributes: [.foregroundColor: refreshTextColor]
            )
            
            // 인디케이터 색상 지정
            refreshControl.tintColor = refreshIndicatorColor
            
            // 인디케이터 크기 조절
            refreshControl.transform = CGAffineTransform(
                scaleX: refreshIndicatorScale,
                y: refreshIndicatorScale
            )
            
            // reload
            refreshControl.addTarget(
                context.coordinator,
                action: #selector(Coordinator.handleRefresh),
                for: .valueChanged
            )
            
            context.coordinator.webView = webView
            context.coordinator.refreshControl = refreshControl
            
            webView.scrollView.refreshControl = refreshControl
            webView.scrollView.bounces = true
        }
        return webView
    }
    
    /// SwiftUI 상태가 변경될 때 기존 UIKit 뷰를 업데이트합니다.
    ///
    /// `updateUIView`는 이미 생성된 UIKit 뷰에 최신 SwiftUI 상태를 반영하는 역할을 합니다.
    ///
    /// - Parameters:
    ///   - uiView: 이미 생성된 `WKWebView` 인스턴스
    ///   - context: `Coordinator` 및 SwiftUI 환경 정보에 접근할 수 있는 컨텍스트
    func updateUIView(
        _ uiView: WKWebView,
        context: Context
    ) {
        guard uiView.url != url else { return }
        uiView.load(URLRequest(url: url))
    }
}

// MARK: - Coordinator
public extension SKWebView {
    
    /// SwiftUI와 UIKit 사이의 중간 객체인 Coordinator를 생성합니다.
    /// `Coordinator`는 보통 다음과 같은 상황에서 사용됩니다.
    /// - delegate / dataSource 연결
    /// - UIKit 이벤트를 SwiftUI 상태로 전달
    /// - 외부 객체와의 중간 브리지 역할
    ///
    /// 현재 구현에서는 `WKNavigationDelegate`를 연결하기 위한 용도로만 사용하며,
    /// 아직 별도의 상태 전달 로직은 포함되어 있지 않습니다.
    ///
    /// - Returns: `WKNavigationDelegate` 역할을 수행하는 `Coordinator`
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    /// `WKWebView`의 네비게이션 관련 delegate 이벤트를 처리하는 객체입니다.
    final class Coordinator: NSObject, WKNavigationDelegate {
        weak var webView: WKWebView?
        weak var refreshControl: UIRefreshControl?
        
        /// Pull to Refresh 발생 시 호출됩니다.
        @objc func handleRefresh() {
            webView?.reload()
        }
        
        /// 페이지 로딩 완료 시 refresh 상태를 종료합니다.
        public func webView(
            _ webView: WKWebView,
            didFinish navigation: WKNavigation!
        ) {
            refreshControl?.endRefreshing()
        }
        
        /// 페이지 로딩 실패 시 refresh 상태를 종료합니다.
        public func webView(
            _ webView: WKWebView,
            didFail navigation: WKNavigation!,
            withError error: Error
        ) {
            refreshControl?.endRefreshing()
        }
        
        /// 초기 로딩 실패 시 refresh 상태를 종료합니다.
        public func webView(
            _ webView: WKWebView,
            didFailProvisionalNavigation navigation: WKNavigation!,
            withError error: Error
        ) {
            refreshControl?.endRefreshing()
        }
    }
}
