//
//  CreateExerciseController.swift
//  LiftingBuddy
//
//  Created by Logman on 6/2/19.
//  Copyright © 2019 Logman. All rights reserved.
//a

import UIKit
import CoreData

protocol CreateExerciseControllerDelegate {
    func didAddExercise(exercise: Exercise)
}

class CreateExerciseController: UITableViewController {
    
    var workout: Workout?
    
    var delegate: CreateExerciseControllerDelegate?
    
    var allExerciseNames = [String]()
    
    func getAllExercises() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Workout>(entityName: "Workout")
        do {
            
            let workouts = try context.fetch(fetchRequest)
            
            for lifts in workouts {
                guard let workoutExercises = lifts.exercise?.allObjects as? [Exercise] else { return }
                for exer in workoutExercises {
                    
                    if (allExerciseNames.contains(exer.name ?? "")) {
//                        print("none")
                    } else {
                        print(exer.name!)
                        allExerciseNames.append(exer.name ?? "")
                    }
                }
            }
        } catch let fetchErr {
            print("Failed to fetch exercises:", fetchErr)
        }
        print(allExerciseNames.count)
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.backgroundColor = .white
        label.text = "    Name"
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
        label.text = "  Your Previous Exercises:"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 30)
        return label
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        getAllExercises()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Create Exercise"
        
        setupCancelButton()
        
        getAllExercises()
        
        allExerciseNames = allExerciseNames.sorted{$0 < $1}
        
        tableView.backgroundColor = UIColor.black
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        
        setupUI()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
    }
    
    @objc private func handleSave() {
        guard let exerciseName = nameTextField.text else { return }
        guard let workout = self.workout else { return }
        
        let tuple = CoreDataManager.shared.createExercise(exerciseName: exerciseName, inpIndex: 0, workout: workout)
        
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)

        cell.textLabel?.text = allExerciseNames[indexPath.row]
        cell.textLabel?.textColor = .white
        cell.backgroundColor = .black
//        cell.selectionStyle = .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
//        label.backgroundColor = .white
        return label
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allExerciseNames.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        nameTextField.text = allExerciseNames[indexPath.row]
        handleSave()
    }
    
    private func setupUI() {
//        _ = setupLightBlueBackgroundView(height: 150)
        
        view.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        nameLabel.backgroundColor = .white
        
        view.addSubview(nameTextField)
        nameTextField.leftAnchor.constraint(equalTo: nameLabel.rightAnchor).isActive = true
        nameTextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        nameTextField.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalToConstant: 300).isActive = true
        nameTextField.topAnchor.constraint(equalTo: nameLabel.topAnchor).isActive = true
        nameTextField.backgroundColor = .white
        
        view.addSubview(quickLabel)
        quickLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        quickLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        quickLabel.widthAnchor.constraint(equalToConstant: 375).isActive = true
        quickLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        quickLabel.backgroundColor = .white
        
    }
    
}
