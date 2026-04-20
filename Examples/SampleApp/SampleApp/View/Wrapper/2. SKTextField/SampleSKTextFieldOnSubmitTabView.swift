//
//  SampleSKTextFieldOnSubmitTabView.swift
//  SwiftUI-Kit
//
//  Created by opfic on 4/20/26.
//

import SwiftUI
import SwiftUI_Kit

struct SampleSKTextFieldOnSubmitTabView: View {
    @State private var singleLineText = ""
    @State private var multiLineText = ""
    @State private var submittedSingleLineText = ""
    @State private var submittedMultiLineText = ""
    @State private var singleLineSubmitCount = 0
    @State private var multiLineSubmitCount = 0

    var body: some View {
        NavigationStack {
            Form {
                Section("한 줄 입력") {
                    SampleSKTextFieldBlock(
                        text: $singleLineText,
                        title: "한 줄 입력",
                        axisDescription: "return 키 입력 시 onSubmit 실행",
                        field: {
                            SKTextField(
                                "메시지를 입력해 주세요",
                                text: $singleLineText,
                                axis: .horizontal
                            )
                            .onSubmit {
                                submitSingleLineText()
                            }
                        }
                    )

                    SampleSKTextFieldSubmitSummary(
                        submittedText: submittedSingleLineText,
                        submitCount: singleLineSubmitCount
                    )

                    Button("상태 초기화") {
                        resetSingleLineSubmitState()
                    }
                }

                Section("여러 줄 입력") {
                    SampleSKTextFieldBlock(
                        text: $multiLineText,
                        title: "여러 줄 입력",
                        axisDescription: "하드웨어 키보드 Return은 onSubmit, 소프트웨어 키보드 Return은 줄바꿈",
                        field: {
                            SKTextField(
                                "메시지를 입력해 주세요",
                                text: $multiLineText,
                                axis: .vertical
                            )
                            .onSubmit {
                                submitMultiLineText()
                            }
                        }
                    )

                    SampleSKTextFieldSubmitSummary(
                        submittedText: submittedMultiLineText,
                        submitCount: multiLineSubmitCount
                    )

                    Button("상태 초기화") {
                        resetMultiLineSubmitState()
                    }
                }
            }
            .navigationTitle("onSubmit")
        }
    }

    private func submitSingleLineText() {
        submittedSingleLineText = singleLineText
        singleLineSubmitCount += 1
    }

    private func submitMultiLineText() {
        submittedMultiLineText = multiLineText
        multiLineSubmitCount += 1
    }

    private func resetSingleLineSubmitState() {
        submittedSingleLineText = ""
        singleLineSubmitCount = 0
    }

    private func resetMultiLineSubmitState() {
        submittedMultiLineText = ""
        multiLineSubmitCount = 0
    }
}

private struct SampleSKTextFieldSubmitSummary: View {
    let submittedText: String
    let submitCount: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("마지막 제출 값: \(submittedLabel)")
            Text("제출 횟수: \(submitCount)")
        }
        .font(.caption)
        .foregroundStyle(.secondary)
    }

    private var submittedLabel: String {
        if submittedText.isEmpty {
            return "없음"
        }

        return submittedText
    }
}
