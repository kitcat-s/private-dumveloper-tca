//
//  EditEmailReducer.swift
//  DumveloperTCA
//
//  Created by Kitcat Seo on 9/21/25.
//

import ComposableArchitecture
import SwiftUI
import SwiftData

@Reducer
struct EditEmailReducer: Reducer {
    @ObservableState
    struct State {
        var email: String
        @Presents var alert: AlertState<Action.AlertAction>?
    }
    
    enum Action {
        case inputEmail(String)
        case clearText
        case onEditFailure(String)
        case onEditSuccess(String)
        case showAlert(String)
        case alert(PresentationAction<AlertAction>)
        
        enum AlertAction {
            
        }
    }
    
    var body: some Reducer<State, Action> {
        Reduce {
            state,
            action in
            switch action {
            case let .inputEmail(email):
                state.email = email
                return .none
            case .clearText:
                state.email = ""
                return .none
            case let .onEditFailure(message):
                return .send(.showAlert(message))
            case let .onEditSuccess(email):
                state.email = email
                return .none
            case let .showAlert(message):
                state.alert = .init(
                    title: { TextState("에러") },
                    actions: { ButtonState { TextState("확인") } },
                    message: { TextState(message) }
                )
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

struct EditEmailView: View {
    @Bindable var store: StoreOf<EditEmailReducer>

    @Environment(\.modelContext) var context
    @Query var users: [User]
    private var user: User? { users.first }
    
    var body: some View {
            VStack {
                TextField("이메일 주소를 입력해주세요", text: $store.email.sending(\.inputEmail))
                    .padding(.trailing, 32)
                    .overlay(alignment: .trailing) {
                        if !store.email.isEmpty {
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
                        editEmail(email: store.email)
                    }
            }
            .navigationTitle("이메일 변경")
            .padding(20)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        editEmail(email: store.email)
                    } label: {
                        Text("저장")
                    }
                }
            }
            .alert($store.scope(state: \.alert, action: \.alert))
    }
    
    private func editEmail(email: String) {
        guard !email.isEmpty else {
            store.send(.onEditFailure("이메일이 입력되지 않았어요"))
            return
        }
        
        user?.email = email
        
        do {
            try context.save()
            store.send(.onEditSuccess(email))
        } catch {
            store.send(.onEditFailure(error.localizedDescription))
        }
    }
}
