//
//  AddMeetView.swift
//  iMeet
//
//  Created by dominator on 31/03/20.
//  Copyright © 2020 dominator. All rights reserved.
//

import SwiftUI


struct AddMeetView: View {
    @EnvironmentObject var manager: PersonManager
    @State private var person: Person = Person(name: "", description: "")
    @Environment(\.presentationMode) var presentationMode
    @State private var isShowingPicker = false
    var body: some View {
        let imageBinding = Binding<UIImage?>(get: {
            self.person.profileImage
        }, set: {
            self.person.profileImage = $0
        })
        return NavigationView{
            ScrollView {
                VStack(spacing: 10){
                    VStack {
                        Button(action: {
                            self.isShowingPicker = true
                        }) {
                            if  person.profileImage != nil{
                                ZStack {
                                    Image(uiImage: person.profileImage!)
                                    .resizable()
                                        .mask(Circle())
                                    .blur(radius: 10)
                                        .offset(x: 0, y: 5)
                                    Image(uiImage: person.profileImage!)
                                        .resizable()
                                        .mask(Circle())
                                    
                                }
                            }else{
                                Image(systemName: "person.crop.circle.fill.badge.plus")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(Color.accentColor)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                        .frame(width: 100, height: 100)
                        VStack{
                            if !person.name.isEmpty{
                                Text(person.name).font(.title)
                            }
                            if !person.description.isEmpty{
                                Text(person.description).font(.caption)
                                
                            }
                        }
                        .padding(.horizontal, 50)
                    }
                    .backgroundCard()
                    VStack{
                        TextField("Name", text: $person.name)
                            .backgroundCard()
                        TextField("Description", text: $person.description)
                            .backgroundCard()
                    }
                }
                .padding(.vertical)
            }
            .navigationBarTitle("Add meet", displayMode: .inline)
            .navigationBarItems(trailing:
                Button(action: {
                    self.manager.savePerson(person: self.person)
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Save")
                })
            )
                .sheet(isPresented: $isShowingPicker) {
                    ImagePicker(image: imageBinding)
            }
        }
    }
}

struct AddMeetView_Previews: PreviewProvider {
    static var previews: some View {
        AddMeetView()
    }
}
