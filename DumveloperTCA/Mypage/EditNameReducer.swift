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
    struct State {
    }
    
    enum Action {
    }
}

struct EditNameView: View {
    @Bindable var store: StoreOf<EditNameReducer>
    
    var body: some View {
        Text("EditNameView")
    }
}
