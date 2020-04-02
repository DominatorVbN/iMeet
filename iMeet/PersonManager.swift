//
//  PersonManager.swift
//  iMeet
//
//  Created by dominator on 31/03/20.
//  Copyright © 2020 dominator. All rights reserved.
//

import Foundation

class PersonManager: ObservableObject {
    @Published var persons: [Person] = []
    
    lazy private var urlToPersons: URL = {
        let docURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return docURL.appendingPathComponent("Persons")
    }()
    
    func fetchPersons(){
        if let data = try? Data(contentsOf: urlToPersons){
            self.persons = (try? JSONDecoder().decode([Person].self, from: data)) ?? []
        }
    }
    
    func savePerson(person: Person) {
        self.persons.append(person)
        saveState()
    }
    
    func saveState(){
        if let data = try? JSONEncoder().encode(persons) {
            try? data.write(to: urlToPersons)
        }
    }
    
    func deletePerson(indexset: IndexSet){
        persons.remove(atOffsets: indexset)
        saveState()
    }
    
    func movePerson(indexset: IndexSet, offset: Int){
        persons.move(fromOffsets: indexset, toOffset: offset)
        saveState()
    }
}
