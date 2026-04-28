//
//  SKTextFieldSubmitLabelTests.swift
//  SwiftUI-Kit
//
//  Created by opfic on 4/28/26.
//

import SwiftUI
import Testing
@testable import SwiftUI_Kit

@MainActor
struct SKTextFieldSubmitLabelTests {

    @Test("submitLabel은 모든 SubmitLabel 값을 UITextField returnKeyType으로 매핑한다")
    func submitLabel_mapsAllCasesToTextFieldReturnKeyType() throws {
        let cases = [
            (SubmitLabel.continue, UIReturnKeyType.continue),
            (.done, .done),
            (.go, .go),
            (.join, .join),
            (.next, .next),
            (.return, .default),
            (.route, .route),
            (.search, .search),
            (.send, .send)
        ]

        for (submitLabel, expectedReturnKeyType) in cases {
            let uiTextField = try makeTextField(
                rootView: SubmitLabelHorizontalHostView(
                    submitLabel: submitLabel
                )
            )

            #expect(uiTextField.returnKeyType == expectedReturnKeyType)
        }
    }

    @Test("submitLabel은 UITextView returnKeyType에 반영된다")
    func submitLabel_appliesToTextViewReturnKeyType() throws {
        let uiTextView = try makeTextView(
            rootView: SubmitLabelVerticalHostView(
                submitLabel: .search
            )
        )

        #expect(uiTextView.returnKeyType == .search)
    }
}

private extension SKTextFieldSubmitLabelTests {
    struct SubmitLabelHorizontalHostView: View {
        let submitLabel: SubmitLabel
        @State private var text = ""

        var body: some View {
            SKTextField(
                "Title",
                text: $text
            )
            .submitLabel(submitLabel)
        }
    }

    struct SubmitLabelVerticalHostView: View {
        let submitLabel: SubmitLabel
        @State private var text = ""

        var body: some View {
            SKTextField(
                "Title",
                text: $text,
                axis: .vertical
            )
            .submitLabel(submitLabel)
        }
    }

    func makeTextField<Content: View>(
        rootView: Content
    ) throws -> UITextField {
        let uiWindow = UIWindow(
            frame: UIScreen.main.bounds
        )
        let uiHostingController = UIHostingController(
            rootView: rootView
        )

        uiWindow.rootViewController = uiHostingController
        uiWindow.makeKeyAndVisible()
        runMainLoop()

        return try #require(findTextField(in: uiHostingController.view))
    }

    func makeTextView<Content: View>(
        rootView: Content
    ) throws -> UITextView {
        let uiWindow = UIWindow(
            frame: UIScreen.main.bounds
        )
        let uiHostingController = UIHostingController(
            rootView: rootView
        )

        uiWindow.rootViewController = uiHostingController
        uiWindow.makeKeyAndVisible()
        runMainLoop()

        return try #require(findTextView(in: uiHostingController.view))
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
