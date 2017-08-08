 //
//  CalendarViewController.swift
//  Calendar_04
//
//  Created by jangsik han on 2017. 7. 27..
//  Copyright © 2017년 Design Goorm. All rights reserved.
//

import UIKit
import AVFoundation
import Speech

 
 protocol SpeechRecognizingViewDelegate {
    func speechRecognizingViewDidClickNext(view:SpeechRecognizingView)
    func speechRecognizingViewDidClickRetry(view:SpeechRecognizingView)
    func speechRecognizingViewDidFinished(view:SpeechRecognizingView, grade:Int)
 }
 
class SpeakingViewController: UIViewController {

    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))

    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    @IBOutlet weak var MonthFirstDigit: UIImageView!
    @IBOutlet weak var MonthSecondDigit: UIImageView!
    @IBOutlet weak var YearLabel: UILabel!

    @IBOutlet weak var lineBelowMonth: UIView!

    @IBOutlet weak var dayView: UIView!
    @IBOutlet weak var singleResultLightViolet: UIImageView!
    @IBOutlet weak var singleResultLightYello: UIImageView!
    @IBOutlet weak var singleResultTextSuccess: UIImageView!
    @IBOutlet weak var singleResultTextFail: UIImageView!
    
    @IBOutlet var MainView: UIView!
    @IBOutlet weak var maskImage: UIImageView!
//    @IBOutlet weak var lineMask: UIView!
    @IBOutlet weak var lineMask: UIImageView!

    @IBOutlet weak var micButtonDefault: UIButton!
    @IBOutlet weak var speechResultLabel: UILabel!
    
    var speechResult: String!
    
    var answerMonth = arc4random_uniform(12) + 1
    var answerDay = arc4random_uniform(31) + 1
    var answerYear = arc4random_uniform(100) + 1920
    var player : AVQueuePlayer?

    var correctAnswerMonth : String!
    var correctAnswerDay : String!
    var correctAnswerYear: String!
    var correctAnswerAll : String!
    
    var singleResultSound : AVAudioPlayer?
    var successFailSound : String = "successSound"
    var singleResultLight : UIImageView?
    var singleResultSuccessFail : UIImageView?
    
    @IBOutlet weak var pulse: UIView!
    

    
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        createCalendarTable()
        
        micButtonDefault.isEnabled = false
        
//        speechRecognizer?.delegate = self
        
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            
            var isButtonEnabled = false
            
            switch authStatus {
            case .authorized:
                isButtonEnabled = true
                
            case .denied:
                isButtonEnabled = false
                print("User denied access to speech recognition")
                
            case .restricted:
                isButtonEnabled = false
                print("Speech recognition restricted on this device")
                
            case .notDetermined:
                isButtonEnabled = false
                print("Speech recognition not yet authorized")
            }
            
            OperationQueue.main.addOperation() {
                self.micButtonDefault.isEnabled = isButtonEnabled
            }
        }
        
        
        switch answerMonth {
            case 10 :
                MonthFirstDigit.image = UIImage(named: "calender_num_month_1")
                MonthSecondDigit.image = UIImage(named: "calender_num_month_0")
            case 11 :
                MonthFirstDigit.image = UIImage(named: "calender_num_month_1")
                MonthSecondDigit.image = UIImage(named: "calender_num_month_1")
            case 12 :
                MonthFirstDigit.image = UIImage(named: "calender_num_month_1")
                MonthSecondDigit.image = UIImage(named: "calender_num_month_2")
            default :
                MonthFirstDigit.image = UIImage(named: "calender_num_month_0")
                MonthSecondDigit.image = UIImage(named: "calender_num_month_\(answerMonth)")
        }
        YearLabel.text = String(answerYear)

        
        
        
//        lineBelowMonth.transform = CGAffineTransform(scaleX:0.001, y:1)
//        lineBelowMonth.frame.size.width = 0
    
        correctAnswerMonth = "\(answerMonth)"
        correctAnswerDay = "\(answerDay)"
        correctAnswerYear = "\(answerYear)"
        
        self.MonthFirstDigit.alpha = 0
        self.MonthSecondDigit.alpha = 0
        self.YearLabel.alpha = 0
        self.singleResultLightYello.alpha = 0
        self.singleResultTextSuccess.alpha = 0
        self.singleResultLightViolet.alpha = 0
        self.singleResultTextFail.alpha = 0

        
        changeCorrectAnswer ()
        correctAnswerAll = "\(correctAnswerMonth!) \(correctAnswerDay!), \(correctAnswerYear!)"
        
    

        dayView.mask = maskImage
        lineBelowMonth.mask = lineMask
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        yearAppearAnimation()
        
    }

    
//    override func viewWillAppear(_ animated: Bool) {
//        singleResultLightAnimation()
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    
//    func createCalendarTable() {
//        for n in 1...31 {
//            
//            let DayOfCalendarImageView = UIImageView(frame: CGRect(
//                            x: CGFloat((n+1) % 7) * DayContainerView.frame.size.width/7,
//                            y: CGFloat((n+1) / 7) * DayContainerView.frame.size.height/5,
//                            width: DayContainerView.frame.size.width/7,
//                            height: DayContainerView.frame.size.height/5)
//            )
////            DayOfCalendarImageView.backgroundColor = UIColor.init(red: CGFloat(Float(n)/Float(31)), green: CGFloat(Float(n)/Float(31)), blue: CGFloat(Float(n)/Float(31)), alpha: 1.0)
    
//            if ( day == 선택한 day) {
//                빨간동그라미
//            }else {
//                일반
//            }
//            DayContainerView.addSubview(DayOfCalendarImageView)
//            DayOfCalendarImageView.image = UIImage(named: "calender_num_day_\(n)")
//        }
//    }
//    
//    func daySelectCircleAnimation() {
//        // answerDay 값을 받아와 해당 Day 번호에 빨간색 서클 애니메이션 구현
//    }
    

    
    
/*    func daySelectAnimation () {
        UIView.animate(withDuration: <#T##TimeInterval#>, animations: <#T##() -> Void#>, completion: <#T##((Bool) -> Void)?##((Bool) -> Void)?##(Bool) -> Void#>)
    }
*/    
    
    func changeCorrectAnswer () {
        
        switch correctAnswerMonth {
        case "1" :
            correctAnswerMonth = "January"
        case "2" :
            correctAnswerMonth = "February"
        case "3" :
            correctAnswerMonth = "March"
        case "4" :
            correctAnswerMonth = "April"
        case "5" :
            correctAnswerMonth = "May"
        case "6" :
            correctAnswerMonth = "June"
        case "7" :
            correctAnswerMonth = "July"
        case "8" :
            correctAnswerMonth = "August"
        case "9" :
            correctAnswerMonth = "September"
        case "10" :
            correctAnswerMonth = "October"
        case "11" :
            correctAnswerMonth = "November"
        case "12" :
            correctAnswerMonth = "December"
        default : break
        }
        
/*        switch correctAnswerDay {
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
*/
    }

    func yearAppearAnimation () {
        
        UIView.animate(withDuration: 0.6, animations: {self.YearLabel.alpha = 1})
        {(true) in self.monthAppearAnimation()}
    }
    
    
    
    func monthAppearAnimation () {

        UIView.animate(withDuration: 0.5, animations: {self.MonthFirstDigit.frame.origin.x = 17; self.MonthFirstDigit.alpha = 1; self.MonthSecondDigit.frame.origin.x = 53; self.MonthSecondDigit.alpha = 1})
            {(true) in self.lineBelowMonthAnimation()}
        
        
    }

    func lineBelowMonthAnimation () {
        UIView.animate(withDuration: 0.3, animations: {self.lineMask.frame.size.width = self.dayView.frame.size.width})
        {(true) in self.showDayAnimation()
            
        }
    }

    func showDayAnimation () {
        UIView.animate(withDuration: 1, animations: {self.maskImage.frame.size.height = self.dayView.frame.size.height})
        {(true) in
            
        }
    }

    
    
    func micInputAnimation () {
        // 마이크가 작동되고 음성을 입력받는 펄스 애니메이션
    }
    
    func micOutputAnimation () {
        // 시리로부터 입력받은 문자를 말풍선 형식으로 표현
    }
    
        
    func singleResultLightAnimation () {
        
        if correctAnswerMonth == speechResult {
            singleResultLight = singleResultLightYello
            singleResultSuccessFail = singleResultTextSuccess
            successFailSound = "successSound"
        } else {
            singleResultLight = singleResultLightViolet
            singleResultSuccessFail = singleResultTextFail
            successFailSound = "failSound"
        }
        
        UIView.animate(withDuration: Double(0.3), animations: {self.singleResultLight!.alpha = 1}) {
            (true) in
            self.singleResultSuccessFailAnimation()
        }
    }
    
    func singleResultSuccessFailAnimation () {
        UIView.animate(withDuration: Double(0.3), animations: {self.singleResultSuccessFail?.frame.origin.y += -10; self.singleResultSuccessFail?.alpha = 1}) {
            (true) in
            // 성공 또는 실패 결과값 저장
            // 타임 리밋을 제외한 설정을 초기화하고 리스닝 또는 스피킹 중 랜덤 선택
        }
        // 사운드가 재생되지 않음. 마이크와 충돌 가능성?
        let pathSuccessFailSound = Bundle.main.path(forResource: "audiofiles/effect/\(successFailSound)", ofType: "mp3")
        
        let urlSuccessFailSound = URL(fileURLWithPath: pathSuccessFailSound!)
        
        
        do {
            try singleResultSound = AVAudioPlayer(contentsOf: urlSuccessFailSound)
            singleResultSound?.play()
        }
        catch{
            
        }
    }


    
    func testSound() {
        
        let pathSuccessFailSound = Bundle.main.path(forResource: "audiofiles/effect/successSound", ofType: "mp3")
        
        let urlSuccessFailSound = URL(fileURLWithPath: pathSuccessFailSound!)
        
        
        do {
            try singleResultSound = AVAudioPlayer(contentsOf: urlSuccessFailSound)
            singleResultSound?.play()
        }
        catch{
            
        }

    }
    
    

    @IBAction func recordStart(_ sender: UIButton) {
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            micButtonDefault.isEnabled = true
            micButtonDefault.isSelected = false
            singleResultLightAnimation()
            
        } else {
            startRecording()
            micButtonDefault.isSelected = true

        }
        
    }
        
        
        func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
            if available {
                micButtonDefault.isEnabled = true
            } else {
                micButtonDefault.isEnabled = false
            }
        }
        
        
        func startRecording() {
            
            if recognitionTask != nil {
                recognitionTask?.cancel()
                recognitionTask = nil
            }
            
            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setCategory(AVAudioSessionCategoryRecord)
                try audioSession.setMode(AVAudioSessionModeMeasurement)
                try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
            } catch {
                print("audioSession properties weren't set because of an error.")
            }
            
            recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
            
            guard let inputNode = audioEngine.inputNode else {
                fatalError("Audio engine has no input node")
            }
            
            guard let recognitionRequest = recognitionRequest else {
                fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
            }
            
            recognitionRequest.shouldReportPartialResults = true
            

            recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
                
                var isFinal = false
                
                if result != nil {
                    
                    self.speechResultLabel.text = result?.bestTranscription.formattedString
                    self.speechResult = result?.bestTranscription.formattedString
                    isFinal = (result?.isFinal)!
                }
                
                if error != nil || isFinal {
                    self.audioEngine.stop()
                    inputNode.removeTap(onBus: 0)
                    
                    self.recognitionRequest = nil
                    self.recognitionTask = nil
                    
//                    self.micButtonDefault.isEnabled = true
                }
            })
            
            let recordingFormat = inputNode.outputFormat(forBus: 0)
            inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
                self.recognitionRequest?.append(buffer)
            }
            
            audioEngine.prepare()
            
            do {
                try audioEngine.start()
            } catch {
                print("audioEngine couldn't start because of an error.")
            }
            
            speechResultLabel.text = "Say something, I'm listening!"
        }
    
    var recentlyMicLevel:Float = 0
    // MARK: - SpeechRecognizingDelegate
    func speechRecognizing(_ speechRecognizing:SpeechRecognizing, listening:String, level:Float) {
        self.recentlyMicLevel = level
        self.performSelector(onMainThread: #selector(speechRecognizing.doPulse), with: nil, waitUntilDone: false);
    }
    
        
    func doPulse() {
        let level = self.recentlyMicLevel
        let LEVEL_MAX:Float = 2
        let CIRCLE_MAX:Float = 125
        let CIRCLE_MIN:Float = 64
        
        let rate = min(abs(level), LEVEL_MAX) / LEVEL_MAX
        
        let size = CGFloat((CIRCLE_MAX - CIRCLE_MIN) * rate + CIRCLE_MIN)
        
        print(level, rate, size)
        
        pulse.setWidth(size)
        pulse.setHeight(size)
        pulse.center = micButton.center
        _ = pulse.circle()
        
        pulse.isHidden = false
    }
        
        
        
}
