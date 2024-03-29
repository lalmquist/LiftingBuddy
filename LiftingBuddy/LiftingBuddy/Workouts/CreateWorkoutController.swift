//
//  CreateWorkoutController.swift
//  LiftingBuddy
//
//  Created by Logman on 6/2/19.
//  Copyright © 2019 Logman. All rights reserved.
//

import UIKit
import CoreData

protocol CreateWorkoutControllerDelegate {
    func didAddWorkout(workout: Workout)
    func didEditWorkout(workout: Workout)
}

class CreateWorkoutController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var workout: Workout? {
        didSet {
            nameTextField.text = workout?.name
            
            guard let founded = workout?.date else { return }
            
            datePicker.date = founded
        }
    }

    var delegate: CreateWorkoutControllerDelegate?

    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "   Name"
        label.textColor = .black
        label.backgroundColor = .white
        //enable autolayout
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .black
        textField.placeholder = "Enter name"

        textField.backgroundColor = .white
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let datePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.backgroundColor = .white
        dp.datePickerMode = .dateAndTime
        dp.setValue(UIColor.black, forKeyPath: "textColor")
        dp.translatesAutoresizingMaskIntoConstraints = false
        return dp
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = workout == nil ? "Create Workout" : "Edit Workout"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        setupCancelButton()
        
        UINavigationBar.appearance().barTintColor = .darkPurple
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
        
        view.backgroundColor = UIColor.black
    }
    
    @objc private func handleSave() {
        if workout == nil {
            createWorkout()
        } else {
            saveWorkoutChanges()
        }
    }
    
    private func saveWorkoutChanges() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        workout?.name = nameTextField.text
        workout?.date = datePicker.date
        
        do {
            try context.save()
            
            dismiss(animated: true, completion: {
                self.delegate?.didEditWorkout(workout: self.workout!)
            })
            
        } catch let saveErr {
            print("Failed to save company changes:", saveErr)
        }
    }
    
    private func createWorkout() {
        print("Trying to save workout...")
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        let workout = NSEntityDescription.insertNewObject(forEntityName: "Workout", into: context)
        
        workout.setValue(nameTextField.text, forKey: "name")
        workout.setValue(datePicker.date, forKey: "date")
        
        do {
            try context.save()
            
            dismiss(animated: true, completion: {
                self.delegate?.didAddWorkout(workout: workout as! Workout)
            })
            
        } catch let saveErr {
            print("Failed to save workout:", saveErr)
        }
    }
    
    private func setupUI() {
        
        view.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 75).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(nameTextField)
        nameTextField.leftAnchor.constraint(equalTo: nameLabel.rightAnchor).isActive = true
        nameTextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        nameTextField.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        nameTextField.topAnchor.constraint(equalTo: nameLabel.topAnchor).isActive = true

        view.addSubview(datePicker)
        datePicker.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        datePicker.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        datePicker.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true

    }
    
}
