//
//  PreferencesViewController.swift
//  WSC Timer Beta
//
//  Created by Tengoku no Spoa on 2017/11/16.
//  Copyright © 2017年 Tengoku no Spoa. All rights reserved.
//

import UIKit

class PreferencesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if let recapsMessages = UserDefaults.standard.object(forKey: "Recaps"){
            let realMessage = recapsMessages as! String
            recapsText.text = realMessage
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonDidPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "segueToHome", sender: self)
    }
    
    @IBAction func resetButtonDidPressed(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: "Warning!", message:
            "Are you sure about resetting the Recaps?", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default,handler: { [weak alertController] (_) in
            self.resetRecaps()
        }))
        
        alertController.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion:nil)
    
    }
    @IBOutlet weak var recapsText: UITextView!
    
    func resetRecaps(){
        UserDefaults.standard.set("Recaps:\n", forKey: "Recaps")
        recapsText.text = "Recaps: \n"
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
