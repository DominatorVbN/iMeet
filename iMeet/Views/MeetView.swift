//
//  MeetView.swift
//  iMeet
//
//  Created by dominator on 31/03/20.
//  Copyright © 2020 dominator. All rights reserved.
//

import SwiftUI

struct MeetView: View {
    @EnvironmentObject var manager: PersonManager
    @State var isShowingAdd = false
    var body: some View {
        NavigationView{
            Group{
                if !(manager.persons.count > 0){
                    VStack(spacing: 30){
                        Text("No peoples around!")
                            .font(.title)
                            .bold()
                            .foregroundColor(.secondary)
                        Button(action: {
                            self.isShowingAdd = true
                        }) {
                            Text("Add peoples")
                        }
                        .padding(.horizontal)
                        .padding(.vertical,5)
                        .foregroundColor(.white)
                        .background(Capsule().fill(Color.accentColor))
                        .shadow(radius: 8)
                    }
                }else{
                    List {
                        ForEach(manager.persons){ person in
                            NavigationLink(destination: PersonView(person: person)) {
                                if person.profileImage != nil{
                                    Image(uiImage: person.profileImage!)
                                        .resizable()
                                        .scaledToFit()
                                        .mask(Circle())
                                        .frame(width: 50, height: 50)
                                }
                                VStack(alignment: .leading) {
                                    Text(person.name)
                                    Text(person.description)
                                        .font(.caption)
                                }
                                Spacer()
                            }
                        }
                        .onDelete(perform: manager.deletePerson(indexset:))
                        .onMove(perform: manager.movePerson(indexset:offset:))
                    }
                }
            }
            .navigationBarTitle("iMet")
            .navigationBarItems(leading: EditButton(), trailing:
                Button(action: {
                    self.isShowingAdd = true
                }, label: {
                    Text("Add people")
                })
            )
                .sheet(isPresented: $isShowingAdd, content: {AddMeetView().environmentObject(self.manager)})
                .onAppear(perform: manager.fetchPersons)
        }
    }
}

struct MeetView_Previews: PreviewProvider {
    static var previews: some View {
        MeetView().environmentObject(PersonManager())
    }
}
