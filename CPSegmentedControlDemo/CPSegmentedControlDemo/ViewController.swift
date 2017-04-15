//
//  ViewController.swift
//  CPSegmentedControlDemo
//
//  Created by CP3 on 17/4/12.
//  Copyright © 2017年 CP3. All rights reserved.
//

import UIKit
import CPSegmentedControl

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let segCtrl = CPSegmentedControl(items: ["一", "二", "三"])
        segCtrl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
        segCtrl.translatesAutoresizingMaskIntoConstraints = false
        segCtrl.segmentSelected = { segment in
            print("segment = \(segment)")
        }
        view.addSubview(segCtrl)
        
        segCtrl.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 64).isActive = true
        segCtrl.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        segCtrl.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func segmentedControlValueChanged(_ sender: CPSegmentedControl) {
        print("index = \(sender.selectedSegmentIndex)")
    }


}

