//
//  EditImageReducer.swift
//  DumveloperTCA
//
//  Created by Kitcat Seo on 9/21/25.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct EditImageReducer {
    struct State {
    }
    
    enum Action {
    }
}

struct EditImageView: View {
    @Bindable var store: StoreOf<EditImageReducer>
    
    var body: some View {
        Text("EditImageView")
    }
}
