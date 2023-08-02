//
//  PersonalInfoViewModel.swift
//  Personalnfo
//
//  Created by Мария Газизова on 01.08.2023.
//

import Foundation

class PersonalInfoViewModel {
    var person = PersonModel()
    
    var onReloadView: (() -> Void)?
    var onTooManyChildrenAction: (() -> Void)?
    var onFreeChildrenAction: (() -> Void)?
    var onClear: (() -> Void)?
    
    init() {
        person.childrenArray.append(ChildModel())
    }
    
    func addChild() {
        guard person.childrenArray.count < 5 else { return }
        person.childrenArray.append(ChildModel())
        
        if person.childrenArray.count == 5 {
            onTooManyChildrenAction?()
        }
        
        onReloadView?()
    }
    
    func deleteChild(at index: Int) {
        guard person.childrenArray.count > 1 else {
            person.childrenArray = [ChildModel()]
            onReloadView?()
            return
        }
        
        person.childrenArray.remove(at: index)
        
        if person.childrenArray.count == 4 {
            onFreeChildrenAction?()
        }
        
        onReloadView?()
    }
    
    func setPersonsName(_ name: String?) {
        person.name = name ?? ""
    }
    
    func setPersonsAge(_ age: String?) {
        guard let age,
              let ageInt = Int(age),
              ageInt < 200 else {
            return
        }
        
        person.age = ageInt
    }
    
    func setName(_ name: String?, for index: Int) {
        person.childrenArray[index].name = name
    }
    
    func setAge(_ age: String?, for index: Int) {
        guard let age,
              let ageInt = Int(age),
              ageInt < 200 else {
            return
        }
        
        person.childrenArray[index].age = ageInt
    }
    
    func clear() {
        person.childrenArray = [ChildModel()]
        onFreeChildrenAction?()
        onReloadView?()
        onClear?()
    }
}
