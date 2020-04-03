//
//  CardBackground.swift
//  iMeet
//
//  Created by dominator on 31/03/20.
//  Copyright © 2020 dominator. All rights reserved.
//

import SwiftUI

struct CardBackground: ViewModifier{
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    let color: Color?
    
    init(color: Color? = nil) {
        self.color = color
    }
    func body(content: Content) -> some View {
        content
        .padding()
        .frame(minWidth: 0, maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(color ?? (colorScheme == ColorScheme.dark ? Color.black : Color.white))
            .shadow(radius: 8)
            
        )
            .padding(.horizontal)
            .padding(.vertical, 5)
    }
}

extension View{
    func backgroundCard()-> some View{
        self.modifier(CardBackground())
    }
    func backgroundCard(color: Color) -> some View{
        self.modifier(CardBackground(color: color))
    }
}

struct CardBackground_Previews: PreviewProvider {
    static var previews: some View{
        Text("some text").backgroundCard()
    }
}
