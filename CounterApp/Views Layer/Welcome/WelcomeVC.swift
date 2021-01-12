//
//  WelcomeVC.swift
//  CounterApp
//
//  Created by Andres Acevedo on 12/01/21.
//  Copyright © 2021 Andres Acevedo. All rights reserved.
//

import UIKit

class WelcomeVC: UIViewController {

    @IBOutlet weak var continueBtn: UIButton!
    
    override func viewDidLoad() {
        continueBtn.layer.cornerRadius = 10
        continueBtn.clipsToBounds = true
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func continueTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ListCountersVC") as! CountersListVC
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
