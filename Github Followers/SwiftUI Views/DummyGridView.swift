//
//  DummyGridView.swift
//  Github Followers
//
//  Created by Rishab Sukumar on 9/11/24.
//

import SwiftUI

struct DummyGridView: View {
    let gridItemLayout = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: gridItemLayout) {
                ForEach(0..<100, id: \.self) { index in
                    VStack {
                        Image("avatar-placeholder")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 75, height: 75)
                        Text("Dummy Username")
                            .multilineTextAlignment(.center)
                    }
                }
            }
        }
    }
}

#Preview {
    DummyGridView()
}
