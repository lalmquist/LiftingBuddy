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
    
    var found_index: Int?
    
    var max_weight: Int64?
    var max_reps: Int64?
    
    override func viewDidAppear(_ animated: Bool) {
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        navigationItem.title = exerciseStr
        
        setupUI()
        
    }
    
    let bestSetLabel: UILabel = {
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
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.numberOfLines = 3
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let bestWorkoutLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.numberOfLines = 3
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
    
    func getExerciseSetData() -> [Int64] {
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        var results = [Int64]()
        var index : Int64 = 0
        var indexDate = Date()
        var indexKey : Int64 = 0
        
        let fetchRequest = NSFetchRequest<Workout>(entityName: "Workout")
        do {
            
            let workouts = try context.fetch(fetchRequest)
            let sortedWorkouts = workouts.sorted(by: {$0.date!.compare($1.date!) == .orderedDescending})
            
            for lifts in sortedWorkouts {
                
                guard let workoutExercises = lifts.exercise?.allObjects as? [Exercise] else { return [0]}
                
                for exer in workoutExercises {
                    if exer.name == exerciseStr {
                        if lifts.date != indexDate {
                            indexDate = lifts.date!
                            index = index + 1
                        }
                        
                        guard let lookUpSets = exer.set?.allObjects as? [Set] else { return [0]}
                        let sortedSets = lookUpSets.sorted(by: {$0.index < $1.index})
                        
                        for items in sortedSets {
                            results.append(items.weight)
                            results.append(items.reps)
                            
                            indexKey = index * 1000
                            results.append(indexKey)
                        }
                    }
                }
            }
            
        } catch let fetchErr {
            print("Failed to fetch workouts:", fetchErr)
            return results
        }
        
        print(results)
        return results
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
        
        
        let dataset = getExerciseData()
        let bestSet = findBestSet(dataSet: dataset)
        let bestSetDate = getBestSetDate(findIndex: found_index!)

        view.addSubview(bestSetLabel)
        bestSetLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        bestSetLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        bestSetLabel.textAlignment = .center
        bestSetLabel.text = "Best Set:\n\(bestSetDate)\n\(bestSet)"
        
        view.addSubview(setLine)
        setLine.topAnchor.constraint(equalTo: bestSetLabel.bottomAnchor, constant: 5).isActive = true
        setLine.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        setLine.widthAnchor.constraint(equalToConstant: view.frame.width/1.1).isActive = true
        setLine.heightAnchor.constraint(equalToConstant: 4).isActive = true
        
        
        let heavySet = findMaxWeight(dataSet: dataset)
        let heavyWeightDate = getHeavyWeightDate()
        
        view.addSubview(heavySetLabel)
        heavySetLabel.topAnchor.constraint(equalTo: setLine.bottomAnchor).isActive = true
        heavySetLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        heavySetLabel.text = "Heaviest Weight Set:\n\(heavyWeightDate)\n\(heavySet)"
        
        getExerciseSetData()
        
//        view.addSubview(heavySetLine)
//        heavySetLine.topAnchor.constraint(equalTo: heavySetLabel.bottomAnchor, constant: 5).isActive = true
//        heavySetLine.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        heavySetLine.widthAnchor.constraint(equalToConstant: view.frame.width/1.1).isActive = true
//        heavySetLine.heightAnchor.constraint(equalToConstant: 4).isActive = true
//
//        view.addSubview(bestWorkoutLabel)
//        bestWorkoutLabel.topAnchor.constraint(equalTo: heavySetLine.bottomAnchor).isActive = true
//        bestWorkoutLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        bestWorkoutLabel.text = "Your best workout:\nDATA HERE"
        
    }
    
}

