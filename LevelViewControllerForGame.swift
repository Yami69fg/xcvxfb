import UIKit
import SnapKit

class LevelViewControllerForGame: UIViewController {
    
    var exitToMenu: (() -> ())?
    var instruction = 0
    private let balanceKey = "userBalance"
    private var levelCompletionStatesForAllLevels: [Bool] = Array(repeating: false, count: 12)
    
    private let levelConfigurations: [LevelConfiguration] = [
        LevelConfiguration(targetScore: 5, backgroundImageName: "BackGroundOne1"),
        LevelConfiguration(targetScore: 10, backgroundImageName: "BackGroundOne3"),
        LevelConfiguration(targetScore: 15, backgroundImageName: "BackGroundOne2"),
        LevelConfiguration(targetScore: 20, backgroundImageName: "BackGroundOne1"),
        LevelConfiguration(targetScore: 25, backgroundImageName: "BackGroundOne3"),
        LevelConfiguration(targetScore: 30, backgroundImageName: "BackGroundOne2"),
        LevelConfiguration(targetScore: 35, backgroundImageName: "BackGroundOne1"),
        LevelConfiguration(targetScore: 40, backgroundImageName: "BackGroundOne3"),
        LevelConfiguration(targetScore: 45, backgroundImageName: "BackGroundOne1"),
        LevelConfiguration(targetScore: 50, backgroundImageName: "BackGroundOne2"),
        LevelConfiguration(targetScore: 55, backgroundImageName: "BackGroundOne3"),
        LevelConfiguration(targetScore: 60, backgroundImageName: "BackGroundOne2")
    ]
    
    let instructionText: [LevelInstruction] = [
        LevelInstruction(textForGame: "First you need to score points in another game and then choose the number of points you will spend. Then you must choose what color will fall out and click on Spin, if you guessed the color the level is completed"),
        LevelInstruction(textForGame: "You need to collect balls according to the color of the basket. To complete the level you need to score a certain amount of points and the level will be complete.")
    ]
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "BackGroundGame")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let secondaryBackgroundForLabelsAndButtons: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "BGForAll")
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let centralLevelIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "LevelIcon")
        return imageView
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
    
    private let buttonBackToMainMenu: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "ButtonExitToMenu"), for: .normal)
        return button
    }()
    
    private let buttonOpenInstructionPopup: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "ButtonOpneInstruction"), for: .normal)
        return button
    }()
    
    init(instruction: Int) {
        self.instruction = instruction
        super.init(nibName: nil, bundle: nil)
        loadSavedCompletedLevelsFromUserDefaults()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonBackToMainMenu.addTarget(self, action: #selector(navigateBackToMainMenu), for: .touchUpInside)
        soundsTappedButtonadd(uiButton: buttonBackToMainMenu)
        buttonOpenInstructionPopup.addTarget(self, action: #selector(showGameInstructionPopup), for: .touchUpInside)
        soundsTappedButtonadd(uiButton: buttonOpenInstructionPopup)
        
        initializeUserBalance()
        
        if levelCompletionStatesForAllLevels.isEmpty || !levelCompletionStatesForAllLevels[0] {
            levelCompletionStatesForAllLevels[0] = true
        }

        setupUI()
        createLevelButtonsForStartingTheGame()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadSavedCompletedLevelsFromUserDefaults()
        updateLevelButtonsAfterCompletion()
    }
    
    private func initializeUserBalance() {
        let balance = UserDefaults.standard.integer(forKey: balanceKey)
        balanceLabel.text = "\(balance)"
    }
    
    private func setupUI() {
        view.addSubview(backgroundImageView)
        view.addSubview(secondaryBackgroundForLabelsAndButtons)
        view.addSubview(centralLevelIconImageView)
        view.addSubview(buttonBackToMainMenu)
        view.addSubview(buttonOpenInstructionPopup)
        
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        secondaryBackgroundForLabelsAndButtons.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(250)
        }
        
        centralLevelIconImageView.snp.makeConstraints { make in
            make.bottom.equalTo(secondaryBackgroundForLabelsAndButtons.snp.top).offset(50)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(100)
        }
        
        buttonBackToMainMenu.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.width.height.equalTo(50)
        }
        
        buttonOpenInstructionPopup.snp.makeConstraints { make in
            make.top.equalTo(secondaryBackgroundForLabelsAndButtons.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(150)
            make.height.equalTo(40)
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
    
    private func createLevelButtonsForStartingTheGame() {
        for i in 0..<12 {
            let levelButtonForSpecificLevel = UIButton(type: .custom)
            levelButtonForSpecificLevel.tag = i + 1
            levelButtonForSpecificLevel.layer.zPosition = 1
            soundsTappedButtonadd(uiButton: levelButtonForSpecificLevel)
            levelButtonForSpecificLevel.addTarget(self, action: #selector(openSpecificGameBasedOnInstruction(_:)), for: .touchUpInside)
            secondaryBackgroundForLabelsAndButtons.addSubview(levelButtonForSpecificLevel)
            levelButtonForSpecificLevel.snp.makeConstraints { make in
                make.width.height.equalTo(50)
                
                if i % 4 == 0 {
                    make.left.equalTo(secondaryBackgroundForLabelsAndButtons.snp.left).offset(35)
                } else {
                    make.left.equalTo(secondaryBackgroundForLabelsAndButtons.subviews[i - 1].snp.right).offset(10)
                }

                if i / 4 == 0 {
                    make.top.equalTo(secondaryBackgroundForLabelsAndButtons.snp.top).offset(50)
                } else {
                    make.top.equalTo(secondaryBackgroundForLabelsAndButtons.subviews[i - 4].snp.bottom).offset(20)
                }
            }
            
            configureLevelButtonAppearanceBasedOnCompletionStatus(levelButtonForSpecificLevel, index: i)
        }
    }

    private func configureLevelButtonAppearanceBasedOnCompletionStatus(_ levelButton: UIButton, index: Int) {
        let currentLevelIndex = index + 1
        
        if levelCompletionStatesForAllLevels[index] {
            levelButton.setImage(UIImage(named: "DefaulBGLevel"), for: .normal)
            let levelIndexLabel = UILabel()
            levelIndexLabel.text = "\(currentLevelIndex)"
            levelIndexLabel.textColor = .white
            levelIndexLabel.textAlignment = .center
            levelIndexLabel.font = UIFont(name: "Questrian", size: 20)
            levelButton.isUserInteractionEnabled = true
            levelButton.addSubview(levelIndexLabel)

            levelIndexLabel.snp.makeConstraints { make in
                make.center.equalTo(levelButton)
            }
        } else {
            levelButton.setImage(UIImage(named: "LockedBGLevel"), for: .normal)
            levelButton.isUserInteractionEnabled = false
        }
    }
    
    @objc func openSpecificGameBasedOnInstruction(_ sender: UIButton) {
        let selectedLevelIndex = sender.tag - 1
        if instruction == 1 {
            let firstGameViewController = GameOne()
            firstGameViewController.spinCost = levelConfigurations[sender.tag - 1].targetScore
            firstGameViewController.backgroundImageNameForCurrentGame = levelConfigurations[sender.tag - 1].backgroundImageName
            firstGameViewController.levelNumberForCurrentGame = selectedLevelIndex
            firstGameViewController.exitToMenu = { [weak self] in
                self?.dismiss(animated: false)
                self?.exitToMenu?()
            }
            firstGameViewController.modalPresentationStyle = .overCurrentContext
            present(firstGameViewController, animated: false)
        } else {
            let secondGameViewController = GameTwo()
            secondGameViewController.targetScoreForLevelCompletion = levelConfigurations[sender.tag - 1].targetScore
            secondGameViewController.backgroundImageNameForCurrentGame = levelConfigurations[sender.tag - 1].backgroundImageName
            secondGameViewController.levelNumberForCurrentGame = selectedLevelIndex
            secondGameViewController.exitToMenu = { [weak self] in
                self?.dismiss(animated: false)
                self?.exitToMenu?()
            }
            secondGameViewController.modalPresentationStyle = .overCurrentContext
            present(secondGameViewController, animated: false)
        }
    }

    
    private func markLevelAsCompleted(level: Int) {
        if level < levelCompletionStatesForAllLevels.count {
            levelCompletionStatesForAllLevels[level] = true
            if level + 1 < levelCompletionStatesForAllLevels.count {
                levelCompletionStatesForAllLevels[level + 1] = true
            }
            saveCompletedLevelsToUserDefaults()
            updateLevelButtonsAfterCompletion()
        }
    }

    private func updateLevelButtonsAfterCompletion() {
        for (index, button) in secondaryBackgroundForLabelsAndButtons.subviews.enumerated() {
            if let levelButton = button as? UIButton {
                configureLevelButtonAppearanceBasedOnCompletionStatus(levelButton, index: index)
            }
        }
    }

    
    private func saveCompletedLevelsToUserDefaults() {
        UserDefaults.standard.set(levelCompletionStatesForAllLevels, forKey: "completedLevelsForGameWithInstruction\(instruction)")
    }
    
    private func loadSavedCompletedLevelsFromUserDefaults() {
        if let savedLevelStates = UserDefaults.standard.array(forKey: "completedLevelsForGameWithInstruction\(instruction)") as? [Bool] {
            levelCompletionStatesForAllLevels = savedLevelStates
        }
    }


    @objc func navigateBackToMainMenu() {
        self.dismiss(animated: false)
    }
    
    @objc func showGameInstructionPopup() {
        let instructionPopupController = InstructionForGamesController(text: instructionText[instruction-1].textForGame)
        instructionPopupController.modalPresentationStyle = .overCurrentContext
        present(instructionPopupController, animated: true, completion: nil)
    }
}

struct LevelInstruction {
    let textForGame: String
}

struct LevelConfiguration {
    let targetScore: Int
    let backgroundImageName: String
}
