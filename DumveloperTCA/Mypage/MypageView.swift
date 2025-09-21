//
//  MypageView.swift
//  DumveloperTCA
//
//  Created by Kitcat Seo on 9/19/25.
//

import SwiftUI
import Alamofire
import ComposableArchitecture
import SwiftData

enum MypageItem: CaseIterable {
    case name
    case email
    case image
    
    var title: String {
        switch self {
        case .name: "이름"
        case .email: "이메일"
        case .image: "프로필 이미지"
        }
    }
}

struct MypageView: View {
    @Query var users: [User]
    @Bindable var store: StoreOf<MypageReducer>
    
    var firstUser: User? {
        users.first
    }
    
    var body: some View {
        NavigationStackStore(store.scope(state: \.path, action: \.path)) {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack {
                    ForEach(MypageItem.allCases, id: \.self) { item in
                        listItems(item: item)
                    }
                }
                .padding(.horizontal)
            }
            .onAppear {
                guard let firstUser else { return }
                store.send(.onAppear(firstUser))
            }
        } destination: { store in
            switch store.state {
            case let .name(state):
                if let store = store.scope(state: \.name, action: \.name) {
                    EditNameView(store: store)
                }
            case let .email(state):
                EmptyView()
            case let .image(state):
                EmptyView()
            @unknown default:
                EmptyView()
            }
        }
    }
    
    func listItems(item: MypageItem) -> some View {
        Button {
            store.send(.tapItem(item))
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.title)
                        .font(.headline)
                        .foregroundStyle(.white)
                    
                    Text(firstUser?.name ?? "")
                        .font(.body)
                        .foregroundStyle(Color(.lightGray))
                }
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .background(Color(.darkGray).opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    MypageView(
        store: Store(
            initialState: MypageReducer.State(),
            reducer: { MypageReducer() }
        )
    )
}
