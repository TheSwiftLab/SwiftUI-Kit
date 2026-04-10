//
//  SampleSKTextFieldStringProtocolTabView.swift
//  SwiftUI-Kit
//
//  Created by opfic on 4/10/26.
//

import SwiftUI
import SwiftUI_Kit

struct SampleSKTextFieldStringProtocolTabView: View {
    @State private var boolHorizontalText = ""
    @State private var boolVerticalText = ""
    @State private var equalsHorizontalText = ""
    @State private var equalsVerticalText = ""
    
    @FocusState private var horizontalBoolFocus: Bool
    @FocusState private var verticalBoolFocus: Bool
    @FocusState private var focusedField: SampleSKTextFieldFocusField?
    
    var body: some View {
        NavigationStack {
            Form {
                SampleSKTextFieldBoolFocusSection(
                    horizontalText: $boolHorizontalText,
                    verticalText: $boolVerticalText,
                    sectionTitle: "`.focused(_:)`",
                    horizontalTitle: "한 줄 입력",
                    verticalTitle: "여러 줄 입력",
                    horizontalFocus: $horizontalBoolFocus,
                    verticalFocus: $verticalBoolFocus,
                    constructor: { text, axis in
                        SKTextField(
                            "일반 문자열 제목",
                            text: text,
                            axis: axis
                        )
                    }
                )
                
                SampleSKTextFieldEqualsFocusSection(
                    horizontalText: $equalsHorizontalText,
                    verticalText: $equalsVerticalText,
                    sectionTitle: "`.focused(_:equals:)`",
                    horizontalTitle: "한 줄 입력",
                    verticalTitle: "여러 줄 입력",
                    focus: $focusedField,
                    constructor: { text, axis in
                        SKTextField(
                            "일반 문자열 제목",
                            text: text,
                            axis: axis
                        )
                    }
                )
            }
            .navigationTitle("StringProtocol")
        }
    }
}
