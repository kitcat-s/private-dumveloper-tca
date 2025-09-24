//
//  EditEmailReducer.swift
//  DumveloperTCA
//
//  Created by Kitcat Seo on 9/21/25.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct EditEmailReducer {
    struct State {
        var email: String
    }
    
    enum Action {
    }
}

struct EditEmailView: View {
    @Bindable var store: StoreOf<EditEmailReducer>
    
    var body: some View {
        Text("EditEmailView")
    }
}
