//
//  UIViewController+helpers.swift
//  LiftingBuddy
//
//  Created by Logman on 6/2/19.
//  Copyright © 2019 Logman. All rights reserved.
//

import UIKit

extension UIViewController {

    func setupPlusButtonInNavBar(selector: Selector) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Icon_31-512"), style: .plain, target: self, action: selector)
    }
    
    func setupDataButtonInNavBar(selector: Selector) {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "data2"), style: .plain, target: self, action: selector)
    }
    
    func setupCancelButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
}











