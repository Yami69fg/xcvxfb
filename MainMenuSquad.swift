import UIKit
import SnapKit

class MainMenuSquad: UIViewController {
    
    var exitToMenu: (() -> ())?
    
    private let balanceKey = "userBalance"
    
    private let backgroundSleeve: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "BackGroundGame")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let headerImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Logo")
        return imageView
    }()
    
    private let gameButtonOne: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "HappyDisc"), for: .normal)
        return button
    }()
    
    private let gameButtonTwo: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "StarTorque"), for: .normal)
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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeUserBalance()

        setupMainStage()
        attachActions()
    }
    
    private func initializeUserBalance() {
        let balance = UserDefaults.standard.integer(forKey: balanceKey)
        balanceLabel.text = "\(balance)"
    }

    private func setupMainStage() {
        view.addSubview(backgroundSleeve)
        backgroundSleeve.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        view.addSubview(headerImage)
        headerImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-100)
            make.width.equalToSuperview().multipliedBy(0.7)
            make.height.equalToSuperview().multipliedBy(0.2)
        }

        view.addSubview(gameButtonOne)
        gameButtonOne.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(headerImage.snp.bottom).offset(50)
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalToSuperview().multipliedBy(0.05)
        }

        view.addSubview(gameButtonTwo)
        gameButtonTwo.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(gameButtonOne.snp.bottom).offset(15)
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalToSuperview().multipliedBy(0.05)
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

    private func attachActions() {
        gameButtonOne.addTarget(self, action: #selector(startGameOne), for: .touchUpInside)
        gameButtonTwo.addTarget(self, action: #selector(startGameTwo), for: .touchUpInside)
        soundsTappedButtonadd(uiButton: gameButtonOne)
        soundsTappedButtonadd(uiButton: gameButtonTwo)
    }

    @objc private func startGameOne() {
        let gameOneController = LevelViewControllerForGame(instruction: 1)
        gameOneController.exitToMenu = { [weak self] in
            let balance = UserDefaults.standard.integer(forKey: "userBalance")
            self?.balanceLabel.text = "\(balance)"
            self?.dismiss(animated: false)
        }
        gameOneController.modalTransitionStyle = .crossDissolve
        gameOneController.modalPresentationStyle = .fullScreen
        present(gameOneController, animated: true, completion: nil)
    }

    @objc private func startGameTwo() {
        let gameTwoController = LevelViewControllerForGame(instruction: 2)
        gameTwoController.exitToMenu = { [weak self] in
            let balance = UserDefaults.standard.integer(forKey: "userBalance")
            self?.balanceLabel.text = "\(balance)"
            self?.dismiss(animated: false)
        }
        gameTwoController.modalTransitionStyle = .crossDissolve
        gameTwoController.modalPresentationStyle = .fullScreen
        present(gameTwoController, animated: true, completion: nil)
    }
}
