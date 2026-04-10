//
//  SKTextFieldTests.swift
//  SwiftUI-Kit
//
//  Created by opfic on 4/10/26.
//

import SwiftUI
import Testing
@testable import SwiftUI_Kit

@MainActor
struct SKTextFieldTests {
    
    @Test("LocalizedStringKey 생성자는 기본 구성이 가능하다")
    func localizedStringKeyInit_defaultConfiguration() {
        let sut = SKTextField(
            LocalizedStringKey("sample_title"),
            text: .constant("")
        )
        
        #expect(!String(describing: type(of: sut)).isEmpty)
    }
    
    @Test("LocalizedStringResource 생성자는 기본 구성이 가능하다")
    func localizedStringResourceInit_defaultConfiguration() throws {
        guard #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) else {
            return
        }
        
        let sut = SKTextField(
            LocalizedStringResource("sample_title"),
            text: .constant("")
        )
        
        #expect(!String(describing: type(of: sut)).isEmpty)
    }
    
    @Test("StringProtocol 생성자는 기본 구성이 가능하다")
    func stringProtocolInit_defaultConfiguration() {
        let sut = SKTextField(
            "Plain Title",
            text: .constant("")
        )
        
        #expect(!String(describing: type(of: sut)).isEmpty)
    }
    
    @Test("focused(_:)는 Bool FocusState와 조합된다")
    func focused_bindBoolFocusState() {
        let focusState = FocusState<Bool>()
        let sut = SKTextField(
            "Title",
            text: .constant("")
        )
        .focused(focusState.projectedValue)
        
        #expect(!String(describing: type(of: sut)).isEmpty)
    }
    
    @Test("focused(_:equals:)는 optional FocusState와 조합된다")
    func focused_bindOptionalFocusState() {
        let focusState = FocusState<SampleField?>()
        let sut = SKTextField(
            "Title",
            text: .constant("")
        )
        .focused(focusState.projectedValue, equals: .plain)
        
        #expect(!String(describing: type(of: sut)).isEmpty)
    }
    
    @Test("horizontal container는 UITextField만 생성한다")
    func horizontalContainer_createsTextFieldOnly() {
        let sut = SKTextFieldContainer(axis: .horizontal)
        
        #expect(sut.uiTextField != nil)
        #expect(sut.uiTextView == nil)
        #expect(sut.activeResponder is UITextField)
    }
    
    @Test("vertical container는 UITextView만 생성한다")
    func verticalContainer_createsTextViewOnly() {
        let sut = SKTextFieldContainer(axis: .vertical)
        
        #expect(sut.uiTextField == nil)
        #expect(sut.uiTextView != nil)
        #expect(sut.activeResponder is UITextView)
    }
    
    @Test("coordinator는 UITextField 변경을 binding에 반영한다")
    func coordinator_textFieldDidChange_updatesBinding() {
        let textBox = TextBox()
        let sut = makePresentable(
            textBox: textBox,
            axis: .horizontal,
            placeholder: "Placeholder"
        )
        let coordinator = sut.makeCoordinator()
        let uiTextField = UITextField()
        uiTextField.text = "Hello"
        
        coordinator.textFieldDidChange(uiTextField)
        
        #expect(textBox.text == "Hello")
    }
    
    @Test("coordinator는 UITextView 변경을 binding에 반영한다")
    func coordinator_textViewDidChange_updatesBinding() {
        let textBox = TextBox()
        let sut = makePresentable(
            textBox: textBox,
            axis: .vertical,
            placeholder: "Placeholder"
        )
        let coordinator = sut.makeCoordinator()
        let uiTextView = UITextView()
        uiTextView.text = "Multiline"
        
        coordinator.textViewDidChange(uiTextView)
        
        #expect(textBox.text == "Multiline")
    }
    
    @Test("coordinator는 UITextField focus 상태를 binding에 반영한다")
    func coordinator_textFieldFocus_updatesBinding() {
        let focusBox = BoolBox()
        let sut = makePresentable(
            textBox: TextBox(),
            axis: .horizontal,
            placeholder: "",
            focusBinding: focusBox.binding
        )
        let coordinator = sut.makeCoordinator()
        let uiTextField = UITextField()
        
        coordinator.textFieldDidBeginEditing(uiTextField)
        #expect(focusBox.value == true)
        
        coordinator.textFieldDidEndEditing(uiTextField)
        #expect(focusBox.value == false)
    }
    
    @Test("coordinator는 UITextView placeholder를 적용한다")
    func coordinator_applyPlaceholderIfNeeded_setsPlaceholder() {
        let textBox = TextBox()
        let sut = makePresentable(
            textBox: textBox,
            axis: .vertical,
            placeholder: "Placeholder"
        )
        let coordinator = sut.makeCoordinator()
        let container = SKTextFieldContainer(axis: .vertical)
        
        coordinator.applyConfiguration(to: container)
        
        #expect(container.uiTextView?.text == "Placeholder")
        #expect(container.uiTextView?.textColor == .placeholderText)
    }
    
    @Test("coordinator는 accessibilityLabel을 UIKit view에 반영한다")
    func coordinator_applyConfiguration_updatesAccessibilityLabel() {
        let sut = makePresentable(
            textBox: TextBox(),
            axis: .horizontal,
            placeholder: "",
            accessibilityLabel: "Sample Label"
        )
        let coordinator = sut.makeCoordinator()
        let container = SKTextFieldContainer(axis: .horizontal)
        
        coordinator.applyConfiguration(to: container)
        
        #expect(container.uiTextField?.accessibilityLabel == "Sample Label")
    }
}

private extension SKTextFieldTests {
    enum SampleField: Hashable, ExpressibleByNilLiteral {
        case plain
        
        init(nilLiteral: ()) {
            self = .plain
        }
    }
    
    final class TextBox: @unchecked Sendable {
        var text = ""
    }
    
    final class BoolBox: @unchecked Sendable {
        var value = false
        
        var binding: Binding<Bool> {
            Binding(
                get: { self.value },
                set: { self.value = $0 }
            )
        }
    }
    
    func makePresentable(
        textBox: TextBox,
        axis: Axis,
        placeholder: String,
        accessibilityLabel: String? = nil,
        focusBinding: Binding<Bool>? = nil
    ) -> SKTextFieldPresentable {
        SKTextFieldPresentable(
            text: Binding(
                get: { textBox.text },
                set: { textBox.text = $0 }
            ),
            axis: axis,
            placeholder: placeholder,
            accessibilityLabel: accessibilityLabel,
            focusBinding: focusBinding
        )
    }
}
