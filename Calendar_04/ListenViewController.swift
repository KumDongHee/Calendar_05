//
//  ViewController.swift
//  Calendar_04
//
//  Created by jangsik han on 2017. 7. 24..
//  Copyright © 2017년 Design Goorm. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

extension UITextField{
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSForegroundColorAttributeName: newValue!])
        }
    }
}

class ListenViewController: UIViewController {
    
    // 커밋용 주석

    @IBOutlet weak var monthTextField: UITextField!
    @IBOutlet weak var dayTextField: UITextField!
    @IBOutlet weak var yearTextField: UITextField!
    

    
    
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var DisplayDigit: UIView!
    @IBOutlet weak var TimeLimitUIView: UIView!
    @IBOutlet weak var TimeLimitLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var TimeLimitTrailingConstraint: NSLayoutConstraint!

    @IBOutlet weak var singleResultLightYello: UIImageView!
    @IBOutlet weak var singleResultLightViolet: UIImageView!

    @IBOutlet weak var singleResultTextSuccess: UIImageView!
    @IBOutlet weak var singleResultTextFail: UIImageView!

//    @IBOutlet weak var DisplayDigitTopConstraint: NSLayoutConstraint!
//    @IBOutlet weak var DisplayDigitBottomConstraint: NSLayoutConstraint!

    @IBOutlet weak var correctAnswerAll: UILabel!
    
    
    
    
    var activeTextField : UITextField!
    var player : AVQueuePlayer?

    var answerMonth = arc4random_uniform(12) + 1
    var answerDay = arc4random_uniform(31) + 1
    var answerYear = arc4random_uniform(100) + 1920

    var singleResultSound : AVAudioPlayer?
    var successFailSound : String = "successSound"
    var singleResultLight : UIImageView?
    var singleResultSuccessFail : UIImageView?

    
    var correctAnswerMonth : String!
    var correctAnswerDay : String!
    var correctAnswerYear: String!
    
    
    
    
//    let startTime = Date.timeIntervalSinceReferenceDate
//    let currentTime = Date.timeIntervalSinceReferenceDate
//    var elapsedTime:TimeInterval = currentTime - startTime
    

    
    
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dummyView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        monthTextField.inputView = dummyView
        dayTextField.inputView = dummyView
        yearTextField.inputView = dummyView
        
        monthTextField.becomeFirstResponder()
        
//        button01.contentMode = UIViewContentMode.scaleAspectFit
//        button01.imageView?.contentMode = .scaleAspectFit // o
//        TimeLimitUIView.layer.anchorPoint = CGPoint(x:0,y:0)
//        self.TimeLimitUIView.frame.origin.x = 50
//        self.TimeLimitUIView.frame.origin.y = -2
//        TimeLimitUIView.center.x = 0
 //       TimeLimitUIView.center.y = 0
//        TimeLimitUIView.layer.anchorPoint = CGPoint(x: 0, y: 0)
//        TimeLimitUIView.transform.translatedBy(x: 0, y: -10)
        
//        timeLimitAnimation()
        self.singleResultLightYello.alpha = 0
        self.singleResultTextSuccess.alpha = 0
        self.singleResultLightViolet.alpha = 0
        self.singleResultTextFail.alpha = 0
        
//        timeStart = Date()
        
        correctAnswerMonth = "\(answerMonth)"
        correctAnswerDay = "\(answerDay)"
        correctAnswerYear = "\(answerYear)"

        
        correctAnswerAll.alpha = 0
        
        changeCorrectAnswer ()
        correctAnswerAll.text! = "\(correctAnswerMonth!) \(correctAnswerDay!) \(correctAnswerYear!)"
        
        self.TimeLimitTrailingConstraint.constant = mainView.frame.width
        
//        monthTextField.attributedPlaceholder = NSAttributedString(string:"month", attributes: [NSForegroundColorAttributeName: UIColor.yellow])

        
    }
    
 
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        timeLimitAnimation ()
//        gameOver()
        
       
        perform(#selector(ListenViewController.playSound), with: nil, afterDelay: 0.5)
        
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
//
//        gameOver()
//    }
    
    
    @IBAction func textEditingdidBegin(_ sender: UITextField) {
        activeTextField = sender
    }

    
    @IBAction func textEditingdidEnd(_ sender: UITextField) {
        activeTextField = nil
    }
    
    @IBAction func numbutton(_ sender: UIButton) {
        buttonAction(number: sender.currentTitle!)
    }
    
    
    @IBAction func speakerButtonTouch(_ sender: UIButton) {
        playSound()
    }
    
    @IBAction func deleteButton(_ sender: UIButton) {
        deleteText()
    }

    
    
    func changeCorrectAnswer () {

        switch correctAnswerMonth {
        case "1" :
            correctAnswerMonth = "Jan"
        case "2" :
            correctAnswerMonth = "Feb"
        case "3" :
            correctAnswerMonth = "Mar"
        case "4" :
            correctAnswerMonth = "Apr"
        case "5" :
            correctAnswerMonth = "May"
        case "6" :
            correctAnswerMonth = "Jun"
        case "7" :
            correctAnswerMonth = "Jul"
        case "8" :
            correctAnswerMonth = "Aug"
        case "9" :
            correctAnswerMonth = "Sep"
        case "10" :
            correctAnswerMonth = "Oct"
        case "11" :
            correctAnswerMonth = "Nov"
        case "12" :
            correctAnswerMonth = "Dec"
        default : break
        }
        
        switch correctAnswerDay {
        case "1" :
            correctAnswerDay = "1st,"
        case "2" :
            correctAnswerDay = "2nd,"
        case "3" :
            correctAnswerDay = "3rd,"
        case "21" :
            correctAnswerDay = "21st,"
        case "22" :
            correctAnswerDay = "22nd,"
        case "23" :
            correctAnswerDay = "23rd,"
        case "31" :
            correctAnswerDay = "31st,"
        default :
            correctAnswerDay = "\(answerDay)th,"
        }
    }
    
    func buttonAction (number: String) {
        if (activeTextField != nil) {
            activeTextField.text = activeTextField.text! + "\(number)"
        }
        switch activeTextField {
        case monthTextField where monthTextField.text?.lengthOfBytes(using: String.Encoding.ascii) == 2:
            dayTextField.becomeFirstResponder()
        case dayTextField where dayTextField.text?.lengthOfBytes(using: String.Encoding.ascii) == 2:
            yearTextField.becomeFirstResponder()
        case yearTextField where yearTextField.text?.lengthOfBytes(using: String.Encoding.ascii) == 4:
            singleResultTextAnimation ()
            
        default : break
        }
    }
    
    func singleResultTextAnimation () {
        if answerMonth == UInt32(monthTextField.text!) && answerDay == UInt32(dayTextField.text!) && answerYear == UInt32(yearTextField.text!) {
            singleResultLight = singleResultLightYello
            singleResultSuccessFail = singleResultTextSuccess
            successFailSound = "successSound"
        } else {
            singleResultLight = singleResultLightViolet
            singleResultSuccessFail = singleResultTextFail
            successFailSound = "failSound"
        }

        
        UIView.animate(withDuration: Double(0.5), animations: {self.DisplayDigit.frame.origin.y += -45}) {
            (true) in
            self.singleResultLightAnimation()
 //           self.DisplayDigitTopConstraint.constant = self.DisplayDigitTopConstraint.constant - 45
//            self.DisplayDigitBottomConstraint.constant = 100
        }
    }
 
    func singleResultLightAnimation () {
        UIView.animate(withDuration: Double(0.3), animations: {self.singleResultLight!.alpha = 1; self.correctAnswerAll.alpha = 1}) {
            (true) in
            self.singleResultSuccessFailAnimation()
        }
    }
    
    func singleResultSuccessFailAnimation () {
        UIView.animate(withDuration: Double(0.3), animations: {self.singleResultSuccessFail?.frame.origin.y += -10; self.singleResultSuccessFail?.alpha = 1}) {
            (true) in
            
        }

        let pathSuccessFailSound = Bundle.main.path(forResource: "audiofiles/effect/\(successFailSound)", ofType: "mp3")

        let urlSuccessFailSound = URL(fileURLWithPath: pathSuccessFailSound!)


        do {
            try singleResultSound = AVAudioPlayer(contentsOf: urlSuccessFailSound)
            singleResultSound?.play()
        }
        catch{
            
        }
    }
    
    
    
    
    func timeLimitAnimation () {

        UIView.animate (withDuration: 60,animations: {
//            self.TimeLimitLeadingConstraint.constant = -375
            self.TimeLimitTrailingConstraint.constant = 0
            self.view.layoutIfNeeded()
        }) {(true) in
            // 전체 결과값이 나옴
        }
        
    }
    
    
    
    func playSound(){
        
        let path_month = Bundle.main.path(forResource: "audiofiles/month/\(answerMonth)", ofType: "mp3")!
        let path_day = Bundle.main.path(forResource: "audiofiles/day/\(answerDay)", ofType: "mp3")!
        let path_year = Bundle.main.path(forResource: "audiofiles/year/\(answerYear)", ofType: "mp3")!
        
        let url_month = URL(fileURLWithPath: path_month)
        let url_day = URL(fileURLWithPath: path_day)
        let url_year = URL(fileURLWithPath: path_year)
        
        let item1 = AVPlayerItem(url: url_month)
        let item2 = AVPlayerItem(url: url_day)
        let item3 = AVPlayerItem(url: url_year)
        
        do {
            player = AVQueuePlayer(items: [item1, item2, item3])
            
            player?.play()
        }
    }


    
    
    func deleteText () {

        switch activeTextField {
        case monthTextField where monthTextField.text?.lengthOfBytes(using: String.Encoding.ascii) == 0:
            break
        case dayTextField where dayTextField.text?.lengthOfBytes(using: String.Encoding.ascii) == 0:
            monthTextField.becomeFirstResponder()
        case yearTextField where yearTextField.text?.lengthOfBytes(using: String.Encoding.ascii) == 0:
            dayTextField.becomeFirstResponder()
        default : break
        }
        activeTextField.text = String.init(activeTextField.text!.characters.dropLast())
    }
    
//    func gameOver () {
//              if elapsedTime == 10 {
//            print("time")
    
//        }
//    }

    
    
}

