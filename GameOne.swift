import UIKit
import SnapKit
import AVFoundation

class GameOne: UIViewController {

    var exitToMenu: (() -> ())?
    var audioPlayer: AVAudioPlayer?
    
    private let balanceKey = "userBalance"
    var spinCost = 0
    var backgroundImageNameForCurrentGame = ""
    private var isRotating = false
    private var randomResult: Int = 1
    private var selectedLevel = 0
    var levelNumberForCurrentGame: Int = 0
    
    private var selectedColorButton: UIButton?
    private var levelCompletionStatesForAllLevels: [Bool] = Array(repeating: false, count: 12)

    private let discImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Disc")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let bigDiscImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Stroke")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private var backgroundImageView: UIImageView!

    private let rotateButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "RotateButton"), for: .normal)
        return button
    }()
    
    private let buttonSettingAudio: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "ButtonSettingAudio"), for: .normal)
        return button
    }()
    
    private let scoreBackgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ScoreBackGround")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let balanceLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = UIFont(name: "Questrian", size: 24)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let blackButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "BlackButton"), for: .normal)
        return button
    }()

    private let whiteButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "WhiteButton"), for: .normal)
        return button
    }()

    private let redButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "RedButton"), for: .normal)
        return button
    }()

    var array = [1, 2, 3, 1, 2, 1, 2, 3, 1, 2]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundImageView = UIImageView()
        backgroundImageView.image = UIImage(named: backgroundImageNameForCurrentGame)
        backgroundImageView.contentMode = .scaleAspectFill
        
        view.addSubview(backgroundImageView)
        view.addSubview(buttonSettingAudio)
        view.addSubview(discImageView)
        view.addSubview(bigDiscImageView)
        view.addSubview(rotateButton)
        view.addSubview(blackButton)
        view.addSubview(whiteButton)
        view.addSubview(redButton)

        rotateButton.addTarget(self, action: #selector(rotateDiscButtonTapped), for: .touchUpInside)
        soundsTappedButtonadd(uiButton: rotateButton)
        buttonSettingAudio.addTarget(self, action: #selector(openSettingsForBothGameController), for: .touchUpInside)
        soundsTappedButtonadd(uiButton: buttonSettingAudio)
        
        blackButton.addTarget(self, action: #selector(colorButtonTapped(_:)), for: .touchUpInside)
        whiteButton.addTarget(self, action: #selector(colorButtonTapped(_:)), for: .touchUpInside)
        redButton.addTarget(self, action: #selector(colorButtonTapped(_:)), for: .touchUpInside)
        soundsTappedButtonadd(uiButton: blackButton)
        soundsTappedButtonadd(uiButton: whiteButton)
        soundsTappedButtonadd(uiButton: redButton)

        initializeUserBalance()
        setupConstraints()
    }
    
    private func setupConstraints() {
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        bigDiscImageView.snp.makeConstraints { make in
            make.width.height.equalToSuperview().multipliedBy(0.35)
            make.center.equalToSuperview()
        }

        discImageView.snp.makeConstraints { make in
            make.width.height.equalToSuperview().multipliedBy(0.33)
            make.center.equalToSuperview()
        }

        rotateButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(bigDiscImageView.snp.bottom).offset(30)
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalToSuperview().multipliedBy(0.05)
        }
        
        buttonSettingAudio.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.width.height.equalTo(50)
        }
        
        whiteButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(rotateButton.snp.bottom).offset(20)
            make.width.height.equalTo(50)
        }

        blackButton.snp.makeConstraints { make in
            make.right.equalTo(whiteButton.snp.left).offset(-50)
            make.top.equalTo(rotateButton.snp.bottom).offset(20)
            make.width.height.equalTo(50)
        }

        redButton.snp.makeConstraints { make in
            make.left.equalTo(whiteButton.snp.right).offset(50)
            make.top.equalTo(rotateButton.snp.bottom).offset(20)
            make.width.height.equalTo(50)
        }

        view.addSubview(scoreBackgroundImageView)
        scoreBackgroundImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.width.equalTo(150)
            make.height.equalTo(40)
        }

        view.addSubview(balanceLabel)
        balanceLabel.snp.makeConstraints { make in
            make.edges.equalTo(scoreBackgroundImageView)
        }
    }

    func randomizeArray() {
        array.shuffle()
        randomResult = array.randomElement() ?? 1
    }

    func startRotation() {
        if !isRotating {
            randomizeArray()
            if  UserDefaults.standard.bool(forKey: "isSoundOn") {
                guard let url = Bundle.main.url(forResource: "wheelSpin", withExtension: "mp3") else {
                    return
                }
                do {
                    audioPlayer = try AVAudioPlayer(contentsOf: url)
                    audioPlayer?.play()
                } catch {
                }
            }
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
            rotationAnimation.toValue = 3.5 * 2 * Double.pi + Double(randomResult) * Double(CGFloat.random(in: 0.628...0.7))
            rotationAnimation.duration = 4.0
            rotationAnimation.isRemovedOnCompletion = false
            rotationAnimation.fillMode = .forwards
            
            discImageView.layer.add(rotationAnimation, forKey: "rotationAnimation")
            isRotating = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + rotationAnimation.duration) {
                self.checkWinCondition()
            }
        }
    }

    private func initializeUserBalance() {
        let balance = UserDefaults.standard.integer(forKey: balanceKey)
        balanceLabel.text = "\(balance)"
    }

    func stopRotation() {
        discImageView.layer.removeAnimation(forKey: "rotationAnimation")
        isRotating = false
    }

    @objc func rotateDiscButtonTapped() {
        let currentBalance = UserDefaults.standard.integer(forKey: balanceKey)

        if currentBalance < spinCost {
            showAlert(title: "Insufficient Balance", message: "You need at least \(spinCost) coins to spin. Your current balance is \(currentBalance).")
            return
        }

        if selectedColorButton == nil {
            showAlert(title: "Color Selection Required", message: "Please select a color before spinning.")
            return
        }

        UserDefaults.standard.set(currentBalance - spinCost, forKey: balanceKey)
        balanceLabel.text = "\(currentBalance - spinCost)"

        if isRotating {
            stopRotation()
        }
        
        startRotation()
    }
    
    @objc func openSettingsForBothGameController() {
        let settingsForBothGameController = SettingsForBothGameController()
        settingsForBothGameController.exitToMenu = { [weak self] in
            self?.dismiss(animated: false)
            self?.exitToMenu?()
        }
        settingsForBothGameController.modalPresentationStyle = .overCurrentContext
        present(settingsForBothGameController, animated: true, completion: nil)
    }
    
    @objc func colorButtonTapped(_ sender: UIButton) {
        selectedColorButton?.isSelected = false
        selectedColorButton?.alpha = 1.0

        selectedColorButton = sender
        selectedColorButton?.isSelected = true
        selectedColorButton?.alpha = 0.5

        if sender == blackButton {
            whiteButton.isSelected = false
            redButton.isSelected = false
        } else if sender == whiteButton {
            blackButton.isSelected = false
            redButton.isSelected = false
        } else if sender == redButton {
            blackButton.isSelected = false
            whiteButton.isSelected = false
        }
    }

    func checkWinCondition() {
        let winningColor = randomResult
        guard let selectedButton = selectedColorButton else {
            return
        }

        let selectedColorIndex: Int
        if selectedButton == blackButton {
            selectedColorIndex = 1
        } else if selectedButton == redButton {
            selectedColorIndex = 2
        } else {
            selectedColorIndex = 3
        }
        
        func playSoundWithLongFileName() {
            if  UserDefaults.standard.bool(forKey: "isSoundOn") {
                guard let url = Bundle.main.url(forResource: "endGameSound", withExtension: "mp3") else {
                    return
                }
                do {
                    audioPlayer = try AVAudioPlayer(contentsOf: url)
                    audioPlayer?.play()
                } catch {
                }
            }
        }

        if selectedColorIndex == winningColor {
            var bestScore = UserDefaults.standard.integer(forKey: "BestScoreForFirstGame")
            
            if spinCost > bestScore {
                bestScore = spinCost
                UserDefaults.standard.set(bestScore, forKey: "BestScoreForFirstGame")
            }
            let endGameController = EndGameController()
            endGameController.resultMessage = "YouWinTheGame"
            endGameController.playerCurrentScore = spinCost
            markLevelAsCompleted(level: levelNumberForCurrentGame)
            endGameController.playerBestScore = UserDefaults.standard.integer(forKey: "BestScoreForFirstGame")
            playSoundWithLongFileName()
            endGameController.exitToMenu = { [weak self] in
                self?.dismiss(animated: false)
                self?.exitToMenu?()
            }
            endGameController.modalPresentationStyle = .overFullScreen
            present(endGameController, animated: true, completion: nil)
        } else {
            let endGameController = EndGameController()
            endGameController.resultMessage = "YouLoseTheGame"
            endGameController.playerCurrentScore = spinCost
            endGameController.playerBestScore = UserDefaults.standard.integer(forKey: "BestScoreForFirstGame")
            playSoundWithLongFileName()
            endGameController.exitToMenu = { [weak self] in
                self?.dismiss(animated: false)
                self?.exitToMenu?()
            }
            endGameController.modalPresentationStyle = .overFullScreen
            present(endGameController, animated: true, completion: nil)
        }
    }
    
    private func markLevelAsCompleted(level: Int) {
        if let savedLevelStates = UserDefaults.standard.array(forKey: "completedLevelsForGameWithInstruction\(1)") as? [Bool] {
            levelCompletionStatesForAllLevels = savedLevelStates
        }
        if level < levelCompletionStatesForAllLevels.count {
            levelCompletionStatesForAllLevels[level] = true
            if level + 1 < levelCompletionStatesForAllLevels.count {
                levelCompletionStatesForAllLevels[level + 1] = true
            }
            UserDefaults.standard.set(levelCompletionStatesForAllLevels, forKey: "completedLevelsForGameWithInstruction\(1)")
        }
    }

    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
