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

    //Determine Phase Status
    func setCurrentStatus( PhaseCount: Int) -> String {
        let PhaseCount = PhaseCount
        switch PhaseCount {
        case 1:
            return "Preperation"
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
            return "Feedback Preperation"
        case 14:
            return "Feedback Negative"
        case 15:
            return "Feedback Affrimative"
        default:
            return "WSC Timer App"
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
    
    //reset button fuction
    @IBAction func resetButton(_ sender: UIButton) {
        timer.invalidate()
        phaseCount = 0
        displayTimeField.text = "00:00:00"
        CurrentStatusTextField.text = setCurrentStatus(PhaseCount: phaseCount)
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
            
        case 1://Type 1-Preperation stage, 15min
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
    var ProgressbarLoad: Double = progressBaContorler()
    func progressBaContorler() -> Double {
        switch phaseCount {
        case 1:
            return (15/Double(15-Double(Minutes)))*100
        case 2,6,10,4,8,12: return (4/Double(4-Double(minutes)))*100
        case 3,5,7,9,11: return (1/Double(1-Double(minutes)))*100
        case 13...15: return (1.5/(1.5-Double(minutes)))*100
        default:
            return 0
        }
    }
    
    //Progress bar Set Progress
    func set Progress bar(parameters) -> <#return type#> {
        <#function body#>
    }
}
