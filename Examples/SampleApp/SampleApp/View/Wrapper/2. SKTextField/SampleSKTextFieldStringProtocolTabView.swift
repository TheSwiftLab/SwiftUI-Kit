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
                Section("`.focused(_:)`") {
                    SampleSKTextFieldBlock(
                        text: $boolHorizontalText,
                        title: "한 줄 입력",
                        axisDescription: "한 줄 입력",
                        field: {
                            SKTextField(
                                "일반 문자열 제목",
                                text: $boolHorizontalText,
                                axis: .horizontal
                            )
                            .focused($horizontalBoolFocus)
                        }
                    )
                    
                    SampleSKTextFieldBlock(
                        text: $boolVerticalText,
                        title: "여러 줄 입력",
                        axisDescription: "여러 줄 입력",
                        field: {
                            SKTextField(
                                "일반 문자열 제목",
                                text: $boolVerticalText,
                                axis: .vertical
                            )
                            .focused($verticalBoolFocus)
                        }
                    )
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("한 줄 입력 포커스 상태: \(horizontalBoolFocus ? "활성" : "비활성")")
                        Text("여러 줄 입력 포커스 상태: \(verticalBoolFocus ? "활성" : "비활성")")
                    }
                    
                    SampleSKTextFieldActionButtonRow(
                        primaryTitle: "한 줄 입력 포커스",
                        primaryAction: {
                            horizontalBoolFocus = true
                        },
                        secondaryTitle: "여러 줄 입력 포커스",
                        secondaryAction: {
                            verticalBoolFocus = true
                        }
                    )
                    
                    Button("포커스 해제") {
                        horizontalBoolFocus = false
                        verticalBoolFocus = false
                    }
                }
                
                Section("`.focused(_:equals:)`") {
                    SampleSKTextFieldBlock(
                        text: $equalsHorizontalText,
                        title: "한 줄 입력",
                        axisDescription: "값 비교 포커스 / 한 줄 입력",
                        field: {
                            SKTextField(
                                "일반 문자열 제목",
                                text: $equalsHorizontalText,
                                axis: .horizontal
                            )
                            .focused($focusedField, equals: .singleLine)
                        }
                    )
                    
                    SampleSKTextFieldBlock(
                        text: $equalsVerticalText,
                        title: "여러 줄 입력",
                        axisDescription: "값 비교 포커스 / 여러 줄 입력",
                        field: {
                            SKTextField(
                                "일반 문자열 제목",
                                text: $equalsVerticalText,
                                axis: .vertical
                            )
                            .focused($focusedField, equals: .multiLine)
                        }
                    )
                    
                    Text("현재 포커스 값: \(focusLabel)")
                    
                    SampleSKTextFieldActionButtonRow(
                        primaryTitle: "한 줄 입력 포커스",
                        primaryAction: {
                            focusedField = .singleLine
                        },
                        secondaryTitle: "여러 줄 입력 포커스",
                        secondaryAction: {
                            focusedField = .multiLine
                        }
                    )
                    
                    Button("포커스 해제") {
                        focusedField = nil
                    }
                }
            }
            .navigationTitle("일반 문자열")
        }
    }
    
    private var focusLabel: String {
        switch focusedField {
        case .singleLine:
            return ".singleLine"
        case .multiLine:
            return ".multiLine"
        case nil:
            return "nil"
        }
    }
}
