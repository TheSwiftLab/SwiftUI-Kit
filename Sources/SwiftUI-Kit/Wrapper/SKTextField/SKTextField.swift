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
    private var focusBinding: Binding<Bool>?
    
    public init(
        _ titleKey: LocalizedStringKey,
        text: Binding<String>,
        axis: Axis = .horizontal
    ) where Label == Text {
        _text = text
        self.axis = axis
        title = .localized(titleKey)
        focusBinding = nil
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
        focusBinding = nil
    }
    
    public init<S>(
        _ title: S,
        text: Binding<String>,
        axis: Axis = .horizontal
    ) where S: StringProtocol, Label == Text {
        _text = text
        self.axis = axis
        self.title = .plain(String(title))
        focusBinding = nil
    }
    
    public var body: some View {
        SKTextFieldPresentable(
            text: $text,
            axis: axis,
            placeholder: placeholder,
            accessibilityLabel: accessibilityLabel,
            focusBinding: focusBinding
        )
    }
    
    func focused(_ condition: FocusState<Bool>.Binding) -> some View {
        var copy = self
        copy.focusBinding = Binding(condition)
        
        return AnyView(copy)
            .focused(condition)
    }
    
    func focused<Value>(
        _ binding: FocusState<Value>.Binding,
        equals value: Value
    ) -> some View where Value: Hashable & ExpressibleByNilLiteral {
        var copy = self
        copy.focusBinding = Binding(
            binding,
            equals: value
        )
        
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

private extension Binding where Value == Bool {
    init(_ binding: FocusState<Bool>.Binding) {
        nonisolated(unsafe) let unsafeBinding = binding
        
        self.init(
            get: {
                MainActor.assumeIsolated {
                    unsafeBinding.wrappedValue
                }
            },
            set: { newValue in
                MainActor.assumeIsolated {
                    unsafeBinding.wrappedValue = newValue
                }
            }
        )
    }
    
    init<FocusedValue>(
        _ binding: FocusState<FocusedValue>.Binding,
        equals value: FocusedValue
    ) where FocusedValue: Hashable & ExpressibleByNilLiteral {
        nonisolated(unsafe) let unsafeBinding = binding
        nonisolated(unsafe) let unsafeValue = value
        
        self.init(
            get: {
                MainActor.assumeIsolated {
                    unsafeBinding.wrappedValue == unsafeValue
                }
            },
            set: { isFocused in
                MainActor.assumeIsolated {
                    if isFocused {
                        unsafeBinding.wrappedValue = unsafeValue
                    } else if unsafeBinding.wrappedValue == unsafeValue {
                        unsafeBinding.wrappedValue = nil
                    }
                }
            }
        )
    }
}
