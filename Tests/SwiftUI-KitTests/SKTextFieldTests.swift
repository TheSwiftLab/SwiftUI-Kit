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
        let expectedTitle = Bundle.main.localizedString(
            forKey: "sample_title",
            value: "sample_title",
            table: nil
        )
        let uiTextField = makeTextField(
            rootView: SKTextField(
                LocalizedStringKey("sample_title"),
                text: .constant("")
            )
        )
        
        #expect(uiTextField.attributedPlaceholder?.string == expectedTitle)
        #expect(uiTextField.accessibilityLabel == expectedTitle)
    }
    
    @Test("LocalizedStringResource 생성자는 기본 구성이 가능하다")
    func localizedStringResourceInit_defaultConfiguration() throws {
        guard #available(iOS 16.0, *) else {
            return
        }
        
        let expectedTitle = String(
            localized: LocalizedStringResource("sample_title")
        )
        let uiTextField = makeTextField(
            rootView: SKTextField(
                LocalizedStringResource("sample_title"),
                text: .constant("")
            )
        )
        
        #expect(uiTextField.attributedPlaceholder?.string == expectedTitle)
        #expect(uiTextField.accessibilityLabel == expectedTitle)
    }
    
    @Test("StringProtocol 생성자는 기본 구성이 가능하다")
    func stringProtocolInit_defaultConfiguration() {
        let uiTextField = makeTextField(
            rootView: SKTextField(
                "Plain Title",
                text: .constant("")
            )
        )
        
        #expect(uiTextField.attributedPlaceholder?.string == "Plain Title")
        #expect(uiTextField.accessibilityLabel == "Plain Title")
    }
    
    @Test("focused(_:)는 Bool FocusState와 조합된다")
    func focused_bindBoolFocusState() {
        let boolFocusModel = BoolFocusModel()
        let uiTextField = makeTextField(
            rootView: BoolFocusHostView(
                boolFocusModel: boolFocusModel
            )
        )
        
        boolFocusModel.shouldFocus = true
        runMainLoop()
        #expect(uiTextField.isFirstResponder == true)
        
        boolFocusModel.shouldFocus = false
        runMainLoop()
        #expect(uiTextField.isFirstResponder == false)
    }
    
    @Test("focused(_:equals:)는 optional FocusState와 조합된다")
    func focused_bindOptionalFocusState() {
        let valueFocusModel = ValueFocusModel()
        let uiTextField = makeTextField(
            rootView: ValueFocusHostView(
                valueFocusModel: valueFocusModel
            )
        )
        
        valueFocusModel.focusedField = .plain
        runMainLoop()
        #expect(uiTextField.isFirstResponder == true)
        
        valueFocusModel.focusedField = nil
        runMainLoop()
        #expect(uiTextField.isFirstResponder == false)
    }
    
    @Test("horizontal SKTextField는 UITextField를 렌더링하고 바인딩 값을 반영한다")
    func horizontalTextField_rendersUIKitTextField() {
        let textModel = TextModel()
        let uiTextField = makeTextField(
            rootView: HorizontalTextHostView(
                textModel: textModel,
                title: "Placeholder"
            )
        )
        
        #expect(uiTextField.attributedPlaceholder?.string == "Placeholder")
        #expect(uiTextField.accessibilityLabel == "Placeholder")
        
        textModel.text = "Hello"
        runMainLoop()
        
        #expect(uiTextField.text == "Hello")
    }
    
    @Test("vertical SKTextField는 UITextView를 렌더링하고 placeholder를 표시한다")
    func verticalTextField_rendersUIKitTextView() {
        let textModel = TextModel()
        let uiTextView = makeTextView(
            rootView: VerticalTextHostView(
                textModel: textModel,
                title: "Placeholder"
            )
        )
        
        #expect(uiTextView.text == "Placeholder")
        #expect(uiTextView.textColor == .placeholderText)
        #expect(uiTextView.accessibilityLabel == "Placeholder")
        
        textModel.text = "Multiline"
        runMainLoop()
        
        #expect(uiTextView.text == "Multiline")
        #expect(uiTextView.textColor == .label)
    }

    @Test("onSubmit은 horizontal SKTextField 제출 시 실행된다")
    func onSubmit_horizontalTextField() {
        let submitModel = SubmitModel()
        let uiTextField = makeTextField(
            rootView: SubmitHorizontalHostView(
                submitModel: submitModel
            )
        )

        _ = uiTextField.delegate?.textFieldShouldReturn?(uiTextField)

        #expect(submitModel.submitCount == 1)
    }

    @Test("onSubmit은 vertical SKTextField 제출 시 실행된다")
    func onSubmit_verticalTextView() {
        let submitModel = SubmitModel()
        let uiTextView = makeTextView(
            rootView: SubmitVerticalHostView(
                submitModel: submitModel
            )
        )

        let shouldChange = uiTextView.delegate?.textView?(
            uiTextView,
            shouldChangeTextIn: NSRange(location: 0, length: 0),
            replacementText: "\n"
        )

        #expect(shouldChange == false)
        #expect(submitModel.submitCount == 1)
    }
}

private extension SKTextFieldTests {
    enum SampleField: Hashable {
        case plain
    }
    
    @MainActor
    final class BoolFocusModel: ObservableObject {
        @Published var shouldFocus = false
    }
    
    @MainActor
    final class ValueFocusModel: ObservableObject {
        @Published var focusedField: SampleField?
    }
    
    @MainActor
    final class TextModel: ObservableObject {
        @Published var text = ""
    }

    @MainActor
    final class SubmitModel: ObservableObject {
        @Published var submitCount = 0
    }
    
    struct BoolFocusHostView: View {
        @ObservedObject var boolFocusModel: BoolFocusModel
        @State private var text = ""
        @FocusState private var isFocused: Bool
        
        var body: some View {
            SKTextField(
                "Title",
                text: $text
            )
            .focused($isFocused)
            .onAppear {
                isFocused = boolFocusModel.shouldFocus
            }
            .onChange(of: boolFocusModel.shouldFocus) { newValue in
                isFocused = newValue
            }
        }
    }
    
    struct ValueFocusHostView: View {
        @ObservedObject var valueFocusModel: ValueFocusModel
        @State private var text = ""
        @FocusState private var focusedField: SampleField?
        
        var body: some View {
            SKTextField(
                "Title",
                text: $text
            )
            .focused($focusedField, equals: .plain)
            .onAppear {
                focusedField = valueFocusModel.focusedField
            }
            .onChange(of: valueFocusModel.focusedField) { newValue in
                focusedField = newValue
            }
        }
    }
    
    struct HorizontalTextHostView: View {
        @ObservedObject var textModel: TextModel
        let title: String
        
        var body: some View {
            SKTextField(
                title,
                text: Binding(
                    get: { textModel.text },
                    set: { textModel.text = $0 }
                )
            )
        }
    }
    
    struct VerticalTextHostView: View {
        @ObservedObject var textModel: TextModel
        let title: String
        
        var body: some View {
            SKTextField(
                title,
                text: Binding(
                    get: { textModel.text },
                    set: { textModel.text = $0 }
                ),
                axis: .vertical
            )
        }
    }

    struct SubmitHorizontalHostView: View {
        @ObservedObject var submitModel: SubmitModel
        @State private var text = ""

        var body: some View {
            SKTextField(
                "Title",
                text: $text
            )
            .onSubmit {
                submitModel.submitCount += 1
            }
        }
    }

    struct SubmitVerticalHostView: View {
        @ObservedObject var submitModel: SubmitModel
        @State private var text = ""

        var body: some View {
            SKTextField(
                "Title",
                text: $text,
                axis: .vertical
            )
            .onSubmit {
                submitModel.submitCount += 1
            }
        }
    }
    
    func makeTextField<Content: View>(
        rootView: Content
    ) -> UITextField {
        let uiWindow = UIWindow(
            frame: UIScreen.main.bounds
        )
        let uiHostingController = UIHostingController(
            rootView: rootView
        )
        
        uiWindow.rootViewController = uiHostingController
        uiWindow.makeKeyAndVisible()
        runMainLoop()
        
        return findTextField(in: uiHostingController.view)
        ?? UITextField()
    }
    
    func makeTextView<Content: View>(
        rootView: Content
    ) -> UITextView {
        let uiWindow = UIWindow(
            frame: UIScreen.main.bounds
        )
        let uiHostingController = UIHostingController(
            rootView: rootView
        )
        
        uiWindow.rootViewController = uiHostingController
        uiWindow.makeKeyAndVisible()
        runMainLoop()
        
        return findTextView(in: uiHostingController.view)
        ?? UITextView()
    }
    
    func findTextField(in view: UIView) -> UITextField? {
        if let uiTextField = view as? UITextField {
            return uiTextField
        }
        
        for subview in view.subviews {
            if let uiTextField = findTextField(in: subview) {
                return uiTextField
            }
        }
        
        return nil
    }
    
    func findTextView(in view: UIView) -> UITextView? {
        if let uiTextView = view as? UITextView {
            return uiTextView
        }
        
        for subview in view.subviews {
            if let uiTextView = findTextView(in: subview) {
                return uiTextView
            }
        }
        
        return nil
    }
    
    func runMainLoop() {
        for _ in 0..<5 {
            RunLoop.main.run(
                until: Date().addingTimeInterval(0.01)
            )
        }
    }
}
