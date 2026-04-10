//
//  SKTextField.swift
//  SwiftUI-Kit
//
//  Created by 최윤진 on 4/10/26.
//

import SwiftUI

/// SwiftUI에서 `UITextField`와 `UITextView`를 사용할 수 있도록 감싼 입력 래퍼입니다.
///
/// `axis` 값에 따라 한 줄 입력과 여러 줄 입력을 전환할 수 있으며,
/// `LocalizedStringKey`, `LocalizedStringResource`, `StringProtocol` 기반 생성자를 제공합니다.
///
/// 기본적으로 아래 기능을 제공합니다.
/// - 한 줄 입력(`.horizontal`)
/// - 여러 줄 입력(`.vertical`)
/// - placeholder 표시
/// - SwiftUI `FocusState` 연동
///
/// ## 사용 예시
/// ```swift
/// @State private var name = ""
/// @FocusState private var isNameFocused: Bool
///
/// SKTextField("이름", text: $name)
///     .focused($isNameFocused)
/// ```
///
/// ```swift
/// enum Field: Hashable {
///     case title
/// }
///
/// @State private var title = ""
/// @FocusState private var focusedField: Field?
///
/// SKTextField("제목", text: $title, axis: .vertical)
///     .focused($focusedField, equals: .title)
/// ```
public struct SKTextField<Label: View>: View {
    @Binding private var text: String
    private let axis: Axis
    private let title: Title
    private var focusValue: (() -> Bool)?
    private var onFocusChange: ((Bool) -> Void)?
    
    /// 로컬라이즈된 제목 문자열로 텍스트 필드를 생성합니다.
    ///
    /// SwiftUI `TextField.init(_:text:axis:)` 형태와 동일한 사용성을 제공합니다.
    ///
    /// - Parameters:
    ///   - titleKey: 텍스트 필드의 목적을 설명하는 로컬라이즈 키입니다.
    ///   - text: 표시하고 편집할 문자열 바인딩입니다.
    ///   - axis: 한 줄 입력 또는 여러 줄 입력 방식을 결정합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// @State private var name = ""
    ///
    /// SKTextField("이름", text: $name, axis: .horizontal)
    /// ```
    public init(
        _ titleKey: LocalizedStringKey,
        text: Binding<String>,
        axis: Axis = .horizontal
    ) where Label == Text {
        _text = text
        self.axis = axis
        title = .localized(titleKey)
        focusValue = nil
        onFocusChange = nil
    }
    
    /// 로컬라이즈 리소스로 텍스트 필드를 생성합니다.
    ///
    /// SwiftUI `TextField.init(_:text:axis:)`의 `LocalizedStringResource` 오버로드와 같은 형태를 제공합니다.
    ///
    /// - Parameters:
    ///   - titleResource: 텍스트 필드의 목적을 설명하는 로컬라이즈 리소스입니다.
    ///   - text: 표시하고 편집할 문자열 바인딩입니다.
    ///   - axis: 한 줄 입력 또는 여러 줄 입력 방식을 결정합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// @State private var title = ""
    ///
    /// SKTextField(
    ///     LocalizedStringResource("title"),
    ///     text: $title,
    ///     axis: .vertical
    /// )
    /// ```
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    public init(
        _ titleResource: LocalizedStringResource,
        text: Binding<String>,
        axis: Axis = .horizontal
    ) where Label == Text {
        _text = text
        self.axis = axis
        title = .plain(String(localized: titleResource))
        focusValue = nil
        onFocusChange = nil
    }
    
    /// 제목 문자열로 텍스트 필드를 생성합니다.
    ///
    /// SwiftUI `TextField.init(_:text:axis:)`의 `StringProtocol` 오버로드와 같은 형태를 제공합니다.
    ///
    /// - Parameters:
    ///   - title: 텍스트 필드의 목적을 설명하는 문자열입니다.
    ///   - text: 표시하고 편집할 문자열 바인딩입니다.
    ///   - axis: 한 줄 입력 또는 여러 줄 입력 방식을 결정합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// @State private var email = ""
    ///
    /// SKTextField("이메일", text: $email, axis: .horizontal)
    /// ```
    public init<S>(
        _ title: S,
        text: Binding<String>,
        axis: Axis = .horizontal
    ) where S: StringProtocol, Label == Text {
        _text = text
        self.axis = axis
        self.title = .plain(String(title))
        focusValue = nil
        onFocusChange = nil
    }
    
    public var body: some View {
        SKTextFieldPresentable(
            text: $text,
            axis: axis,
            placeholder: placeholder,
            accessibilityLabel: accessibilityLabel,
            focusBinding: {
                if let focusValue, let onFocusChange {
                    return Binding(
                        get: {
                            focusValue()
                        },
                        set: { newValue in
                            onFocusChange(newValue)
                        }
                    )
                }
                
                return nil
            }()
        )
    }
    
    /// `Bool` 기반 `FocusState`와 텍스트 필드를 연결합니다.
    ///
    /// SwiftUI `View.focused(_:)`와 같은 형태로 사용할 수 있습니다.
    ///
    /// - Parameter condition: 포커스 상태를 나타내는 `FocusState` 바인딩입니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// @State private var name = ""
    /// @FocusState private var isNameFocused: Bool
    ///
    /// SKTextField("이름", text: $name)
    ///     .focused($isNameFocused)
    /// ```
    public func focused(_ condition: FocusState<Bool>.Binding) -> some View {
        var copy = self
        copy.focusValue = {
            condition.wrappedValue
        }
        copy.onFocusChange = { newValue in
            Task { @MainActor in
                condition.wrappedValue = newValue
            }
        }
        
        return AnyView(copy)
            .focused(condition)
    }
    
    /// 값 비교 기반 `FocusState`와 텍스트 필드를 연결합니다.
    ///
    /// SwiftUI `View.focused(_:equals:)`와 같은 형태로 사용할 수 있습니다.
    ///
    /// - Parameters:
    ///   - binding: 현재 포커스 대상을 나타내는 `FocusState` 바인딩입니다.
    ///   - value: 이 텍스트 필드에 대응하는 포커스 값입니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// enum Field: Hashable {
    ///     case title
    /// }
    ///
    /// @State private var title = ""
    /// @FocusState private var focusedField: Field?
    ///
    /// SKTextField("제목", text: $title, axis: .vertical)
    ///     .focused($focusedField, equals: .title)
    /// ```
    public func focused<Value>(
        _ binding: FocusState<Value?>.Binding,
        equals value: Value
    ) -> some View where Value: Hashable {
        var copy = self
        copy.focusValue = {
            binding.wrappedValue == value
        }
        copy.onFocusChange = { isFocused in
            Task { @MainActor in
                if isFocused {
                    binding.wrappedValue = value
                } else if binding.wrappedValue == value {
                    binding.wrappedValue = nil
                }
            }
        }
        
        return AnyView(copy)
            .focused(
                binding,
                equals: value
            )
    }
    
    private var placeholder: String {
        switch title {
        case .localized(let localizedStringKey):
            return localizedStringKey.skResolvedString ?? ""
        case .plain(let plainText):
            return plainText
        }
    }
    
    private var accessibilityLabel: String? {
        switch title {
        case .localized(let localizedStringKey):
            return localizedStringKey.skResolvedString
        case .plain(let plainText):
            return plainText
        }
    }
    
    private enum Title {
        case localized(LocalizedStringKey)
        case plain(String)
    }
}
