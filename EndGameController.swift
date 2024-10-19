import UIKit
import SnapKit

class EndGameController: UIViewController {
    
    var exitToMenu: (() -> ())?
    var onRetry: (() -> ())?
    
    var resultMessage: String?
    
    var playerCurrentScore: Int = 0
    var playerBestScore: Int = 0
    
    
    private let mainBackgroundShadyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Shady")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let secondaryBackgroundForLabelsAndButtons: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "BGForAll")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let youWinTheGameIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "YouWinTheGame")
        return imageView
    }()
    
    private let scoreLabelForGame: UILabel = {
        let label = UILabel()
        label.text = "Score"
        label.font = UIFont(name: "Questrian", size: 32)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let bestScoreLabelForGame: UILabel = {
        let label = UILabel()
        label.text = "Best score"
        label.font = UIFont(name: "Questrian", size: 32)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let exitToMainMenuButtonWithImage: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "MainMenuButton"), for: .normal)
        return button
    }()
    
    private let resetGameButtonWithImage: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "ResetGameButton"), for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
        linkButtonActions()
        updateScoreLabels()

    }

    private func setupInterface() {
        if resultMessage != "YouWinTheGame" {
            youWinTheGameIconImageView.image = UIImage(named: "YouLoseTheGame")
        }
        view.addSubview(mainBackgroundShadyImageView)
        mainBackgroundShadyImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        view.addSubview(secondaryBackgroundForLabelsAndButtons)
        secondaryBackgroundForLabelsAndButtons.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(200)
        }

        view.addSubview(youWinTheGameIconImageView)
        youWinTheGameIconImageView.snp.makeConstraints { make in
            make.bottom.equalTo(secondaryBackgroundForLabelsAndButtons.snp.top).offset(50)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.6)
            make.height.equalTo(200)
        }
        
        view.addSubview(scoreLabelForGame)
        scoreLabelForGame.snp.makeConstraints { make in
            make.left.equalTo(secondaryBackgroundForLabelsAndButtons.snp.left).offset(30)
            make.centerY.equalToSuperview().offset(-20)
        }
        
        view.addSubview(bestScoreLabelForGame)
        bestScoreLabelForGame.snp.makeConstraints { make in
            make.left.equalTo(secondaryBackgroundForLabelsAndButtons.snp.left).offset(30)
            make.centerY.equalToSuperview().offset(50)
        }

        view.addSubview(exitToMainMenuButtonWithImage)
        exitToMainMenuButtonWithImage.snp.makeConstraints { make in
            make.top.equalTo(secondaryBackgroundForLabelsAndButtons.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(40)
            make.width.equalTo(150)
            make.height.equalTo(40)
        }

        view.addSubview(resetGameButtonWithImage)
        resetGameButtonWithImage.snp.makeConstraints { make in
            make.top.equalTo(secondaryBackgroundForLabelsAndButtons.snp.bottom).offset(20)
            make.trailing.equalToSuperview().offset(-40)
            make.width.equalTo(150)
            make.height.equalTo(40)
        }
    }

    private func linkButtonActions() {
        exitToMainMenuButtonWithImage.addTarget(self, action: #selector(navigateToMainMenu), for: .touchUpInside)
        soundsTappedButtonadd(uiButton: exitToMainMenuButtonWithImage)
        resetGameButtonWithImage.addTarget(self, action: #selector(resetGameInterface), for: .touchUpInside)
        soundsTappedButtonadd(uiButton: exitToMainMenuButtonWithImage)
    }

    private func updateScoreLabels() {
        scoreLabelForGame.text = "Score: \(playerCurrentScore)"
        bestScoreLabelForGame.text = "Best Score: \(playerBestScore)"
    }

    @objc private func navigateToMainMenu() {
        dismiss(animated: false)
        exitToMenu?()
    }

    @objc private func resetGameInterface() {
        onRetry?()
        dismiss(animated: true, completion: nil)
    }
}
