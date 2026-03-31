//
//  ViewController.swift
//  Emoji Math
//
//  Created by Nir Hayun on 17/06/2017.
//  Copyright © 2017 Nir Hayun. All rights reserved.
//

import UIKit

final class MainController: UIViewController {
    
    var currentEquations: [[String]] = []
    var buttonColor = UIColor(red: 21/255.0, green: 126/255.0, blue: 251/255.0, alpha: 1)
    var rightAnswerColor: UIColor = UIColor(red: 0/255, green: 230.0/255, blue: 115.0/255, alpha: 1.0)
    var wrongAnswerColor: UIColor = UIColor(red: 255.0/255, green: 77.0/255, blue: 77.0/255, alpha: 1.0)

    var addScore = 0
    var gameScore = 0
    var gameLevel = 0
    var rightAnswerPlacement = 0
    var gameStages: Stages = Stages()
    var saveData: SaveData = SaveData()
    var touchEndPosition: CGPoint = CGPoint()
    
    var timer: Timer!
    var timeCount: Int = 0
    var totalTimerCount = 0
    
    var hintHintNum = 0
    var hintFiftyNum = 0
    var hintTimerNum = 0
    var displayOutOfTime = true
    var exitButtonAvailableTime = 0
    var activateHintHint = true
    var activateFiftyHint = true
    var activateTimerHint = true
    
    let delegate = UIApplication.shared.delegate as! AppDelegate
    let vibrationGenerator = UIImpactFeedbackGenerator(style: .light)
    
    var makeCanvasClear = true
    var canvasPath = UIBezierPath()
    var startPoint = CGPoint()
    var touchPoint = CGPoint()
    
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    
    
    @IBOutlet weak var hintHintButton: UIButton!
    @IBOutlet weak var hintFiftyButton: UIButton!
    @IBOutlet weak var hintTimerButton: UIButton!
    @IBOutlet weak var exitButton: UIButton!
    
    
    @IBOutlet weak var firstEquationFirstElement: UIImageView!
    @IBOutlet weak var firstEquationFirstOperator: UIImageView!
    @IBOutlet weak var firstEquationSecondElement: UIImageView!
    @IBOutlet weak var firstEquationSecondOperator: UIImageView!
    @IBOutlet weak var firstEquationThirdElement: UIImageView!
    @IBOutlet weak var firstEquationEqual: UIImageView!
    @IBOutlet weak var firstAnswer: UILabel!

    
    @IBOutlet weak var secondEquationFirstElement: UIImageView!
    @IBOutlet weak var secondEquationFirstOperator: UIImageView!
    @IBOutlet weak var secondEquationSecondElement: UIImageView!
    @IBOutlet weak var secondEquationSecondOperator: UIImageView!
    @IBOutlet weak var secondEquationThirdElement: UIImageView!
    @IBOutlet weak var secondEquationEqual: UIImageView!
    @IBOutlet weak var secondAnswer: UILabel!
    

    @IBOutlet weak var thirdEquationFirstElement: UIImageView!
    @IBOutlet weak var thirdEquationFirstOperator: UIImageView!
    @IBOutlet weak var thirdEquationSecondElement: UIImageView!
    @IBOutlet weak var thirdEquationSecondOperator: UIImageView!
    @IBOutlet weak var thirdEquationThirdElement: UIImageView!
    @IBOutlet weak var thirdEquationEqual: UIImageView!
    @IBOutlet weak var thirdAnswer: UILabel!
    
    
    @IBOutlet weak var fourthEquationFirstElement: UIImageView!
    @IBOutlet weak var fourthEquationFirstOperator: UIImageView!
    @IBOutlet weak var fourthEquationSecondElement: UIImageView!
    @IBOutlet weak var fourthEquationSecondOperator: UIImageView!
    @IBOutlet weak var fourthEquationThirdElement: UIImageView!
    @IBOutlet weak var fourthEquationEqual: UIImageView!
    @IBOutlet weak var fourthAnswer: UILabel!
    
    
    @IBOutlet weak var fifthEquationFirstElement: UIImageView!
    @IBOutlet weak var fifthEquationFirstOperator: UIImageView!
    @IBOutlet weak var fifthEquationSecondElement: UIImageView!
    @IBOutlet weak var fifthEquationSecondOperator: UIImageView!
    @IBOutlet weak var fifthEquationThirdElement: UIImageView!
    @IBOutlet weak var fifthEquationEqual: UIImageView!
    @IBOutlet weak var fifthAnswer: UILabel!
    
    
    @IBOutlet weak var leftTopButton: UIButton!
    @IBOutlet weak var rightTopButton: UIButton!
    @IBOutlet weak var leftBottomButton: UIButton!
    @IBOutlet weak var rightBottomButton: UIButton!
    
    
    @IBOutlet weak var leftHintView: UIView!
    @IBOutlet weak var answerImage: UIImageView!
    
    
    @IBOutlet weak var canvasView: UIView!
    @IBOutlet weak var canvasButtonView: UIView!
    @IBOutlet weak var canvasConstraint: NSLayoutConstraint!
    @IBOutlet weak var noteButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var clearCanvasButton: UIButton!
    @IBOutlet weak var transparentCanvas: UIButton!
    
    
    @IBAction func exitClick(_ sender: Any) {
        saveData.incrementGamesPlayed()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func hintHintClick(_ sender: UITapGestureRecognizer) {
        if (activateHintHint) {
            vibrateAndMakeSound(sound: "hint")
            changeHintIcons()
            hintHintNum -= 1
            saveData.setHintHint(hint: hintHintNum)
            enableDisableHintButtons(forceEnable: false)
            hideHintHintIcon()
            hintHintButton.isEnabled = false
            hintHintButton.alpha = 0.5
        }
    }
    
    @IBAction func showHintRemain(_ sender: UILongPressGestureRecognizer) {
        Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(MainController.hideHintHintIcon), userInfo: nil, repeats: false)
        Timer.scheduledTimer(timeInterval: 5.5, target: self, selector: #selector(MainController.showHintHintIcon), userInfo: nil, repeats: false)
    }
    
    @IBAction func hintFiftyClick(_ sender: UITapGestureRecognizer) {
        if (activateFiftyHint) {
            vibrateAndMakeSound(sound: "fifty")
            let answerButtons: [UIButton] = [leftTopButton, rightTopButton, leftBottomButton, rightBottomButton]
            
            var firstAnswerToBeDisable = 0
            for _ in 0...1 {
                var buttonIndex = Int.random(in: 1...4)
                while (buttonIndex == rightAnswerPlacement || buttonIndex == firstAnswerToBeDisable) {
                    buttonIndex = Int.random(in: 1...4)
                }
                firstAnswerToBeDisable = buttonIndex
                answerButtons[buttonIndex - 1].isEnabled = false
                answerButtons[buttonIndex - 1].alpha = 0.5
            }
            
            hintFiftyNum -= 1
            saveData.setHintFifty(hint: hintFiftyNum)
            enableDisableHintButtons(forceEnable: false)
            hideHintFiftyIcon()
            hintFiftyButton.isEnabled = false
            hintFiftyButton.alpha = 0.5
        }
    }
    
    @IBAction func showFiftyRemain(_ sender: UILongPressGestureRecognizer) {
        Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(MainController.hideHintFiftyIcon), userInfo: nil, repeats: false)
        Timer.scheduledTimer(timeInterval: 5.5, target: self, selector: #selector(MainController.showHintFiftyIcon), userInfo: nil, repeats: false)
    }
    
    @IBAction func hintTimerClick(_ sender: UITapGestureRecognizer) {
        if (activateTimerHint) {
            vibrateAndMakeSound(sound: "time")
            self.delegate.timer += self.totalTimerCount
            self.timeCount += self.totalTimerCount
            hintTimerNum -= 1
            saveData.setHintTimer(hint: hintTimerNum)
            enableDisableHintButtons(forceEnable: false)
            hideHintTimerIcon()
            hintTimerButton.isEnabled = false
            hintTimerButton.alpha = 0.5
        }
    }
    
    @IBAction func showTimerRemain(_ sender: UILongPressGestureRecognizer) {
        Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(MainController.hideHintTimerIcon), userInfo: nil, repeats: false)
        Timer.scheduledTimer(timeInterval: 5.5, target: self, selector: #selector(MainController.showHintTimerIcon), userInfo: nil, repeats: false)
    }
    
    @IBAction func answer1(_ sender: UIButton) {
        let answerButtons = [leftTopButton, rightTopButton, leftBottomButton, rightBottomButton]
        timer.invalidate()
        self.setButtonsEnable(isEnable: false)
        self.answerImage.isHidden = false
        if (sender.tag == rightAnswerPlacement) {
            vibrationGenerator.impactOccurred()
            if (saveData.isSoundOn()) {
                AudioManager.shared.play("sound.correct.answer")
            }
            if let img = UIImage(named: "answer.correct") {
                self.answerImage.image = img.withRenderingMode(.alwaysTemplate)
                self.answerImage.tintColor = self.rightAnswerColor
            }
            self.scoreLabel.attributedText = getScoreColorString(reduce: false)
            Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { [weak self] _ in
                self?.setCorrectAnswerImage()
            }
        } else {
            if let img = UIImage(named: "answer.wrong") {
                self.answerImage.image = img.withRenderingMode(.alwaysTemplate)
                self.answerImage.tintColor = self.wrongAnswerColor
            }
            if (gameScore > 0) {
                self.scoreLabel.attributedText = getScoreColorString(reduce: true)
            }
            Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { [weak self] _ in
                self?.setWrongAnswerImage()
            }
            UIView.animate(withDuration: 0.01, animations: {
                answerButtons[self.rightAnswerPlacement - 1]!.backgroundColor = self.rightAnswerColor
                if (self.saveData.isSoundOn()) {
                    AudioManager.shared.play("sound.wrong.answer")
                }
            }, completion: { _ in
                answerButtons[self.rightAnswerPlacement - 1]!.backgroundColor = self.buttonColor
            })
        }
        
    }
    
    @IBAction func openCanvas(_ sender: Any) {
        enterCanvasAndExitNoteButton()
    }
    
    @IBAction func closeCanvas(_ sender: Any) {
        exitCanvasAndEnterNoteButton()
    }
    
    @IBAction func clearCanvas(_ sender: Any) {
        canvasPath.removeAllPoints()
        while ((canvasView.layer.sublayers?.count ?? 0) > 1) {
            _ = canvasView.layer.sublayers?.popLast()
        }
        canvasView.setNeedsDisplay()
    }
    
    @IBAction func canvasTransparent(_ sender: Any) {
        if (makeCanvasClear) {
            canvasView.backgroundColor = UIColor(white: 1, alpha: 0.8)
            canvasButtonView.backgroundColor = UIColor(white: 1, alpha: 0.8)
            transparentCanvas.setImage(UIImage(named: "canvasNonTransparent"), for: .normal)
        } else {
            canvasView.backgroundColor = UIColor(white: 1, alpha: 1.0)
            canvasButtonView.backgroundColor = UIColor(white: 1, alpha: 1.0)
            transparentCanvas.setImage(UIImage(named: "canvasTransparent"), for: .normal)
        }
        makeCanvasClear = !makeCanvasClear
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeCanvas()
        initializeScoreAndHints()
        initializeConstraintsForAnimations()
        setLevelButtonsColorsAndBackground()
        centerHintButtonsText()
        answerImage.image = UIImage(named: "answer.wrong")
        answerImage.isHidden = true
        AdManager.shared.loadInterstitial()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        timer = nil
        saveUserScoreToGameCenter()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        turnHintButtonsRound()
        
        if(timer != nil) {
            timer.invalidate()
        }
        timer = Timer(timeInterval: 1.0, target: self, selector: #selector(MainController.timerDidFire), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: RunLoop.Mode.common)

        newQuestion()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let point = touch?.location(in: canvasView) {
            startPoint = point
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let point = touch?.location(in: canvasView) {
            touchPoint = point
        }
        
        canvasPath.move(to: startPoint)
        canvasPath.addLine(to: touchPoint)
        startPoint = touchPoint
        draw()
    }
    
    func initializeConstraintsForAnimations() {
        canvasConstraint.constant += view.bounds.height
    }
    
    func initializeCanvas() {
        canvasView.clipsToBounds = true
        canvasView.isMultipleTouchEnabled = false
    }
    
    func draw() {
        let strokeLayer = CAShapeLayer()
        strokeLayer.fillColor = nil
        strokeLayer.strokeColor = UIColor.black.cgColor
        strokeLayer.path = canvasPath.cgPath
        canvasView.layer.addSublayer(strokeLayer)
        canvasView.setNeedsDisplay()
    }
    
    func enterCanvasAndExitNoteButton() {
        let duration = 0.3
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
            self.canvasConstraint.constant -= self.view.bounds.height
            self.view.layoutIfNeeded()
        }, completion: nil)
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
            self.noteButtonConstraint.constant -= self.view.bounds.height
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func exitCanvasAndEnterNoteButton() {
        let duration = 0.3
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
            self.canvasConstraint.constant += self.view.bounds.height
            self.view.layoutIfNeeded()
        }, completion: nil)
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
            self.noteButtonConstraint.constant += self.view.bounds.height
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            touchEndPosition = touch.location(in: view)
        }
    }
    
    func enableExitButton() {
        exitButton.isEnabled = true
        exitButton.alpha = 1.0
    }
    
    func disableExitButton() {
        exitButton.isEnabled = false
        exitButton.alpha = 0.5
    }
    
    func getScoreColorString(reduce: Bool) -> NSMutableAttributedString {
        let scoreAttrStr = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17), NSAttributedString.Key.foregroundColor : gameStages.stages[gameLevel].textColor] as [NSAttributedString.Key : Any]
        
        let attributedStringScore = NSMutableAttributedString(string: "Score: ", attributes: scoreAttrStr)
        
        var numAttrStr = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17), NSAttributedString.Key.foregroundColor : rightAnswerColor]
        var numStr = "+\(addScore)"
        if (reduce) {
            numAttrStr = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17), NSAttributedString.Key.foregroundColor : wrongAnswerColor]
            numStr = "-\(self.calcScoreReduction())"
        }
        
        let attributedStringNum = NSMutableAttributedString(string: numStr, attributes: numAttrStr)
        
        attributedStringScore.append(attributedStringNum)
        return attributedStringScore
    }
    
    func getButtonString(remain: Int) -> NSMutableAttributedString {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 0.1
        style.minimumLineHeight = 5
        style.alignment = .center
        
        let remainAttrStr = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 25), NSAttributedString.Key.foregroundColor : UIColor.white]
        
        let attributedStringRemain = NSMutableAttributedString(string: "\(remain)", attributes: remainAttrStr)
        
        attributedStringRemain.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSRange(location: 0, length: attributedStringRemain.length))
        
        let remainStringAttrStr = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 10), NSAttributedString.Key.foregroundColor : UIColor.white]
        let remainStr = "\nRemain"
        
        let attributedStringNum = NSMutableAttributedString(string: remainStr, attributes: remainStringAttrStr)
        
        attributedStringRemain.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSRange(location: 0, length: attributedStringRemain.length))
        
        attributedStringRemain.append(attributedStringNum)
        
        return attributedStringRemain
    }
    
    func initializeScoreAndHints() {
        gameScore = saveData.getScore()
        scoreLabel.text = "Score: \(gameScore)"
        gameLevel = gameStages.getLevelByScore(score: gameScore)
        hintHintNum = saveData.getHintHint()
        hintFiftyNum = saveData.getHintFifty()
        hintTimerNum = saveData.getHintTimer()
    }
    
    func vibrateAndMakeSound(sound: String) {
        if (saveData.isSoundOn()) {
            if (sound == "hint") {
                AudioManager.shared.play("sound.hint")
            } else if (sound == "fifty") {
                AudioManager.shared.play("sound.fifty")
            } else if (sound == "time") {
                AudioManager.shared.play("sound.timer")
            } else {
                AudioManager.shared.play("sound.button.click")
            }
        }
        vibrationGenerator.impactOccurred()
    }
    
    func centerHintButtonsText() {
        hintHintButton.titleLabel?.textAlignment = NSTextAlignment.center
        hintFiftyButton.titleLabel?.textAlignment = NSTextAlignment.center
        hintTimerButton.titleLabel?.textAlignment = NSTextAlignment.center
    }
    
    @objc func showHintHintIcon() {
        activateHintHint = true
        hintHintButton.setImage(UIImage(named: "main.hint.png"), for: .normal)
        hintHintButton.setTitle(nil, for: .normal)
    }
    
    @objc func hideHintHintIcon() {
        activateHintHint = false
        hintHintButton.setImage(nil, for: .normal)
        hintHintButton.setTitle("\(hintHintNum)", for: .normal)
    }
    
    @objc func showHintFiftyIcon() {
        activateFiftyHint = true
        hintFiftyButton.setImage(UIImage(named: "main.fifty.png"), for: .normal)
        hintFiftyButton.setTitle(nil, for: .normal)
    }
    
    @objc func hideHintFiftyIcon() {
        activateFiftyHint = false
        hintFiftyButton.setImage(nil, for: .normal)
        hintFiftyButton.setTitle("\(hintFiftyNum)", for: .normal)
    }
    
    @objc func showHintTimerIcon() {
        activateTimerHint = true
        hintTimerButton.setImage(UIImage(named: "main.timer.png"), for: .normal)
        hintTimerButton.setTitle(nil, for: .normal)
    }
    
    @objc func hideHintTimerIcon() {
        activateTimerHint = false
        hintTimerButton.setImage(nil, for: .normal)
        hintTimerButton.setTitle("\(hintTimerNum)", for: .normal)
    }
    
    @objc func showHintIcons() {
        showHintHintIcon()
        showHintFiftyIcon()
        showHintTimerIcon()
    }
    
    func enableDisableHintButtons(forceEnable: Bool) {
        if (hintHintNum <= 0) {
            hintHintButton.isEnabled = false
            hintHintButton.alpha = 0.5;
        } else if (forceEnable) {
            hintHintButton.isEnabled = true
            hintHintButton.alpha = 1.0;
        }
        
        if (hintFiftyNum <= 0) {
            hintFiftyButton.isEnabled = false
            hintFiftyButton.alpha = 0.5;
        } else if (forceEnable) {
            hintFiftyButton.isEnabled = true
            hintFiftyButton.alpha = 1.0;
        }
        
        if (hintTimerNum <= 0) {
            hintTimerButton.isEnabled = false
            hintTimerButton.alpha = 0.5;
        } else if (forceEnable) {
            hintTimerButton.isEnabled = true
            hintTimerButton.alpha = 1.0;
        }
        
        if (forceEnable) {
            enableExitButton()
        }

    }
    
    @objc func turnHintButtonsRound() {
        hintHintButton.layer.cornerRadius = hintFiftyButton.bounds.size.width / 2.0
        hintFiftyButton.layer.cornerRadius = hintFiftyButton.bounds.size.width / 2.0
        hintTimerButton.layer.cornerRadius = hintTimerButton.bounds.size.width / 2.0
        exitButton.layer.cornerRadius = exitButton.bounds.size.width / 2.0
        clearCanvasButton.layer.cornerRadius = clearCanvasButton.bounds.size.width / 2.0
        transparentCanvas.layer.cornerRadius = transparentCanvas.bounds.size.width / 2.0
    }
    
    @objc func timerDidFire() {
        if (delegate.timer < timeCount) {
            if (delegate.timer < 0) {
                timeCount = 0
            } else {
                timeCount = delegate.timer
            }
        }
        
        if (timeCount > 0) {
            timeCount -= 1
            delegate.timer = timeCount
        }
        
        if (timeCount < exitButtonAvailableTime) {
            disableExitButton()
        }
        
        if (timeCount <= 0 && displayOutOfTime) {
            let answerButtons = [leftTopButton, rightTopButton, leftBottomButton, rightBottomButton]
            displayOutOfTime = false
            if let img = UIImage(named: "answer.out.of.time") {
                self.answerImage.image = img.withRenderingMode(.alwaysTemplate)
                self.answerImage.tintColor = self.wrongAnswerColor
            }
            self.scoreLabel.attributedText = getScoreColorString(reduce: true)
            self.setButtonsEnable(isEnable: false)
            self.answerImage.isHidden = false
            Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { [weak self] _ in
                self?.outOfTime()
            }
            UIView.animate(withDuration: 0.01, animations: {
                answerButtons[self.rightAnswerPlacement - 1]!.backgroundColor = self.rightAnswerColor
                if (self.saveData.isSoundOn()) {
                    AudioManager.shared.play("sound.out.of.time")
                }
            }, completion: { _ in
                answerButtons[self.rightAnswerPlacement - 1]!.backgroundColor = self.buttonColor
            })
        } else if (timeCount <= 5) {
            self.timerLabel.textColor = wrongAnswerColor
        } else {
            self.timerLabel.textColor = gameStages.stages[gameLevel].textColor
        }
        let currentQuestionTime =  NSString(format: "%02d:%02d", (timeCount/60)%60, timeCount%60) as String
        timerLabel.text = "Time: \(currentQuestionTime)"
    }
    
    func newQuestion() {
        self.timerLabel.textColor = gameStages.stages[gameLevel].textColor
        showHintIcons()
        let answer = gameStages.stages[gameLevel]
        
        addScore = answer.addScore
        totalTimerCount = answer.timer
        var reduceAvailableTime = Int(totalTimerCount / 6)
        if (reduceAvailableTime > 10) {
            reduceAvailableTime = 10
        }
        exitButtonAvailableTime = totalTimerCount - reduceAvailableTime
        
        timeCount = totalTimerCount
        delegate.timer = timeCount
        let currentQuestionTime =  NSString(format: "%02d:%02d", (timeCount/60)%60, timeCount%60) as String
        timerLabel.text = "Time: \(currentQuestionTime)"
        
        if (gameLevel < gameStages.stages.count) {
            if (gameScore >= answer.nextLevelScore && gameLevel + 1 < gameStages.stages.count) {
                gameLevel = gameLevel + 1
                setLevelButtonsColorsAndBackground()
                showPassLevelScreen()
                
            }
        }
        
        var equations: [[String]] = EquationGenerator.generateEquations(numberOfVariables: answer.numberOfVariables, limit: answer.limit, operations: answer.operations, difficulty: answer.difficulty, allowNegativeResults: answer.allowNegativeResults, withFloat: answer.withFloat)

        while (isThereASingleVariable(equations: equations)) {
            equations = EquationGenerator.generateEquations(numberOfVariables: answer.numberOfVariables, limit: answer.limit, operations: answer.operations, difficulty: answer.difficulty, allowNegativeResults: answer.allowNegativeResults, withFloat: answer.withFloat)
        }
        
        currentEquations = equations
        
        let finalEquationIndex = equations.count - 1
        let resultIndex = equations[finalEquationIndex].count - 1
        setAnswers(equations: equations)
        let finalResult: Int = Int(equations[finalEquationIndex][resultIndex]) ?? 0
        rightAnswerPlacement = Int.random(in: 1...4)
        setButtons(finalResult: finalResult)
        changeIcons(equations: equations, icons: answer.icons)
        enableDisableHintButtons(forceEnable: true)
        setButtonsEnable(isEnable: true)
        
        
    }
    
    func showPassLevelScreen() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if (saveData.isSoundOn()) {
            AudioManager.shared.play("sound.pass.stage")
        }
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "PassStage") as! PassStage
        nextViewController.currentLevel = gameLevel + 1
        nextViewController.currentTheme = gameStages.stages[gameLevel].levelTheme
        nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController, animated: true, completion: nil)
    }
    
    func setLevelButtonsColorsAndBackground() {
        changeTextColor()
        changeBackgroundImage()
        self.view.backgroundColor = gameStages.stages[gameLevel].backgroundColor
        changeButtonColors(color: gameStages.stages[gameLevel].buttonColor)
    }
    
    func changeBackgroundImage() {
        let backgroundImageName = gameStages.stages[gameLevel].levelTheme.lowercased() + ".bg"
        if let bgImage = UIImage(named: backgroundImageName) {
            if (self.view.subviews[0] is UIImageView) {
                let backgroundImage: UIImageView = self.view.subviews[0] as! UIImageView
                backgroundImage.image = bgImage
            } else {
                let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
                backgroundImage.image = bgImage
                self.view.insertSubview(backgroundImage, at: 0)
            }
        }
    }
    
    func changeTextColor() {
        let changeToColor = gameStages.stages[gameLevel].textColor
        
        scoreLabel.textColor = changeToColor
        timerLabel.textColor = changeToColor
        
        firstEquationEqual.image = firstEquationEqual.image?.maskWithColor(color: changeToColor)
        firstAnswer.textColor = changeToColor
        
        secondEquationEqual.image = firstEquationEqual.image?.maskWithColor(color: changeToColor)
        secondAnswer.textColor = changeToColor
        
        thirdEquationEqual.image = thirdEquationEqual.image?.maskWithColor(color: changeToColor)
        thirdAnswer.textColor = changeToColor
        
        fourthEquationEqual.image = fourthEquationEqual.image?.maskWithColor(color: changeToColor)
        fourthAnswer.textColor = changeToColor
        
        fifthEquationEqual.image = fifthEquationEqual.image?.maskWithColor(color: changeToColor)
        fifthAnswer.textColor = changeToColor
        
        
    }
    
    func setButtons(finalResult: Int) {
        var button: UIButton = UIButton()
        let alternativeAnswers = EquationGenerator.generateAlternativeAnswers(rightAnswer: finalResult, negativeAnswers: false)
        var alternativeAnswersIndex = 0
        
        for i in 1...4 {
            button = view.viewWithTag(i) as! UIButton
            if (i == Int(rightAnswerPlacement)) {
                button.setTitle(String(finalResult), for: .normal)
            } else {
                button.setTitle(String(alternativeAnswers[alternativeAnswersIndex]), for: .normal)
                alternativeAnswersIndex += 1
            }
        }
    }
    
    func setAnswers(equations: [[String]]) {
        let answers = [firstAnswer, secondAnswer, thirdAnswer, fourthAnswer, fifthAnswer]
        let equals = [firstEquationEqual, secondEquationEqual, thirdEquationEqual, fourthEquationEqual, fifthEquationEqual]
        
        let lastQuestion = equations.count - 1
        let answerIndex = equations[0].count - 1
        
        for i in 0..<answers.count {
            let currentAnswer: UILabel = answers[i]!
            
            if equations.indices.contains(i) {
                currentAnswer.isHidden = false
                equals[i]!.isHidden = false
                if (i < lastQuestion) {
                    currentAnswer.text = equations[i][answerIndex]
                } else if (i == lastQuestion) {
                    currentAnswer.text = "?"
                }
            } else {
                currentAnswer.isHidden = true
                equals[i]!.isHidden = true
            }
        }
        
    }
    
    
    func changeIcons(equations: [[String]], icons: [String]) {
        let labelsArr = [[firstEquationFirstElement, firstEquationFirstOperator, firstEquationSecondElement, firstEquationSecondOperator, firstEquationThirdElement], [secondEquationFirstElement, secondEquationFirstOperator, secondEquationSecondElement, secondEquationSecondOperator, secondEquationThirdElement], [thirdEquationFirstElement, thirdEquationFirstOperator, thirdEquationSecondElement, thirdEquationSecondOperator, thirdEquationThirdElement], [fourthEquationFirstElement, fourthEquationFirstOperator, fourthEquationSecondElement, fourthEquationSecondOperator, fourthEquationThirdElement],        [fifthEquationFirstElement, fifthEquationFirstOperator, fifthEquationSecondElement, fifthEquationSecondOperator, fifthEquationThirdElement]]
        
        let operationsImages = ["/": "math.divide", "-": "math.minus", "+": "math.plus", "*": "math.multiply"]
        var elementsDict = [String: String]()
        
        var elementsImagesIndex = 0
        if icons.count > 1 {
            elementsImagesIndex = Int.random(in: 0..<(icons.count - 1))
        }
        
        for i in 0..<labelsArr.count {
            for j in 0..<labelsArr[i].count {
                let currentLabel: UIImageView = labelsArr[i][j]!
                currentLabel.isHidden = false
                
                if equations.indices.contains(i) {
                    let equationElement = equations[i][j]
                    if let val = elementsDict[equationElement], let image = UIImage(named: val) {
                        currentLabel.image = image
                    } else {
                        if let oper = operationsImages[equationElement], let opImage = UIImage(named: oper) {
                            currentLabel.image = opImage.maskWithColor(color: gameStages.stages[gameLevel].textColor)
                        } else {
                            elementsDict[equationElement] = icons[elementsImagesIndex]
                            elementsImagesIndex += 1
                            if (elementsImagesIndex >= icons.count) {
                                elementsImagesIndex = 0
                            }
                            if let name = elementsDict[equationElement], let image = UIImage(named: name) {
                                currentLabel.image = image
                            }
                        }
                    }
                } else {
                    currentLabel.isHidden = true
                }
            }
        }
    }
    
    func setButtonsEnable(isEnable: Bool) {
        let answerButtons = [leftTopButton, rightTopButton, leftBottomButton, rightBottomButton]
        for i in 0..<answerButtons.count {
            let button: UIButton = answerButtons[i]!
            button.isEnabled = isEnable
            if (isEnable) {
                button.alpha = 1.0
            }
        }
    }
    
    func isThereASingleVariable(equations: [[String]]) -> Bool {
        var numCounter = [String : Int]()
        for i in 0..<equations.count {
            for j in 0..<(equations[i].count - 1) {
                let str = equations[i][j]
                if str.isNumber() {
                    if numCounter[str] == nil {
                        numCounter[str] = 1
                    } else {
                        numCounter[str] = numCounter[str]! + 1
                    }
                }
            }
        }
        
        let keys = Array(numCounter.keys)
        for _key in keys {
            if numCounter[_key]! == 1 {
                return true
            }
        }
        
        return false
    }
    
    func changeButtonColors(color: UIColor) {
        buttonColor = color
        leftTopButton.backgroundColor = buttonColor
        rightTopButton.backgroundColor = buttonColor
        leftBottomButton.backgroundColor = buttonColor
        rightBottomButton.backgroundColor = buttonColor
        hintHintButton.backgroundColor = buttonColor
        hintFiftyButton.backgroundColor = buttonColor
        hintTimerButton.backgroundColor = buttonColor
        clearCanvasButton.backgroundColor = buttonColor
        transparentCanvas.backgroundColor = buttonColor
    }
    
    func updateGameScore(reduce: Bool) {
        if (reduce) {
            let reduceScore: Int = calcScoreReduction()
            if (gameScore > 0) {
                gameScore -= reduceScore
            }
        } else {
            gameScore += addScore
        }
        self.scoreLabel.text = "Score: \(gameScore)"
        saveData.setUserScore(score: gameScore)
        saveUserScoreToGameCenter()
    }
    
    func calcScoreReduction() -> Int {
        var reduceScore: Int = 1
        if (addScore > 1) {
            let rdc: Double = Double(addScore / 2)
            reduceScore = Int(rdc.rounded(.down))
        }
        return reduceScore
    }
    
    @objc func setCorrectAnswerImage() {
        timer = Timer(timeInterval: 1.0, target: self, selector: #selector(MainController.timerDidFire), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
        self.answerImage.isHidden = true
        updateGameScore(reduce: false)
        newQuestion()
    }
    
    @objc func setWrongAnswerImage() {
        timer = Timer(timeInterval: 1.0, target: self, selector: #selector(MainController.timerDidFire), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
        self.answerImage.isHidden = true
        updateGameScore(reduce: true)
        newQuestion()
    }
    
    @objc func outOfTime() {
        displayOutOfTime = true
        self.answerImage.isHidden = true
        updateGameScore(reduce: true)
        newQuestion()
    }
    
    func changeHintIcons() {
        let labelsArr = [[firstEquationFirstElement, firstEquationSecondElement, firstEquationThirdElement], [secondEquationFirstElement, secondEquationSecondElement, secondEquationThirdElement], [thirdEquationFirstElement, thirdEquationSecondElement, thirdEquationThirdElement], [fourthEquationFirstElement, fourthEquationSecondElement, fourthEquationThirdElement],        [fifthEquationFirstElement, fifthEquationSecondElement, fifthEquationThirdElement]]
        
        let numVars = gameStages.stages[gameLevel].numberOfVariables
        guard numVars > 0 else { return }
        let col: Int = Int.random(in: 0..<numVars)
        
        let row: Int = Int.random(in: 0...1) * 2
        
        let variableToShow = currentEquations[col][row]
        let imageHintAnswer = "hint.num.\(variableToShow)"
        guard UIImage(named: imageHintAnswer) != nil else { return }
        
        for i in 0..<currentEquations.count {
            for j in 0..<currentEquations[i].count {
                if (currentEquations[i][j] == variableToShow) {
                    var imageIndex = j
                    if (j > 0) {
                        imageIndex = Int(j/2)
                    }
                    
                    var animationArray = createImageArray(total: 14, imagePrefix: "hint.animation")
                    if let hintImg = UIImage(named: imageHintAnswer) {
                        animationArray.append(hintImg)
                    }
                    if let targetView = labelsArr[i][imageIndex] {
                        animate(imageView: targetView, images: animationArray)
                        targetView.image = UIImage(named: imageHintAnswer)
                    }
                }
            }
        }

    }
    
    func createImageArray(total: Int, imagePrefix: String) -> [UIImage] {
        var imageArray: [UIImage] = []
        for imageCount in 1..<total {
            let imageName = "\(imagePrefix).\(imageCount)"
            guard let image = UIImage(named: imageName) else { continue }
            imageArray.append(image)
        }
        
        return imageArray
    }
    
    func animate(imageView: UIImageView, images: [UIImage]) {
        imageView.animationImages = images
        imageView.animationDuration = 0.4
        imageView.animationRepeatCount = 1
        imageView.startAnimating()
    }
    
    func saveUserScoreToGameCenter() {
        let score = Int64(saveData.getScore())
        let currentScore = saveData.getScore()
        var leaderboardIDs = [
            AppConstants.GameCenter.lowestScores,
            AppConstants.GameCenter.recentBest,
            AppConstants.GameCenter.needPractice
        ]
        if currentScore > saveData.getBestScore() {
            saveData.setBestScore(score: currentScore)
            leaderboardIDs.append(AppConstants.GameCenter.bestPlayers)
        }
        GameCenterManager.shared.reportScore(score, leaderboardIDs: leaderboardIDs)
    }
}



