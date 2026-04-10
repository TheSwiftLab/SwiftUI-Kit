//
//  SKTextField.swift
//  SwiftUI-Kit
//
//  Created by 최윤진 on 4/10/26.
//

import SwiftUI

public struct SKTextField<Label: View>: View {
    @Binding private var text: String
    private let axis: Axis
    private let title: Title
    private var focusValue: (() -> Bool)?
    private var onFocusChange: ((Bool) -> Void)?
    
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
    
    public func focused<Value>(
        _ binding: FocusState<Value>.Binding,
        equals value: Value
    ) -> some View where Value: Hashable & ExpressibleByNilLiteral {
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
