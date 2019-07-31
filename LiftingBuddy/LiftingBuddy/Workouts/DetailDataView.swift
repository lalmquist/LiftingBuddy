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
    

    
    override func viewDidAppear(_ animated: Bool) {
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        navigationItem.title = exerciseStr
        
        setupCancelButton()
        
        
        setupUI()
        
    }
    
    let bestSetLabel: UILabel = {
        let label = UILabel()
        label.text = "BEST SET HERE"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let best1RMLabel: UILabel = {
        let label = UILabel()
        label.text = "BEST 1 REP MAX HERE"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let bestWorkoutLabel: UILabel = {
        let label = UILabel()
        label.text = "BEST WORKOUT HERE"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private func setupUI() {
        
        view.addSubview(bestSetLabel)
        bestSetLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        bestSetLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(best1RMLabel)
        best1RMLabel.topAnchor.constraint(equalTo: bestSetLabel.bottomAnchor).isActive = true
        best1RMLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(bestWorkoutLabel)
        bestWorkoutLabel.topAnchor.constraint(equalTo: best1RMLabel.bottomAnchor).isActive = true
        bestWorkoutLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
    }
    
}

