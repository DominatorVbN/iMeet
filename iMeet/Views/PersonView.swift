//
//  PersonView.swift
//  iMeet
//
//  Created by dominator on 31/03/20.
//  Copyright © 2020 dominator. All rights reserved.
//

import SwiftUI

struct PersonView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme

    let person: Person
    var body: some View {
        ScrollView{
            VStack{
                    if person.profileImage != nil{
                        ZStack{
                            Image(uiImage: person.profileImage!)
                                .resizable()
                                .scaledToFill()
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .frame(height: 300)
                                .blur(radius: 10)
                                .clipped()
                                .scaleEffect(1.1)
                            Image(uiImage: person.profileImage!)
                                .resizable()
                                .frame(width: 200, height: 200)
                            .clipShape(Circle())
                                .overlay(Circle().stroke(Color.accentColor))
                        }
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .shadow(radius: 5)
                    .padding()
                    }
                
                HStack{
                    VStack(alignment: .leading) {
                        Text(person.name)
                            .font(.largeTitle)
                            .bold()
                            .multilineTextAlignment(.leading)
                            
                        Text(person.description)
                            .lineLimit(nil)
                            .multilineTextAlignment(.leading)
                            
                        
                    }
                    Spacer()
                }
            .backgroundCard()
            }
        }
        .navigationBarTitle(person.name)
    }
}

struct PersonView_Previews: PreviewProvider {
    static var previews: some View {
        PersonView(person: Person(name: "Amit", description: "Best iOS Developer", profileImage: UIImage(systemName: "person")))
    }
}
