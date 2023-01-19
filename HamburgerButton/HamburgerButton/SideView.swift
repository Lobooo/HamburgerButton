//
//  SwiftUIView.swift
//  HamburgerToArrow
//
//  Created by Lobo on 2022/10/8.
//

import SwiftUI

struct SideView: View {
    var body: some View {
        List {
            ForEach(0 ..< 10){ index in
                Text("666\(index)")
            }
        }.listStyle(.insetGrouped)
    }
}

struct SideView_Previews: PreviewProvider {
    static var previews: some View {
        SideView()
    }
}
