//
//  EditNameReducer.swift
//  DumveloperTCA
//
//  Created by Kitcat Seo on 9/21/25.
//

import ComposableArchitecture
import SwiftUI
import SwiftData

@Reducer
struct EditNameReducer {
    @ObservableState
    struct State {
        var name: String
        @Presents var alert: AlertState<Action.AlertAction>?
    }
    
    enum Action {
        case inputName(String)
        case clearText
        case onEditFailure(String)
        case onEditSuccess(String)
        case showAlert(String)
        case alert(PresentationAction<AlertAction>)
        
        enum AlertAction {
            
        }
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
                return .send(.showAlert(message))
            case let .showAlert(message):
                state.alert = .init(title: {
                    TextState("에러")
                }, actions: {
                    ButtonState {
                        TextState("확인")
                    }
                }, message: {
                    TextState(message)
                })
                return .none
            case let .onEditSuccess(name):
                print(name)
                return .none
            case let .alert(presentationAction):
                switch presentationAction {
                case let .presented(action):
                    print(action)
                    return .none
                case .dismiss:
                    return .none
                }
            }
        }
        .ifLet(\.$alert, action: \.alert)
    }
}

struct EditNameView: View {
    @Bindable var store: StoreOf<EditNameReducer>
    @Environment(\.modelContext) private var context
    @Query private var users: [User]
    private var user: User? { users.first }
    
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
        .alert($store.scope(state: \.alert, action: \.alert))
    }
    
    func editName(name: String) {
        guard !name.isEmpty else {
            store.send(.onEditFailure("이름이 입력되지 않았어요"))
            return
        }
        
        user?.name = name
        
        do {
            try context.save()
            store.send(.onEditSuccess(name))
        } catch let error {
            store.send(.onEditFailure("저장에 실패했어요: \(error)"))
        }
    }
}
