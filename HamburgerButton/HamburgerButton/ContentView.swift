//
//  ContentView.swift
//  HamburgerButton
//
//  Created by Lobo on 2023/1/19.
//

import SwiftUI

struct Message: Identifiable {
    var id = UUID()
    var name: String
}

struct ContentView: View {
    
    @Environment(\.colorScheme) var colorScheme
    var isLight: Bool { colorScheme == .light }
    @State var rightSide = false
    @State var leftSide = false
    @State var safeAreaTop: CGFloat = 0
    @State var displayWidth: CGFloat = 0
    @State var displayHeight: CGFloat = 0
    let duration: CGFloat = 0.25
    var Messages = [Message(name: "1"), Message(name: "2"), Message(name: "3"), Message(name: "4"), Message(name: "5"), Message(name: "6"), Message(name: "7"), Message(name: "8"), Message(name: "9"), Message(name: "10")]
    
    var body: some View {
        ZStack {
            NavigationStack {
                List{
                    ForEach(Messages) { Message in
                        HStack {
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .clipShape(Circle())
                                .overlay(Circle().stroke(.white, lineWidth: 1))
                                .shadow(radius: 3)
                                .foregroundColor(.blue)
                                .frame(maxWidth: 80, maxHeight: 80)
                            Spacer()
                            Text(Message.name).font(.system(size:20))
                        }
                    }
                }.frame(alignment: .center)
                .listStyle(InsetGroupedListStyle())
                .gesture(DragGesture(minimumDistance: 15, coordinateSpace: .global)
                    .onEnded { value in
                        let horizontalAmount = value.translation.width as CGFloat
                        let verticalAmount = value.translation.height as CGFloat
                        
                        if abs(horizontalAmount) > abs(verticalAmount) {
                            withAnimation(.timingCurve(0.4, 0.0, 0.2, 1.0, duration: duration)) {
                                if horizontalAmount < 0 { self.rightSide.toggle() } else { self.leftSide.toggle() }
                            }
                            //  print(horizontalAmount < 0 ? "left swipe" : "right swipe")
                        } else {
                            //  print(verticalAmount < 0 ? "up swipe" : "down swipe")
                        }
                    })
                .blur(radius: leftSide || rightSide ? 8 : 0.01)
                .navigationBarTitle("List", displayMode: .inline)
                .navigationBarItems(
                    leading: HamburgerButton_UIKit(color: isLight ? .black : .white, leftSide: $leftSide).contentShape(Rectangle())
                    .gesture(TapGesture().onEnded {
                        withAnimation(.timingCurve(0.4, 0.0, 0.2, 1.0, duration: duration)){ leftSide.toggle() }
                    })
                    , trailing: HamburgerButton_SwiftUI(arrow: $rightSide))
            }
            
            SideView()
                .frame(width: 0.7 * displayWidth)
                .padding(EdgeInsets(top: self.safeAreaTop - 2.5, leading: 0, bottom: 0, trailing: 0))
                .transition(.move(edge: .bottom))
                .offset(x: self.rightSide ? 0.15 * displayWidth : displayWidth)
                .gesture(DragGesture(minimumDistance: 15, coordinateSpace: .global)
                    .onEnded { value in
                        if abs(value.translation.width) > abs(value.translation.height) {
                            withAnimation(.timingCurve(0.4, 0.0, 0.2, 1.0, duration: duration)) { self.rightSide.toggle() }
                        }
                })
            
            SideView()
                .frame(width: 0.7 * displayWidth)
                .padding(EdgeInsets(top: self.safeAreaTop - 2.5, leading: 0, bottom: 0, trailing: 0))
                .transition(.move(edge: .bottom))
                .offset(x: self.leftSide ? -0.15 * displayWidth : -displayWidth)
                .gesture(DragGesture(minimumDistance: 15, coordinateSpace: .global)
                    .onEnded { value in
                        if abs(value.translation.width) > abs(value.translation.height) {
                            withAnimation(.timingCurve(0.4, 0.0, 0.2, 1.0, duration: duration)) { self.leftSide.toggle() }
                        }
                })
        }
        .overlay(GeometryReader { geo -> AnyView in
            DispatchQueue.main.async{
                self.displayWidth = geo.size.width
                self.displayHeight = geo.size.height
                self.safeAreaTop = geo.safeAreaInsets.top
            }
            return AnyView(EmptyView())
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



