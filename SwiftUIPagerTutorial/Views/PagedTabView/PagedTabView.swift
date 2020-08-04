//
//  PagedTabView.swift
//  SwiftUIPagerTutorial
//
//  Created by Fernando Moya de Rivas on 03/08/2020.
//

import SwiftUI

struct PagedTabView: View {

    let data = Array(1...10)

    var body: some View {
        TabView {
            ForEach(data, id: \.self) { index in
                VStack(alignment: .leading) {
                    Text(loremIpsum)
                    Spacer()
                    HStack {
                        Spacer()
                        Text("Page \(index)")
                            .font(.footnote)
                            .foregroundColor(Color.gray)
                    }
                }
                .tag(index)
                .padding()
            }
        }
        .tabViewStyle(PageTabViewStyle())
        .foregroundColor(Color.black)
    }

}

struct PagedTabView_Previews: PreviewProvider {
    static var previews: some View {
        PagedTabView()
            .previewDevice(.init(stringLiteral: "iPhone 11"))
            .environment(\.sizeCategory, .extraExtraExtraLarge)
    }
}
