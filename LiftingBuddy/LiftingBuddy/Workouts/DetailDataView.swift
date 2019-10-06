//
//  DetailDataView.swift
//  LiftingBuddy
//
//  Created by Logman on 7/30/19.
//  Copyright © 2019 Logman. All rights reserved.
//

import UIKit
import CoreData

class DetailDataController: UIViewController {
    
    var exerciseStr: String?

    var containerView = UIView()
    
    var found_index: Int?
    
    var max_weight: Int64?
    var max_reps: Int64?
    
    override func viewDidAppear(_ animated: Bool) {
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(scrollView)
        
        
        navigationController?.navigationBar.backgroundColor = .darkPurple
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        scrollView.indicatorStyle = .white
        
        view.backgroundColor = .black
        navigationItem.title = exerciseStr
        
        setupUI()
        
    }

    let scrollView: UIScrollView = {
        let v = UIScrollView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .black
        return v
    }()
    
    let topItem: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let bottomItem: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let bestSetTitle: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.numberOfLines = 3
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let bestSetLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.numberOfLines = 3
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let heavySetTitle: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.numberOfLines = 3
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let heavySetLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.numberOfLines = 3
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let bestWorkoutTitle: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let bestWorkoutLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.numberOfLines = 99
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let setLine: UIView = {
        let label = UIView()
        label.backgroundColor = .orange
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let heavySetLine: UIView = {
        let label = UIView()
        label.backgroundColor = .orange
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func getExerciseData() -> [Int64] {
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        var results = [Int64]()
        
        let fetchRequest = NSFetchRequest<Workout>(entityName: "Workout")
        do {
            
            let workouts = try context.fetch(fetchRequest)
            let sortedWorkouts = workouts.sorted(by: {$0.date!.compare($1.date!) == .orderedDescending})
            
            for lifts in sortedWorkouts {

                guard let workoutExercises = lifts.exercise?.allObjects as? [Exercise] else { return [0]}

                for exer in workoutExercises {
                    if exer.name == exerciseStr {
                        
                        guard let lookUpSets = exer.set?.allObjects as? [Set] else { return [0]}
                        let sortedSets = lookUpSets.sorted(by: {$0.index < $1.index})
                        
                        for items in sortedSets {
                            results.append(items.weight)
                            results.append(items.reps)
                        }
                    }
                }
            }

        } catch let fetchErr {
            print("Failed to fetch workouts:", fetchErr)
            return results
        }
        return results
    }
    
    func getExerciseSetData() -> String {
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        var currentMax : Int64 = 0
        var maxIndex = 0
        var currentDate = Date()
        var returnDate = Date()
        var index = 0
        var index2 = 0
        var i = 0
        var workoutVolume : Int64 = 0
        var maxWorkoutData = [Int64]()
        var returnStr = ""
        
        let fetchRequest = NSFetchRequest<Workout>(entityName: "Workout")
        do {
            
            let workouts = try context.fetch(fetchRequest)
            let sortedWorkouts = workouts.sorted(by: {$0.date!.compare($1.date!) == .orderedAscending})
            
            for lifts in sortedWorkouts {
                
                guard let workoutExercises = lifts.exercise?.allObjects as? [Exercise] else { return ""}
                
                for exer in workoutExercises {
                  if exer.name == exerciseStr {
                    if lifts.date != currentDate {
                        currentDate = lifts.date!
                        index = index + 1
                    }
                        guard let lookUpSets = exer.set?.allObjects as? [Set] else { return ""}
                        let sortedSets = lookUpSets.sorted(by: {$0.index < $1.index})
                        
                        for items in sortedSets {
                            workoutVolume = workoutVolume + (items.weight * items.reps)
                    }
                    
                    if workoutVolume >= currentMax {
                        currentMax = workoutVolume
                        maxIndex = index
                    }
                    }
                    workoutVolume = 0
                }
            }
            
        } catch let fetchErr {
            print("Failed to fetch workouts:", fetchErr)
            return returnStr
        }
        
        let fetchRequest2 = NSFetchRequest<Workout>(entityName: "Workout")
        do {
            
            let workouts2 = try context.fetch(fetchRequest2)
            let sortedWorkouts2 = workouts2.sorted(by: {$0.date!.compare($1.date!) == .orderedAscending})
            
            for lifts2 in sortedWorkouts2 {
                
                guard let workoutExercises2 = lifts2.exercise?.allObjects as? [Exercise] else { return ""}
                
                for exer2 in workoutExercises2 {
                 if exer2.name == exerciseStr {
                    index2 = index2 + 1
                    if index2 == maxIndex {
                        returnDate = lifts2.date!
                        guard let lookUpSets2 = exer2.set?.allObjects as? [Set] else { return ""}
                        let sortedSets2 = lookUpSets2.sorted(by: {$0.index < $1.index})
                        
                        for set in sortedSets2 {
                            maxWorkoutData.append(set.weight)
                            maxWorkoutData.append(set.reps)
                            let volume = set.weight * set.reps
                            maxWorkoutData.append(volume)
                        }
                    }
                    }
                }
            }
                
            } catch let fetchErr {
                print("Failed to fetch workouts:", fetchErr)
                return returnStr
            }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let formattedDatestring = dateFormatter.string(from: returnDate)
        
        returnStr = formattedDatestring + "\n" + "Total Volume -- \(currentMax) lbs\n"

        while i < maxWorkoutData.count {
            returnStr = returnStr + String(maxWorkoutData[i]) + " x " + String(maxWorkoutData[i+1]) + " -- " + String(maxWorkoutData[i+2]) + "\n"
            i = i + 3
        }
        
        return returnStr
    }
    
    func getBestSetDate(findIndex: Int) -> String {
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        var resultsDate = Date()
        var index = 0
        
        let fetchRequest = NSFetchRequest<Workout>(entityName: "Workout")
        do {
            
            let workouts = try context.fetch(fetchRequest)
            let sortedWorkouts = workouts.sorted(by: {$0.date!.compare($1.date!) == .orderedDescending})
            
            for lifts in sortedWorkouts {
                
                guard let workoutExercises = lifts.exercise?.allObjects as? [Exercise] else { return ""}
                
                for exer in workoutExercises {
                    if exer.name == exerciseStr {
                        
                        guard let lookUpSets = exer.set?.allObjects as? [Set] else { return ""}
                        let sortedSets = lookUpSets.sorted(by: {$0.index < $1.index})
                        
                        for _ in sortedSets {
                            if index == findIndex {
                                resultsDate = lifts.date!
                            }
                            
                            index = index + 1
                            
                        }
                    }
                }
            }
            
        } catch let fetchErr {
            print("Failed to fetch workouts:", fetchErr)
            return ""
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let formattedDatestring = dateFormatter.string(from: resultsDate)
        
        return formattedDatestring
    }
    
    func findBestSet (dataSet: [Int64]) -> String {
        
        var i = 0
        var found = false
        var setVolume = [Int64]()
        
        while i < dataSet.count {
                
            let volumeData = dataSet[i] * dataSet[i+1]
            setVolume.append(volumeData)
                
            i = i + 2
        }
        
        let maxVolume = setVolume.max()

        var j = 0
        var foundIndex = 0
        
        for items in setVolume {
            
            if items == maxVolume && found == false {
                foundIndex = j
                found = true
            }
            j = j + 1
        }

        let dataSetIndex = foundIndex * 2

        let total = dataSet[dataSetIndex]*dataSet[dataSetIndex + 1]
        
        let finalString = String(dataSet[dataSetIndex]) + " x " + String(dataSet[dataSetIndex + 1]) + " -- Total: " + String(total) + " lbs"
        
        found_index = foundIndex
        
        return finalString
        
    }
    
    func getHeavyWeightDate() -> String {

        let context = CoreDataManager.shared.persistentContainer.viewContext

        var resultsDate = Date()
        var found = false

        let fetchRequest = NSFetchRequest<Workout>(entityName: "Workout")
        do {

            let workouts = try context.fetch(fetchRequest)
            let sortedWorkouts = workouts.sorted(by: {$0.date!.compare($1.date!) == .orderedDescending})

            for lifts in sortedWorkouts {

                guard let workoutExercises = lifts.exercise?.allObjects as? [Exercise] else { return ""}

                for exer in workoutExercises {
                    if exer.name == exerciseStr {

                        guard let lookUpSets = exer.set?.allObjects as? [Set] else { return ""}
                        let sortedSets = lookUpSets.sorted(by: {$0.index < $1.index})

                        for set in sortedSets {
                            if set.weight == max_weight && set.reps == max_reps && found == false {
                                resultsDate = lifts.date!
                                found = true

                            }
                        }
                    }
                }
            }

        } catch let fetchErr {
            print("Failed to fetch workouts:", fetchErr)
            return ""
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let formattedDatestring = dateFormatter.string(from: resultsDate)

        return formattedDatestring
    }

    func findMaxWeight (dataSet: [Int64]) -> String {
        
        var i = 0
        var j = 0
        var returnStr = ""
        var weights = [Int64]()
        var reps = [Int64]()
        
        while i < dataSet.count  {
            weights.append(dataSet[i])
            i = i + 2
        }
        
        
        let weightMax = weights.max() ?? 0
        
        while j < dataSet.count {
            
            if weightMax == dataSet[j] {
                reps.append(dataSet[j+1])
            }
            
            j = j + 2
        }
        
        let repMax = reps.max() ?? 0

        let volume = weightMax * repMax
        
        max_weight = weightMax
        max_reps = repMax
        
        returnStr = String(weightMax) + " x " + String(repMax) + " -- Total: " + String(volume) + " lbs"
        
        return returnStr
        
    }
    

    private func setupUI() {
        
        scrollView.addSubview(topItem)
        topItem.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        topItem.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        
        let dataset = getExerciseData()
        let bestSet = findBestSet(dataSet: dataset)
        let bestSetDate = getBestSetDate(findIndex: found_index!)

        scrollView.addSubview(bestSetTitle)
        bestSetTitle.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        bestSetTitle.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        bestSetTitle.textAlignment = .center
        bestSetTitle.text = "Best Set:"
        
        scrollView.addSubview(bestSetLabel)
        bestSetLabel.topAnchor.constraint(equalTo: bestSetTitle.bottomAnchor).isActive = true
        bestSetLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        bestSetLabel.textAlignment = .center
        bestSetLabel.text = "\(bestSetDate)\n\(bestSet)"

        scrollView.addSubview(setLine)
        setLine.topAnchor.constraint(equalTo: bestSetLabel.bottomAnchor, constant: 5).isActive = true
        setLine.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 17).isActive = true
        setLine.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        setLine.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -17).isActive = true
        setLine.heightAnchor.constraint(equalToConstant: 4).isActive = true


        let heavySet = findMaxWeight(dataSet: dataset)
        let heavyWeightDate = getHeavyWeightDate()
        
        scrollView.addSubview(heavySetTitle)
        heavySetTitle.topAnchor.constraint(equalTo: setLine.bottomAnchor).isActive = true
        heavySetTitle.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        heavySetTitle.text = "Heaviest Weight Set:"

        scrollView.addSubview(heavySetLabel)
        heavySetLabel.topAnchor.constraint(equalTo: heavySetTitle.bottomAnchor).isActive = true
        heavySetLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        heavySetLabel.text = "\(heavyWeightDate)\n\(heavySet)"

        let bestWorkoutString = getExerciseSetData()

        scrollView.addSubview(heavySetLine)
        heavySetLine.topAnchor.constraint(equalTo: heavySetLabel.bottomAnchor, constant: 5).isActive = true
        heavySetLine.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 17).isActive = true
        heavySetLine.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        heavySetLine.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -17).isActive = true
        heavySetLine.heightAnchor.constraint(equalToConstant: 4).isActive = true
        
        scrollView.addSubview(bestWorkoutTitle)
        bestWorkoutTitle.topAnchor.constraint(equalTo: heavySetLine.bottomAnchor).isActive = true
        bestWorkoutTitle.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        bestWorkoutTitle.text = "Best Volume Workout:"

        scrollView.addSubview(bestWorkoutLabel)
        bestWorkoutLabel.topAnchor.constraint(equalTo: bestWorkoutTitle.bottomAnchor).isActive = true
        bestWorkoutLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        bestWorkoutLabel.text = "\(bestWorkoutString)"
        
        scrollView.addSubview(bottomItem)
        bottomItem.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        bottomItem.topAnchor.constraint(equalTo: bestWorkoutLabel.bottomAnchor).isActive = true
        bottomItem.rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true
        bottomItem.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        
    }
    
}

