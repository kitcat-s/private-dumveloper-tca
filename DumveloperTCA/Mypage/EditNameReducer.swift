//
//  EditNameReducer.swift
//  DumveloperTCA
//
//  Created by Kitcat Seo on 9/21/25.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct EditNameReducer {
    @ObservableState
    struct State {
        var name: String
    }
    
    enum Action {
        case inputName(String)
        case clearText
        case onEditFailure(String)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .inputName(name):
                state.name = name
                return .none
            case .clearText:
                state.name = ""
                return .none
            case let .onEditFailure(message):
                print(message)
                return .none
            }
        }
    }
}

struct EditNameView: View {
    @Bindable var store: StoreOf<EditNameReducer>
    
    var body: some View {
        VStack {
            TextField("이름을 입력해주세요", text: $store.name.sending(\.inputName))
                .padding(.trailing, 32)
                .overlay(alignment: .trailing) {
                    if !store.name.isEmpty {
                        Button {
                            store.send(.clearText)
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(Color(.systemGray))
                        }
                    }
                }
                .submitLabel(.done)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .frame(height: 40)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .onSubmit {
                    editName(name: store.name)
                }
        }
        .navigationTitle("이름 변경")
        .padding(20)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    editName(name: store.name)
                } label: {
                    Text("저장")
                }
            }
        }
    }
    
    func editName(name: String) {
        guard !name.isEmpty else {
            store.send(.onEditFailure("이름이 입력되지 않았어요"))
            return
        }
    }
}
