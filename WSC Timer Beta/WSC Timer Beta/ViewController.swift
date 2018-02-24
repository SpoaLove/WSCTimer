//
//  ViewController.swift
//  WSC Timer Beta
//
//  Created by Tengoku no Spoa on 2017/4/19.
//  Copyright © 2017年 Tengoku no Spoa. All rights reserved.
//

import UIKit
import AudioToolbox


class ViewController: UIViewController {
    
   //Initialize time Variables
    var minutes: UInt8 = 0
    var seconds: UInt8 = 0
    var fraction: UInt8 = 0

    
//Connects Status Text Field to View Controller
    @IBOutlet weak var CurrentStatusTextField: UILabel!
    //Initialize Phase Counter
    var phaseCount: Int = 0
    
    func loadSave(){
//        if userSaved {
//            phaseCount = UserDefaults.value(forKey: "savedPhase") as! Int
//            startTime = UserDefaults.value(forKey: "savedStartTime") as! TimeInterval
//        }
    }
    //Determine Phase Status
    func setCurrentStatus( PhaseCount: Int) -> String {
        let PhaseCount = PhaseCount
        switch PhaseCount {
        case 0:
            return "WSC Timer Pwapp"
        case 1:
            return "Preparation"
        case 2:
            return "Affrimative Speaker 1"
        case 6:
            return "Affrimative Speaker 2"
        case 10:
            return "Affrimative Speaker 3"
        case 4:
            return "Negative Speaker 1"
        case 8:
            return "Negative Speaker 2"
        case 12:
            return "Negative Speaker 3"
        case 3,5,7,9,11:
            return "Discussion"
        case 13:
            return "Feedback Preparation"
        case 14:
            return "Feedback Negative"
        case 15:
            return "Feedback Affrimative"
        default:
            return "End!"
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func endButton(_ sender: Any) {
        timer.invalidate()
    }
    
    // resetTimer
    fileprivate func resetTimer() {
        phaseCount = 0
        timer.invalidate()
        displayTimeField.text = "00:00:00"
        CurrentStatusTextField.text = setCurrentStatus(PhaseCount: phaseCount)
    }
    
    //reset button fuction

    @IBAction func resetButton(_ sender: UIButton) {
        resetTimer()
    }
    
    
    //Start Button Function
    @IBAction func startButton(_ sender: Any) {
        if (!timer.isValid) {
            
            //run update Time repeativelly
            let aSelector : Selector = #selector(ViewController.updateTime)
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
            
            //run Time Alert check repeativelly
            let bSelector: Selector = #selector(ViewController.timeAlert)
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: bSelector, userInfo: nil, repeats: true)
            
            //run End phase check  repeativelly
            let cSelector : Selector = #selector(ViewController.checkIfEndOfPhase)
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: cSelector, userInfo: nil, repeats: true)
            // define start time
            startTime = NSDate.timeIntervalSinceReferenceDate

        }
        
        //continue to next phase
        phaseCount += 1
        //set status label to corresponding phase
        CurrentStatusTextField.text = setCurrentStatus(PhaseCount: phaseCount)
    }
    
    //Initializing Time Display
    @IBOutlet weak var displayTimeField: UILabel!
    
    //initializing timer & timer variables
    var startTime = TimeInterval()
    var timer:Timer = Timer()

    
    //update function
    func updateTime() {
        if timer.isValid {
        let currentTime = NSDate.timeIntervalSinceReferenceDate
        
        var elapsedTime: TimeInterval = currentTime - startTime
        
        minutes = UInt8(elapsedTime / 60.0)
        elapsedTime -= (TimeInterval(minutes) * 60)
        
        //calculate the seconds in elapsed time.
        seconds = UInt8(elapsedTime)
        elapsedTime -= TimeInterval(seconds)
        
        //find out the fraction of milliseconds to be displayed.
        fraction = UInt8(elapsedTime * 100)
        
        //add the leading zero for minutes, seconds and millseconds and store them as string constants
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        let strFraction = String(format: "%02d", fraction)
        displayTimeField.text = "\(strMinutes):\(strSeconds):\(strFraction)"
        }
    }
    
    //Alert function
    func timeAlert() {
        
        //determine phase type
        switch phaseCount {
            
        case 1://Type 1-Preparation stage, 15min
            if minutes==15 && seconds==0 {
                let alertController = UIAlertController(title: "Times Up!", message:
                    "End of Discussion", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
                AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);

            }
        case 2,6,10,4,8,12://Type 2-Debate Speech, 4min each
            //3 min alert
            if minutes==3 && seconds==0 {
                let alertController2 = UIAlertController(title: "Time Alert", message:
                    "One Minute Remaining", preferredStyle: UIAlertControllerStyle.alert)
                alertController2.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                
                self.present(alertController2, animated: true, completion: nil)
                AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
            }
            //4 min alert
            else if minutes==4 && seconds==0 {
                let alertController3 = UIAlertController(title: "Times Up!", message:
                    "The Time is Up!", preferredStyle: UIAlertControllerStyle.alert)
                alertController3.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                
                self.present(alertController3, animated: true, completion: nil)
                AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
            }
        case 3,5,7,9,11://Type 3- Group Discussion, 1min each
            if minutes==1 && seconds==0 {
                let alertController4 = UIAlertController(title: "Times Up!", message:
                    "End of Discussion", preferredStyle: UIAlertControllerStyle.alert)
                alertController4.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                
                self.present(alertController4, animated: true, completion: nil)
                AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
            }

        case 13...15://Type 4- Feedbacks, 1:30min each
            if minutes==1 && seconds==30 {
                    let alertController5 = UIAlertController(title: "Times Up!", message:
                        "The time is up", preferredStyle: UIAlertControllerStyle.alert)
                    alertController5.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                    
                    self.present(alertController5, animated: true, completion: nil)
                    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
                }
        default:
            break
        }
    }
    
    //progress bar initialization
    @IBOutlet weak var ProgressView: UIProgressView!
    func progressBaContorler() -> Double {
        switch phaseCount {
        case 1:
            return (15/Double(15-Double(minutes)))*100
        case 2,6,10,4,8,12: return (4/Double(4-Double(minutes)))*100
        case 3,5,7,9,11: return (1/Double(1-Double(minutes)))*100
        case 13...15: return (1.5/(1.5-Double(minutes)))*100
        default:
            return 0
        }
    }
    
    // recap function
    @IBAction func recapButtonDidPressed(_ sender: UIButton) {
        
        // Return error if timer is not started
        if CurrentStatusTextField.text == "WSC Timer Pwapp" {
            let alert = UIAlertController(title: "Error", message: "You must start the timer to recap!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Dissmiss", style: UIAlertActionStyle.default, handler: nil
            ))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        // Generate formated output
        let formatedText = "\(CurrentStatusTextField.text ?? "Nil Status") : \(displayTimeField.text ?? "Nil Time") \n"
        print(formatedText)
        
        // save Recaps into userDefaults
        if let recaps = UserDefaults.standard.object(forKey: "Recaps"){
            let recapsString = recaps as! String
            UserDefaults.standard.set(recapsString+formatedText, forKey: "Recaps")
        }else{
            UserDefaults.standard.set(formatedText, forKey: "Recaps")

        }
    }
    
    // Check if the phase reach end
    func checkIfEndOfPhase(){
        if CurrentStatusTextField.text == "End!"{
            phaseCount = 0
            let alert = UIAlertController(title: "Reset?", message: "Do you want to reset?", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { [weak alert] (_) in
                self.resetTimer()
            }))
            alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // Option Button
    @IBAction func optionButtonDidPressed(_ sender: UIButton) {
        
        // if during timing show alert
        guard CurrentStatusTextField.text == "WSC Timer Pwapp" else {
            let alert = UIAlertController(title: "Warning!", message: "Leaving this page will stop the timer, do you wish to leave?", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { [weak alert] (_) in
                
                // save current status
                UserDefaults.standard.set(self.startTime, forKey: "savedStartTime")
                UserDefaults.standard.set(self.phaseCount,forKey: "savedPhase")
                UserDefaults.standard.set(true, forKey: "saved")
                
                self.performSegue(withIdentifier: "segueToPreferences", sender: self)
            }))
            alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        // preform segue
        self.performSegue(withIdentifier: "segueToPreferences", sender: self)
    }

    
}

