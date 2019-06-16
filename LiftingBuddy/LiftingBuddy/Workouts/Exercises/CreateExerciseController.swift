//
//  CreateExerciseController.swift
//  LiftingBuddy
//
//  Created by Logman on 6/2/19.
//  Copyright © 2019 Logman. All rights reserved.
//a

import UIKit

protocol CreateExerciseControllerDelegate {
    func didAddExercise(exercise: Exercise)
}

class CreateExerciseController: UIViewController {
    
    var workout: Workout?
    
    var delegate: CreateExerciseControllerDelegate?
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter name"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
//    let birthdayLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Birthday"
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//
    let Workout1: UILabel = {
        let textField = UILabel()
        textField.text = "Bench"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isUserInteractionEnabled = true
        return textField
    }()
    
    let Workout2: UILabel = {
        let textField = UILabel()
        textField.text = "Squat"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isUserInteractionEnabled = true
        return textField
    }()
    
    @objc func tapFunction1(sender: UITapGestureRecognizer) {
        nameTextField.text = "Bench"
    }
    
    @objc func tapFunction2(sender: UITapGestureRecognizer) {
        nameTextField.text = "Squat"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Create Exercise"
        
        setupCancelButton()
        
        view.backgroundColor = .darkBlue
        
        setupUI()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(tapFunction1))
        Workout1.addGestureRecognizer(tap1)
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(tapFunction2))
        Workout2.addGestureRecognizer(tap2)
    }
    
    @objc private func handleSave() {
        guard let exerciseName = nameTextField.text else { return }
        guard let workout = self.workout else { return }
        
        // turn birthdayTextField.text into a date object
        
//        guard let birthdayText = birthdayTextField.text else { return }
        
        // let's perform the validation step here
//        if birthdayText.isEmpty {
//            showError(title: "Empty Birthday", message: "You have not entered a birthday.")
//            return
//        }
        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MM/dd/yyyy"
//
//        guard let birthdayDate = dateFormatter.date(from: birthdayText) else {
//            showError(title: "Bad Date", message: "Birthday date entered not valid")
//            return
//        }
        
//        guard let employeeType = employeeTypeSegmentedControl.titleForSegment(at: employeeTypeSegmentedControl.selectedSegmentIndex) else { return }
        
        let tuple = CoreDataManager.shared.createExercise(exerciseName: exerciseName, workout: workout)
        
        if let error = tuple.1 {
            // is where you present an error modal of some kind
            // perhaps use a UIAlertController to show your error message
            print(error)
        } else {
            // creation success
            dismiss(animated: true, completion: {
                // we'll call the delegate somehow
                self.delegate?.didAddExercise(exercise: tuple.0!)
            })
        }
    }
    
    private func showError(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
//    let employeeTypeSegmentedControl: UISegmentedControl = {
        //        let types = ["Executive", "Senior Management", "Staff"]
        
//        let types = [
//            EmployeeType.Executive.rawValue,
//            EmployeeType.SeniorManagement.rawValue,
//            EmployeeType.Staff.rawValue,
//            EmployeeType.Intern.rawValue
//        ]
//
//        let sc = UISegmentedControl(items: types)
//        sc.selectedSegmentIndex = 0
//        sc.translatesAutoresizingMaskIntoConstraints = false
//        sc.tintColor = UIColor.darkBlue
//        return sc
//    }()
    
  
    
    
    private func setupUI() {
        _ = setupLightBlueBackgroundView(height: 150)
        
        view.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(nameTextField)
        nameTextField.leftAnchor.constraint(equalTo: nameLabel.rightAnchor).isActive = true
        nameTextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        nameTextField.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        nameTextField.topAnchor.constraint(equalTo: nameLabel.topAnchor).isActive = true
        
        view.addSubview(Workout1)
        Workout1.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        Workout1.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        Workout1.widthAnchor.constraint(equalToConstant: 100).isActive = true
        Workout1.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(Workout2)
        Workout2.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        Workout2.leftAnchor.constraint(equalTo: Workout1.rightAnchor, constant: 16).isActive = true
        Workout2.widthAnchor.constraint(equalToConstant: 100).isActive = true
        Workout2.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
//        view.addSubview(birthdayLabel)
//        birthdayLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
//        birthdayLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
//        birthdayLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
//        birthdayLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
//
//        view.addSubview(birthdayTextField)
//        birthdayTextField.leftAnchor.constraint(equalTo: birthdayLabel.rightAnchor).isActive = true
//        birthdayTextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
//        birthdayTextField.bottomAnchor.constraint(equalTo: birthdayLabel.bottomAnchor).isActive = true
//        birthdayTextField.topAnchor.constraint(equalTo: birthdayLabel.topAnchor).isActive = true
        
//        view.addSubview(employeeTypeSegmentedControl)
//        employeeTypeSegmentedControl.topAnchor.constraint(equalTo: birthdayLabel.bottomAnchor, constant: 0).isActive = true
//        employeeTypeSegmentedControl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
//        employeeTypeSegmentedControl.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
//        employeeTypeSegmentedControl.heightAnchor.constraint(equalToConstant: 34).isActive = true
    }
    
}












