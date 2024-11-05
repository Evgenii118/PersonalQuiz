//
//  ResultViewController.swift
//  PersonalQuiz
//
//  Created by Ewgeniy Izyurov on 17.10.2024.
//

import UIKit

final class ResultViewController: UIViewController {
    
    @IBOutlet var animalLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    var answersUser: [Answer] = []
    var answersUserForTypeAndCount: [Animal: Int] = [:]
    var animalForUser = Animal(rawValue: "🐙")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.setHidesBackButton(true, animated: false)
        
        getAnimalForUser()
        
        animalLabel.text = "Вы - \(animalForUser?.rawValue ?? Animal.cat.rawValue)"
        descriptionLabel.text = "\(animalForUser?.definition ?? Animal.cat.definition)"
        
    }
    
    
    
    @IBAction func doneButtonAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    deinit {
        print("\(type(of: self)) has been deallocated")
    }
    
    private func getAnimalForUser() {
        for answerChoose in answersUser {
            answersUserForTypeAndCount[answerChoose.animal, default: 0] += 1
        }
        
        let maximumValue = answersUserForTypeAndCount.values.max()!
        
        for answer in answersUserForTypeAndCount {
            if answer.value == maximumValue {
                animalForUser = answer.key
            }
        }
    }
    
}
