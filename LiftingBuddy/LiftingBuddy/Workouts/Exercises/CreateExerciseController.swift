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
        label.textColor = .black
        label.backgroundColor = .white
        label.text = "Name"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .black
        textField.placeholder = "Enter name"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let quickLabel: UILabel = {
        let label = UILabel()
        label.text = "Quick Select:"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 30)
        return label
    }()

    let Workout1: UILabel = {
        let textField = UILabel()
        textField.text = "Bench"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isUserInteractionEnabled = true
        textField.font = UIFont.boldSystemFont(ofSize: 20)
        return textField
    }()
    
    let Workout2: UILabel = {
        let textField = UILabel()
        textField.text = "Squat"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isUserInteractionEnabled = true
        textField.font = UIFont.boldSystemFont(ofSize: 20)
        return textField
    }()
    
    @objc func tapFunction1(sender: UITapGestureRecognizer) {
        nameTextField.text = "Bench"
        handleSave()
    }
    
    @objc func tapFunction2(sender: UITapGestureRecognizer) {
        nameTextField.text = "Squat"
        handleSave()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Create Exercise"
        
        setupCancelButton()
        
        view.backgroundColor = .white
        
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

    
    private func setupUI() {
//        _ = setupLightBlueBackgroundView(height: 150)
        
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
        
        view.addSubview(quickLabel)
        quickLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        quickLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        quickLabel.widthAnchor.constraint(equalToConstant: 350).isActive = true
        quickLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(Workout1)
        Workout1.topAnchor.constraint(equalTo: quickLabel.bottomAnchor).isActive = true
        Workout1.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 36).isActive = true
        Workout1.widthAnchor.constraint(equalToConstant: 100).isActive = true
        Workout1.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(Workout2)
        Workout2.topAnchor.constraint(equalTo: Workout1.topAnchor).isActive = true
        Workout2.leftAnchor.constraint(equalTo: Workout1.rightAnchor, constant: 16).isActive = true
        Workout2.widthAnchor.constraint(equalToConstant: 100).isActive = true
        Workout2.heightAnchor.constraint(equalToConstant: 50).isActive = true

    }
    
}
