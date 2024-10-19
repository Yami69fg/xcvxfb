import UIKit
import SpriteKit
import AVFoundation
import GameplayKit

class GameTwo: UIViewController {
    private weak var sceneSecond: GameScene? {
        return sceneGame
    }
    var audioPlayer: AVAudioPlayer?

    var exitToMenu: (() -> ())?
    var onRetry: (() -> ())?
    private let balanceKey = "userBalance"
    private var levelCompletionStatesForAllLevels: [Bool] = Array(repeating: false, count: 12)
    
    var targetScoreForLevelCompletion: Int = 0
    var backgroundImageNameForCurrentGame: String = ""
    var levelNumberForCurrentGame: Int = 0
    
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
    
    private weak var sceneGame: GameScene?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = SKView(frame: view.frame)
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        
        if let viewForGame = self.view as? SKView {
            let gameSceneForCurrentLevel = GameScene(size: viewForGame.bounds.size)
            self.sceneGame = gameSceneForCurrentLevel
            gameSceneForCurrentLevel.gameTwo = self

            gameSceneForCurrentLevel.targetScoreForLevelCompletion = targetScoreForLevelCompletion
            gameSceneForCurrentLevel.backgroundImageNameForCurrentGame = backgroundImageNameForCurrentGame

            gameSceneForCurrentLevel.scaleMode = .aspectFill
            viewForGame.presentScene(gameSceneForCurrentLevel)
        }
        initializeUserBalance()
        view.addSubview(buttonSettingAudio)
        buttonSettingAudio.layer.zPosition = 1
        soundsTappedButtonadd(uiButton: buttonSettingAudio)
        buttonSettingAudio.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(70)
            make.height.width.equalTo(55)
        }
        
        buttonSettingAudio.addTarget(self, action: #selector(openSettingsForBothGameController), for: .touchUpInside)
    }
    
    private func initializeUserBalance() {
        
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
        
        let balance = UserDefaults.standard.integer(forKey: balanceKey)
        balanceLabel.text = "\(balance)"
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
    
    func endTwoGameScene(score: Int) {
        let gameOverController = EndGameController()
        sceneGame?.pauseGameScene()
        
        UserDefaults.standard.set(score+UserDefaults.standard.integer(forKey: balanceKey), forKey: balanceKey)
        
        var bestScore = UserDefaults.standard.integer(forKey: "BestScoreForSecondGame")
        
        if score > bestScore {
            bestScore = score
            UserDefaults.standard.set(bestScore, forKey: "BestScoreForSecondGame")
        }
        
        if score >= targetScoreForLevelCompletion {
            markLevelAsCompleted(level: levelNumberForCurrentGame)
            gameOverController.resultMessage = "YouWinTheGame"
            gameOverController.playerCurrentScore = score
            gameOverController.playerBestScore = UserDefaults.standard.integer(forKey: "BestScoreForSecondGame")
            playSoundWithLongFileName()
        } else {
            gameOverController.resultMessage = "YouLoseTheGame"
            gameOverController.playerCurrentScore = score
            gameOverController.playerBestScore = UserDefaults.standard.integer(forKey: "BestScoreForSecondGame")
            playSoundWithLongFileName()
        }
        
        let balance = UserDefaults.standard.integer(forKey: balanceKey)
        balanceLabel.text = "\(balance)"
        
        gameOverController.onRetry = { [weak self] in
            self?.sceneGame?.startNewGame()
        }
        gameOverController.exitToMenu = { [weak self] in
            self?.dismiss(animated: false)
            self?.exitToMenu?()
        }
        
        gameOverController.modalPresentationStyle = .overFullScreen
        present(gameOverController, animated: false)
    }

    
    private func markLevelAsCompleted(level: Int) {
        if let savedLevelStates = UserDefaults.standard.array(forKey: "completedLevelsForGameWithInstruction\(2)") as? [Bool] {
            levelCompletionStatesForAllLevels = savedLevelStates
        }
        if level < levelCompletionStatesForAllLevels.count {
            levelCompletionStatesForAllLevels[level] = true
            if level + 1 < levelCompletionStatesForAllLevels.count {
                levelCompletionStatesForAllLevels[level + 1] = true
            }
            UserDefaults.standard.set(levelCompletionStatesForAllLevels, forKey: "completedLevelsForGameWithInstruction\(2)")
        }
    }
    
    @objc func openSettingsForBothGameController() {
        sceneSecond?.pauseGameScene()
        let settingsForBothGameController = SettingsForBothGameController()
        settingsForBothGameController.exitToMenu = { [weak self] in
            self?.dismiss(animated: false)
            self?.exitToMenu?()
        }
        settingsForBothGameController.onRetry = { [weak self] in
            self?.sceneGame?.resumeGameScene()
        }
        settingsForBothGameController.modalPresentationStyle = .overCurrentContext
        present(settingsForBothGameController, animated: true, completion: nil)
    }
}
