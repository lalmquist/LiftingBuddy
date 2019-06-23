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
                        return
                    } else {
                        allExerciseNames.append(exer.name ?? "")
                    }
                }
            }
        } catch let fetchErr {
            print("Failed to fetch exercises:", fetchErr)
        }
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
    

//    let Workout1: UILabel = {
//        let textField = UILabel()
//        textField.text = "Bench"
//        textField.textAlignment = .center
//        textField.translatesAutoresizingMaskIntoConstraints = false
//        textField.isUserInteractionEnabled = true
//        textField.font = UIFont.boldSystemFont(ofSize: 16)
//        return textField
//    }()
//
//    let Workout2: UILabel = {
//        let textField = UILabel()
//        textField.text = "Incline Bench"
//        textField.textAlignment = .center
//        textField.translatesAutoresizingMaskIntoConstraints = false
//        textField.isUserInteractionEnabled = true
//        textField.font = UIFont.boldSystemFont(ofSize: 16)
//        return textField
//    }()
//
//    let Workout3: UILabel = {
//        let textField = UILabel()
//        textField.text = "Decline Bench"
//        textField.textAlignment = .center
//        textField.translatesAutoresizingMaskIntoConstraints = false
//        textField.isUserInteractionEnabled = true
//        textField.font = UIFont.boldSystemFont(ofSize: 16)
//        return textField
//    }()
//
//    let Workout4: UILabel = {
//        let textField = UILabel()
//        textField.text = "Squat"
//        textField.textAlignment = .center
//        textField.translatesAutoresizingMaskIntoConstraints = false
//        textField.isUserInteractionEnabled = true
//        textField.font = UIFont.boldSystemFont(ofSize: 16)
//        return textField
//    }()
//
//    let Workout5: UILabel = {
//        let textField = UILabel()
//        textField.text = "Deadlift"
//        textField.textAlignment = .center
//        textField.translatesAutoresizingMaskIntoConstraints = false
//        textField.isUserInteractionEnabled = true
//        textField.font = UIFont.boldSystemFont(ofSize: 16)
//        return textField
//    }()
//
//    let Workout6: UILabel = {
//        let textField = UILabel()
//        textField.text = "Leg Press"
//        textField.textAlignment = .center
//        textField.translatesAutoresizingMaskIntoConstraints = false
//        textField.isUserInteractionEnabled = true
//        textField.font = UIFont.boldSystemFont(ofSize: 16)
//        return textField
//    }()
//
//    let Workout7: UILabel = {
//        let textField = UILabel()
//        textField.text = "Seated Row"
//        textField.textAlignment = .center
//        textField.translatesAutoresizingMaskIntoConstraints = false
//        textField.isUserInteractionEnabled = true
//        textField.font = UIFont.boldSystemFont(ofSize: 16)
//        return textField
//    }()
//
//    let Workout8: UILabel = {
//        let textField = UILabel()
//        textField.text = "Lat Pulldown"
//        textField.textAlignment = .center
//        textField.translatesAutoresizingMaskIntoConstraints = false
//        textField.isUserInteractionEnabled = true
//        textField.font = UIFont.boldSystemFont(ofSize: 16)
//        return textField
//    }()
//
//    let Workout9: UILabel = {
//        let textField = UILabel()
//        textField.text = "Military Press"
//        textField.textAlignment = .center
//        textField.translatesAutoresizingMaskIntoConstraints = false
//        textField.isUserInteractionEnabled = true
//        textField.font = UIFont.boldSystemFont(ofSize: 16)
//        return textField
//    }()
//
//    let Workout10: UILabel = {
//        let textField = UILabel()
//        textField.text = "Barbell Row"
//        textField.textAlignment = .center
//        textField.translatesAutoresizingMaskIntoConstraints = false
//        textField.isUserInteractionEnabled = true
//        textField.font = UIFont.boldSystemFont(ofSize: 16)
//        return textField
//    }()
//
//    let Workout11: UILabel = {
//        let textField = UILabel()
//        textField.text = "Tricep Extension"
//        textField.textAlignment = .center
//        textField.translatesAutoresizingMaskIntoConstraints = false
//        textField.isUserInteractionEnabled = true
//        textField.font = UIFont.boldSystemFont(ofSize: 16)
//        return textField
//    }()
//
//    let Workout12: UILabel = {
//        let textField = UILabel()
//        textField.text = "Dumbell Curl"
//        textField.textAlignment = .center
//        textField.translatesAutoresizingMaskIntoConstraints = false
//        textField.isUserInteractionEnabled = true
//        textField.font = UIFont.boldSystemFont(ofSize: 16)
//        return textField
//    }()
//
//    let Workout13: UILabel = {
//        let textField = UILabel()
//        textField.text = "Barbell Curl"
//        textField.textAlignment = .center
//        textField.translatesAutoresizingMaskIntoConstraints = false
//        textField.isUserInteractionEnabled = true
//        textField.font = UIFont.boldSystemFont(ofSize: 16)
//        return textField
//    }()
//    @objc func tapFunction1(sender: UITapGestureRecognizer) {
//        nameTextField.text = "Bench"
//        handleSave()
//    }
//
//    @objc func tapFunction2(sender: UITapGestureRecognizer) {
//        nameTextField.text = "Incline Bench"
//        handleSave()
//    }
//
//    @objc func tapFunction3(sender: UITapGestureRecognizer) {
//        nameTextField.text = "Decline Bench"
//        handleSave()
//    }
//
//    @objc func tapFunction4(sender: UITapGestureRecognizer) {
//        nameTextField.text = "Squat"
//        handleSave()
//    }
//
//    @objc func tapFunction5(sender: UITapGestureRecognizer) {
//        nameTextField.text = "Deadlift"
//        handleSave()
//    }
//
//    @objc func tapFunction6(sender: UITapGestureRecognizer) {
//        nameTextField.text = "Leg Press"
//        handleSave()
//    }
//
//    @objc func tapFunction7(sender: UITapGestureRecognizer) {
//        nameTextField.text = "Seated Row"
//        handleSave()
//    }
//
//    @objc func tapFunction8(sender: UITapGestureRecognizer) {
//        nameTextField.text = "Lat Pulldown"
//        handleSave()
//    }
//
//    @objc func tapFunction9(sender: UITapGestureRecognizer) {
//        nameTextField.text = "Military Press"
//        handleSave()
//    }
//
//    @objc func tapFunction10(sender: UITapGestureRecognizer) {
//        nameTextField.text = "Barbell Row"
//        handleSave()
//    }
//
//    @objc func tapFunction11(sender: UITapGestureRecognizer) {
//        nameTextField.text = "Tricep Extension"
//        handleSave()
//    }
//
//    @objc func tapFunction12(sender: UITapGestureRecognizer) {
//        nameTextField.text = "Dumbell Curl"
//        handleSave()
//    }
//
//    @objc func tapFunction13(sender: UITapGestureRecognizer) {
//        nameTextField.text = "Barbell Curl"
//        handleSave()
//    }
//
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
        
//        let tap1 = UITapGestureRecognizer(target: self, action: #selector(tapFunction1))
//        Workout1.addGestureRecognizer(tap1)
//        let tap2 = UITapGestureRecognizer(target: self, action: #selector(tapFunction2))
//        Workout2.addGestureRecognizer(tap2)
//        let tap3 = UITapGestureRecognizer(target: self, action: #selector(tapFunction3))
//        Workout3.addGestureRecognizer(tap3)
//        let tap4 = UITapGestureRecognizer(target: self, action: #selector(tapFunction4))
//        Workout4.addGestureRecognizer(tap4)
//        let tap5 = UITapGestureRecognizer(target: self, action: #selector(tapFunction5))
//        Workout5.addGestureRecognizer(tap5)
//        let tap6 = UITapGestureRecognizer(target: self, action: #selector(tapFunction6))
//        Workout6.addGestureRecognizer(tap6)
//        let tap7 = UITapGestureRecognizer(target: self, action: #selector(tapFunction7))
//        Workout7.addGestureRecognizer(tap7)
//        let tap8 = UITapGestureRecognizer(target: self, action: #selector(tapFunction8))
//        Workout8.addGestureRecognizer(tap8)
//        let tap9 = UITapGestureRecognizer(target: self, action: #selector(tapFunction9))
//        Workout9.addGestureRecognizer(tap9)
//        let tap10 = UITapGestureRecognizer(target: self, action: #selector(tapFunction10))
//        Workout10.addGestureRecognizer(tap10)
//        let tap11 = UITapGestureRecognizer(target: self, action: #selector(tapFunction11))
//        Workout11.addGestureRecognizer(tap11)
//        let tap12 = UITapGestureRecognizer(target: self, action: #selector(tapFunction12))
//        Workout12.addGestureRecognizer(tap12)
//        let tap13 = UITapGestureRecognizer(target: self, action: #selector(tapFunction13))
//        Workout13.addGestureRecognizer(tap13)
        
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)

        cell.textLabel?.text = allExerciseNames[indexPath.row]
        cell.textLabel?.textColor = .white
        cell.backgroundColor = .black
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
//        label.backgroundColor = .white
        return label
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
        
//        view.addSubview(Workout1)
//        Workout1.topAnchor.constraint(equalTo: quickLabel.bottomAnchor).isActive = true
//        Workout1.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
//        Workout1.widthAnchor.constraint(equalToConstant: 127).isActive = true
//        Workout1.heightAnchor.constraint(equalToConstant: 50).isActive = true
//
//        view.addSubview(Workout2)
//        Workout2.topAnchor.constraint(equalTo: Workout1.topAnchor).isActive = true
//        Workout2.leftAnchor.constraint(equalTo: Workout1.rightAnchor, constant: 0).isActive = true
//        Workout2.widthAnchor.constraint(equalToConstant: 127).isActive = true
//        Workout2.heightAnchor.constraint(equalToConstant: 50).isActive = true
//
//        view.addSubview(Workout3)
//        Workout3.topAnchor.constraint(equalTo: Workout2.topAnchor).isActive = true
//        Workout3.leftAnchor.constraint(equalTo: Workout2.rightAnchor, constant: 0).isActive = true
//        Workout3.widthAnchor.constraint(equalToConstant: 127).isActive = true
//        Workout3.heightAnchor.constraint(equalToConstant: 50).isActive = true
//
//        view.addSubview(Workout4)
//        Workout4.topAnchor.constraint(equalTo: Workout1.bottomAnchor, constant: 16).isActive = true
//        Workout4.leftAnchor.constraint(equalTo: Workout1.leftAnchor, constant: 0).isActive = true
//        Workout4.widthAnchor.constraint(equalToConstant: 127).isActive = true
//        Workout4.heightAnchor.constraint(equalToConstant: 50).isActive = true
//
//        view.addSubview(Workout5)
//        Workout5.topAnchor.constraint(equalTo: Workout4.topAnchor, constant: 0).isActive = true
//        Workout5.leftAnchor.constraint(equalTo: Workout4.rightAnchor, constant: 0).isActive = true
//        Workout5.widthAnchor.constraint(equalToConstant: 127).isActive = true
//        Workout5.heightAnchor.constraint(equalToConstant: 50).isActive = true
//
//        view.addSubview(Workout6)
//        Workout6.topAnchor.constraint(equalTo: Workout5.topAnchor, constant: 0).isActive = true
//        Workout6.rightAnchor.constraint(equalTo: Workout3.rightAnchor, constant: 0).isActive = true
//        Workout6.widthAnchor.constraint(equalToConstant: 127).isActive = true
//        Workout6.heightAnchor.constraint(equalToConstant: 50).isActive = true
//
//        view.addSubview(Workout7)
//        Workout7.topAnchor.constraint(equalTo: Workout4.bottomAnchor, constant: 16).isActive = true
//        Workout7.leftAnchor.constraint(equalTo: Workout4.leftAnchor, constant: 0).isActive = true
//        Workout7.widthAnchor.constraint(equalToConstant: 127).isActive = true
//        Workout7.heightAnchor.constraint(equalToConstant: 50).isActive = true
//
//        view.addSubview(Workout8)
//        Workout8.topAnchor.constraint(equalTo: Workout7.topAnchor, constant: 0).isActive = true
//        Workout8.leftAnchor.constraint(equalTo: Workout7.rightAnchor, constant: 0).isActive = true
//        Workout8.widthAnchor.constraint(equalToConstant: 127).isActive = true
//        Workout8.heightAnchor.constraint(equalToConstant: 50).isActive = true
//
//        view.addSubview(Workout9)
//        Workout9.topAnchor.constraint(equalTo: Workout8.topAnchor, constant: 0).isActive = true
//        Workout9.rightAnchor.constraint(equalTo: Workout3.rightAnchor, constant: 0).isActive = true
//        Workout9.widthAnchor.constraint(equalToConstant: 127).isActive = true
//        Workout9.heightAnchor.constraint(equalToConstant: 50).isActive = true
//
//        view.addSubview(Workout10)
//        Workout10.topAnchor.constraint(equalTo: Workout9.bottomAnchor, constant: 16).isActive = true
//        Workout10.leftAnchor.constraint(equalTo: Workout7.leftAnchor, constant: 0).isActive = true
//        Workout10.widthAnchor.constraint(equalToConstant:127).isActive = true
//        Workout10.heightAnchor.constraint(equalToConstant: 50).isActive = true
//
//        view.addSubview(Workout11)
//        Workout11.topAnchor.constraint(equalTo: Workout10.topAnchor, constant: 0).isActive = true
//        Workout11.leftAnchor.constraint(equalTo: Workout10.rightAnchor, constant: 0).isActive = true
//        Workout11.widthAnchor.constraint(equalToConstant: 127).isActive = true
//        Workout11.heightAnchor.constraint(equalToConstant: 50).isActive = true
//
//        view.addSubview(Workout12)
//        Workout12.topAnchor.constraint(equalTo: Workout11.topAnchor, constant: 0).isActive = true
//        Workout12.leftAnchor.constraint(equalTo: Workout11.rightAnchor, constant: 0).isActive = true
//        Workout12.widthAnchor.constraint(equalToConstant: 127).isActive = true
//        Workout12.heightAnchor.constraint(equalToConstant: 50).isActive = true
//
//        view.addSubview(Workout13)
//        Workout13.topAnchor.constraint(equalTo: Workout10.bottomAnchor, constant: 16).isActive = true
//        Workout13.leftAnchor.constraint(equalTo: Workout10.leftAnchor, constant: 0).isActive = true
//        Workout13.widthAnchor.constraint(equalToConstant: 127).isActive = true
//        Workout13.heightAnchor.constraint(equalToConstant: 50).isActive = true
//
    }
    
}
