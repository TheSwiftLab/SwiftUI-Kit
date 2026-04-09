//
//  SKWebView+Modifier.swift
//  SwiftUI-Kit
//
//  Created by 김동현 on 4/8/26.
//

import SwiftUI

// MARK: - Modifier
public extension SKWebView {
    
    /// Pull to Refresh 기능을 활성화합니다.
    ///
    /// - Returns: 설정이 반영된 `SKWebView`
    ///
    /// 기본적으로 비활성화되어 있으며, 호출 시 활성화됩니다.
    ///
    /// ## Example
    /// ```swift
    /// SKWebView(url: url)
    ///     .refreshable()
    /// ```
    func refreshable() -> Self {
        var copy = self
        copy.isRefreshEnabled = true
        return copy
    }
    
    /// Pull to Refresh 시 표시할 텍스트를 설정합니다.
    ///
    /// - Parameter text: 새로고침 시 상단에 표시될 문자열
    /// - Returns: 설정이 반영된 `SKWebView`
    ///
    /// ## Example
    /// ```swift
    /// SKWebView(url: url)
    ///     .refreshable()
    ///     .refreshText("새로고침 중...")
    /// ```
    ///
    /// - Note: 이 설정은 `refreshable()`이 활성화된 경우에만 적용됩니다.
    func refreshText(_ text: String) -> Self {
        var copy = self
        copy.refreshText = text
        return copy
    }
    
    /// Pull to Refresh 텍스트의 색상을 설정합니다.
    ///
    /// - Parameter color: 텍스트에 적용할 색상
    /// - Returns: 설정이 반영된 `SKWebView`
    ///
    /// 기본값은 `.label`이며 시스템 다크/라이트 모드에 자동 대응됩니다.
    ///
    /// ## Example
    /// ```swift
    /// SKWebView(url: url)
    ///     .refreshable()
    ///     .refreshTextColor(.blue)
    /// ```
    ///
    /// - Note: 이 설정은 `refreshable()`이 활성화된 경우에만 적용됩니다.
    func refreshTextColor(_ color: Color) -> Self {
        var copy = self
        copy.refreshTextColor = UIColor(color)
        return copy
    }
    
    /// Pull to Refresh 인디케이터의 색상을 설정합니다.
    ///
    /// - Parameter color: 인디케이터에 적용할 색상
    /// - Returns: 설정이 반영된 `SKWebView`
    ///
    /// iOS의 `tintColor`에 해당하는 값입니다.
    ///
    /// ## Example
    /// ```swift
    /// SKWebView(url: url)
    ///     .refreshable()
    ///     .refreshIndicatorColor(.blue)
    /// ```
    ///
    /// - Note: 이 설정은 `refreshable()`이 활성화된 경우에만 적용됩니다.
    func refreshIndicatorColor(_ color: Color) -> Self {
        var copy = self
        copy.refreshIndicatorColor = UIColor(color)
        return copy
    }
    
    /// Pull to Refresh 인디케이터의 크기를 설정합니다.
    ///
    /// - Parameter scale: 인디케이터의 스케일 값입니다. 기본값은 `0.7`입니다.
    /// - Returns: 설정이 반영된 `SKWebView`
    ///
    /// ## Example
    /// ```swift
    /// SKWebView(url: url)
    ///     .refreshable()
    ///     .refreshIndicatorScale(1.0)
    /// ```
    ///
    /// - Note: 이 설정은 `refreshable()`이 활성화된 경우에만 적용됩니다.
    ///   `CGAffineTransform`을 사용하여 크기를 조정합니다.
    func refreshIndicatorScale(_ scale: CGFloat) -> Self {
        var copy = self
        copy.refreshIndicatorScale = scale
        return copy
    }
}
