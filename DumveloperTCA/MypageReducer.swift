//
//  MypageReducer.swift
//  DumveloperTCA
//
//  Created by Kitcat Seo on 9/21/25.
//

import ComposableArchitecture

@Reducer
struct MypageReducer {
    @ObservableState
    struct State {
        var userName: String = ""
        var userEmail: String = ""
    }
    
    enum Action {
        case onAppear(User)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .onAppear(user):
                state.userName = user.name
                state.userEmail = user.email
                return Effect.none
            }
        }
    }
}
