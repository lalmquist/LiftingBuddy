//
//  SetController.swift
//  LiftingBuddy
//
//  Created by Logman on 6/2/19.
//  Copyright © 2019 Logman. All rights reserved.
//
import UIKit
import CoreData

class SetController: UITableViewController, UITextFieldDelegate {
    
    var exercise: Exercise?
    
    var footerTitle: UILabel?
    var footerView: UIView?
    
    var heightValue: Int = 0
    var widthValue: Int = 0
    
    var allSets = [[Set]]()
    
    var volume: Int64?
    
    var lastDate: Date?
    
    var lastResults: [Int64]?
    
    public var total_volume: Int64?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        let swipe: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        view.addGestureRecognizer(swipe)
        
        weightTextField.keyboardType = UIKeyboardType.numberPad
        
        repsTextField.keyboardType = UIKeyboardType.numberPad
        
        tableView.backgroundColor = UIColor.black
        
        setupPlusButtonInNavBar(selector: #selector(createNewSet))
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        tableView.indicatorStyle = .white
        
        repsTextField.delegate = self
        
        weightTextField.delegate = self
        
        fetchSets()
        
        footerTitle = getFooterTitleInfo()
        footerView = getFooterViewInfo()
        
        setupUI()
        
    }
    
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        let set = allSets[0][indexPath.row]
        let inpIndex = Int16(indexPath.row)
        
        set.exercise = exercise
        let volume = Int64(set.reps) * Int64(set.weight)
        
        let label = "\(set.weight) x \(set.reps) -- Total: \(volume) lbs"
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.text = label
        cell.backgroundColor = UIColor.black
        cell.textLabel?.textColor = .white
        cell.selectionStyle = .none
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        
        updateSetIndex(set: set, intIndex: inpIndex)
        
        return cell
        
    }
    
    func updateSetIndex(set: Set, intIndex: Int16) {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        set.index = intIndex
        
        do {
            try context.save()
            
        } catch let err {
            print("Failed to update set:", err)
            
        }
    }
    
    func getLastExerciseData() -> [Int64] {
        
        var found = false
        var preWorkout = false
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Workout>(entityName: "Workout")
        do {
            
            let workouts = try context.fetch(fetchRequest)
            let sortedWorkouts = workouts.sorted(by: {$0.date!.compare($1.date!) == .orderedDescending})
            
            for lifts in sortedWorkouts {
                guard let workoutExercises = lifts.exercise?.allObjects as? [Exercise] else { return [0]}
                for exer in workoutExercises {
                    if lifts.date?.compare((exercise?.workout!.date)!) == .orderedAscending{
                        preWorkout = true
                        lastDate = lifts.date
                    }
                    if exer.name == exercise?.name && preWorkout == true && found == false {
                        found = true
                        
                        guard let lookUpSets = exer.set?.allObjects as? [Set] else { return [0]}
                        let sortedSets = lookUpSets.sorted(by: {$0.index < $1.index})
                        var results = [Int64]()
                        for items in sortedSets {
                            results.append(items.weight)
                            results.append(items.reps)
                        }
                        
                        return results
                    }
                }
            }
            
            
        } catch let fetchErr {
            print("Failed to fetch workouts:", fetchErr)
            return [0]
        }
        return[0]
    }
    
    
    
    let cellId = "cellId"
    
    private func fetchSets() {
        guard let workoutSets = exercise?.set?.allObjects as? [Set] else { return }
        
        allSets = []
        
        allSets.append(workoutSets)
        
        allSets[0].sort {
            $0.index < $1.index
        }
        
    }
    
    @objc private func createNewSet() {
        let intReps = Int64(repsTextField.text ?? "0")
        let intWeight = Int64(weightTextField.text ?? "0")
        
        let set = CoreDataManager.shared.createSet(setReps: intReps ?? 0, setWeight: intWeight ?? 0)
        
        if let error = set.1 {
            
            print(error)
        } else {
            didAddSet(set: set.0!)
        }
        
        setupUI()
        checkImprove()
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = exercise?.name
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        checkImprove()
        return 100
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allSets[0].count
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (_, indexPath) in
            let set = self.allSets[indexPath.section][indexPath.row]
            print("Attempting to delete set:")
            
            print([indexPath])
            self.allSets[indexPath.section].remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            let context = CoreDataManager.shared.persistentContainer.viewContext
            
            context.delete(set)
            self.setupUI()
            do {
                try context.save()
                self.checkImprove()
            } catch let saveErr {
                print("Failed to delete exercise:", saveErr)
            }
        }
        deleteAction.backgroundColor = UIColor.lightRed
        
        return [deleteAction]
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func didAddSet(set: Set) {
        allSets[0].append(set)
        let row = allSets[0].count
        let newIndexPath = IndexPath(row: row - 1, section: 0)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
    }
    
    let weightLabel: UILabel = {
        let textField = UILabel()
        textField.textColor = .white
        textField.text = " Weight"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let repsLabel: UILabel = {
        let textField = UILabel()
        textField.textColor = .white
        textField.text = " Reps"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let fillLabel: UILabel = {
        let fill_Label = UILabel()
        fill_Label.backgroundColor = .custGreen
        fill_Label.translatesAutoresizingMaskIntoConstraints = false
        return fill_Label
    }()
    
    let weightTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .black
        textField.placeholder = "0"
        textField.textAlignment = .center
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let repsTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .black
        textField.placeholder = "0"
        textField.textAlignment = .center
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentCharacterCount = textField.text?.count ?? 0
        if range.length + range.location > currentCharacterCount {
            return false
        }
        let newLength = currentCharacterCount + string.count - range.length
        
        return newLength <= 3
    }
    
    var sum : Int64?
    
    func getVolume() -> Int64 {
        var volArray = [Int64]()
        for set in allSets[0] {
            let vol = Int64(set.reps) * Int64(set.weight)
            volArray.append(Int64(vol))
        }
        let sum = volArray.reduce(0, +)
        return sum
    }
    
    func didImprove(exercise: Exercise, improved: Bool) {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        if improved == true {
            exercise.improved = true
        } else {
            exercise.improved = false
        }
        
        do {
            try context.save()
            // save succeeds
            
        } catch let err {
            print("Failed to update exercise:", err)
            
        }
    }
    
    func didBefore(did_before: Bool) {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        if did_before == true {
            exercise?.donebefore = true
        } else {
            exercise?.donebefore = false
        }
        
        do {
            try context.save()
            // save succeeds
            
        } catch let err {
            print("Failed to update exercise:", err)
            
        }
    }
    
    func checkImprove() {
        
        let localvol = getVolume()
        
        //        print(localvol)
        //        print(total_volume)
        if localvol >= total_volume ?? 9999 && total_volume != 0 {
            didImprove(exercise: exercise!, improved: true)
        } else {
            didImprove(exercise: exercise!, improved: false)
        }
        
        //        print(exercise?.improved ?? false)
    }
    
    let totalVolume: UILabel = {
        let displayString = UILabel()
        displayString.textColor = .white
        displayString.translatesAutoresizingMaskIntoConstraints = false
        return displayString
    }()
    
    func getFooterViewInfo() -> UIView {
        
        let widthValue = Int(view.frame.width)
        let last_Results = getLastExerciseData()
        if last_Results.count > 1 {
            didBefore(did_before: true)
            let part1 = (last_Results.count/2)
            let height_Value = 80 + (part1*20)
            heightValue = height_Value
        } else {
            didBefore(did_before: false)
            let height_Value = 0
            heightValue = height_Value
        }
        
        let footerView = UIView(frame: CGRect(x: 0,y: 0, width: widthValue, height: heightValue))
        footerView.backgroundColor = .custGreen
        tableView.tableFooterView = footerView
        return footerView
        
    }
    
    
    func getFooterTitleInfo() -> UILabel {
        
        let footerTitle = UILabel()
        
        var lastResults = getLastExerciseData()
        var i = 0
        var dataString = ""
        var totalVolume = Int64(0)
        if lastResults.count > 1 {
            while i < lastResults.count {
                let volume = Int64(lastResults[i]*lastResults[i+1])
                totalVolume = totalVolume + Int64(volume)
                dataString = dataString + "\(String(lastResults[i])) x \(String(lastResults[i+1])) -- \(volume)\n"
                i = i + 2
            }
        } else {
            dataString = "No Workouts"
        }
        
        total_volume = totalVolume
        
        footerTitle.translatesAutoresizingMaskIntoConstraints = false
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let formattedDatestring = dateFormatter.string(from: lastDate ?? Date())
        
        if lastResults.count > 1 {
            footerTitle.text = "The last time you did - \(exercise?.name ?? "Not Found") \n\(String(formattedDatestring))\n\nTotal Volume -- \(totalVolume) lbs\n\(dataString)"
        } else {
            footerTitle.text = ""
        }
        
        footerTitle.textColor = .white
        footerTitle.textAlignment = .center
        footerTitle.numberOfLines = (lastResults.count/2) + 4
        footerTitle.lineBreakMode = .byWordWrapping
        footerTitle.backgroundColor = .custGreen
        footerTitle.font = UIFont.boldSystemFont(ofSize: 16)
        
        
        return footerTitle
    }
    
    func setupUI() {
        
        view.addSubview(fillLabel)
        fillLabel.backgroundColor = .custGreen
        fillLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        fillLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        fillLabel.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        fillLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let startWidth = (view.frame.width/2)-180
        
        view.addSubview(weightLabel)
        weightLabel.backgroundColor = .custGreen
        weightLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        weightLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: startWidth).isActive = true
        weightLabel.widthAnchor.constraint(equalToConstant: 115).isActive = true
        weightLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        weightLabel.font = UIFont.boldSystemFont(ofSize: 30)
        
        view.addSubview(weightTextField)
        weightTextField.backgroundColor = .white
        weightTextField.topAnchor.constraint(equalTo: weightLabel.topAnchor).isActive = true
        weightTextField.leftAnchor.constraint(equalTo: weightLabel.rightAnchor).isActive = true
        weightTextField.widthAnchor.constraint(equalToConstant: 90).isActive = true
        weightTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        weightTextField.font = UIFont.boldSystemFont(ofSize: 45)
        
        view.addSubview(repsLabel)
        repsLabel.backgroundColor = .custGreen
        repsLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        repsLabel.leftAnchor.constraint(equalTo: weightTextField.rightAnchor, constant: 0).isActive = true
        repsLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
        repsLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        repsLabel.font = UIFont.boldSystemFont(ofSize: 30)
        
        view.addSubview(repsTextField)
        repsTextField.backgroundColor = .white
        repsTextField.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        repsTextField.leftAnchor.constraint(equalTo: repsLabel.rightAnchor, constant: 0).isActive = true
        repsTextField.widthAnchor.constraint(equalToConstant: 75).isActive = true
        repsTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        repsTextField.font = UIFont.boldSystemFont(ofSize: 45)
        
        view.addSubview(totalVolume)
        totalVolume.backgroundColor = .custGreen
        totalVolume.topAnchor.constraint(equalTo: weightLabel.bottomAnchor).isActive = true
        totalVolume.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        totalVolume.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        totalVolume.heightAnchor.constraint(equalToConstant: 50).isActive = true
        totalVolume.font = UIFont.boldSystemFont(ofSize: 30)
        totalVolume.textAlignment = .center
        let volume = getVolume()
        totalVolume.text = "Total Volume -- \(volume)"
        
        view.addSubview(footerTitle!)
        footerTitle!.topAnchor.constraint(equalTo: footerView!.topAnchor, constant: 3).isActive = true
        footerTitle!.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        
    }
    
}
