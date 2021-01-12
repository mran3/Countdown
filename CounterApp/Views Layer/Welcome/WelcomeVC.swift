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
    @IBOutlet weak var firstInfo: UILabel!
    @IBOutlet weak var secondInfo: UILabel!
    @IBOutlet weak var thirdInfo: UILabel!
    
    override func viewDidLoad() {
        continueBtn.layer.cornerRadius = 10
        continueBtn.clipsToBounds = true
        super.viewDidLoad()
        setUpLabels()
    }
    
    @IBAction func continueTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ListCountersVC") as! CountersListVC
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func setUpLabels(){
        
        
        let attributedFirst = "<b>Add almost anything</b><br/>Capture cups of lattes, frapuccinos, or anything else that can be counted.".htmlToAttributedString
        
        let attributedSecond = "<b>Count to self, or with anyone</b><br/>Others can view or make changes. There’s no authentication API.".htmlToAttributedString
        
        let attributedThird = "<b>Count your thoughts</b><br/>Possibilities are literally endless.".htmlToAttributedString
        
        let font = UIFont.systemFont(ofSize: 17, weight: .bold)
        
        attributedFirst?.setFontFace(font: font)
        attributedSecond?.setFontFace(font: font)
        attributedThird?.setFontFace(font: font)
        
        firstInfo.attributedText = attributedFirst
        secondInfo.attributedText = attributedSecond
        thirdInfo.attributedText = attributedThird
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
}
