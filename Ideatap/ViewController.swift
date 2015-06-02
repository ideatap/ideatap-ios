//
//  ViewController.swift
//  Ideatap
//
//  Created by Viktor Gardart on 02/06/15.
//  Copyright (c) 2015 Ideatap. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var conditionField: UITextField!
    
    var fb = Firebase(url:"https://idea-tap.firebaseio.com/condition")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        fb.observeEventType(.Value, withBlock: { snapshot in
            if let condition = snapshot.value as? String {
                self.conditionLabel.text = condition
            }
        })
        
    }
    
    @IBAction func updateCondition(sender: AnyObject) {
        fb.setValue(conditionField.text)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

