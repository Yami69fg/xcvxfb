import UIKit
import SnapKit

class SettingsForBothGameController: UIViewController {

    var exitToMenu: (() -> ())?
    var onRetry: (() -> ())?

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

    private let centralSettingsIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Settings")
        return imageView
    }()

    private let descriptionLabelForSoundSettings: UILabel = {
        let label = UILabel()
        label.text = "Sound"
        label.font = UIFont(name: "Questrian", size: 32)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()

    private let descriptionLabelForVibrationSettings: UILabel = {
        let label = UILabel()
        label.text = "Vibration"
        label.font = UIFont(name: "Questrian", size: 32)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()

    private let soundToggleButtonImageView: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let vibrationToggleButtonImageView: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let exitToMainMenuButtonWithImage: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "MainMenuButton"), for: .normal)
        return button
    }()

    private let returnToGameButtonWithImage: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "BackButton"), for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupEntireSettingsScreenInterface()
        initializeDefaultSettings()  // Initialize defaults here
        loadSettingsState()
        linkAllButtonActionsWithSpecificFunctions()
    }

    private func setupEntireSettingsScreenInterface() {
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

        view.addSubview(centralSettingsIconImageView)
        centralSettingsIconImageView.snp.makeConstraints { make in
            make.bottom.equalTo(secondaryBackgroundForLabelsAndButtons.snp.top).offset(50)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(100)
        }

        view.addSubview(descriptionLabelForSoundSettings)
        descriptionLabelForSoundSettings.snp.makeConstraints { make in
            make.left.equalTo(secondaryBackgroundForLabelsAndButtons.snp.left).offset(50)
            make.centerY.equalToSuperview().offset(-30)
        }

        view.addSubview(soundToggleButtonImageView)
        soundToggleButtonImageView.snp.makeConstraints { make in
            make.left.equalTo(descriptionLabelForSoundSettings.snp.right).offset(20)
            make.centerY.equalToSuperview().offset(-30)
            make.width.equalTo(60)
            make.height.equalTo(35)
        }

        view.addSubview(descriptionLabelForVibrationSettings)
        descriptionLabelForVibrationSettings.snp.makeConstraints { make in
            make.left.equalTo(secondaryBackgroundForLabelsAndButtons.snp.left).offset(30)
            make.centerY.equalToSuperview().offset(30)
        }

        view.addSubview(vibrationToggleButtonImageView)
        vibrationToggleButtonImageView.snp.makeConstraints { make in
            make.left.equalTo(descriptionLabelForVibrationSettings.snp.right).offset(20)
            make.centerY.equalToSuperview().offset(30)
            make.width.equalTo(60)
            make.height.equalTo(35)
        }

        view.addSubview(exitToMainMenuButtonWithImage)
        exitToMainMenuButtonWithImage.snp.makeConstraints { make in
            make.top.equalTo(secondaryBackgroundForLabelsAndButtons.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(40)
            make.width.equalTo(150)
            make.height.equalTo(40)
        }

        view.addSubview(returnToGameButtonWithImage)
        returnToGameButtonWithImage.snp.makeConstraints { make in
            make.top.equalTo(secondaryBackgroundForLabelsAndButtons.snp.bottom).offset(20)
            make.trailing.equalToSuperview().offset(-40)
            make.width.equalTo(150)
            make.height.equalTo(40)
        }
    }

    func linkAllButtonActionsWithSpecificFunctions() {
        soundToggleButtonImageView.addTarget(self, action: #selector(switchTheSoundSettingsState), for: .touchUpInside)
        soundsTappedButtonadd(uiButton: soundToggleButtonImageView)
        vibrationToggleButtonImageView.addTarget(self, action: #selector(switchTheVibrationSettingsState), for: .touchUpInside)
        soundsTappedButtonadd(uiButton: vibrationToggleButtonImageView)
        exitToMainMenuButtonWithImage.addTarget(self, action: #selector(navigateToMainMenu), for: .touchUpInside)
        soundsTappedButtonadd(uiButton: exitToMainMenuButtonWithImage)
        returnToGameButtonWithImage.addTarget(self, action: #selector(returnToGameInterface), for: .touchUpInside)
        soundsTappedButtonadd(uiButton: returnToGameButtonWithImage)
    }

    private func initializeDefaultSettings() {
        if UserDefaults.standard.object(forKey: "isSoundOn") == nil {
            UserDefaults.standard.set(true, forKey: "isSoundOn")
        }
        if UserDefaults.standard.object(forKey: "isVibrationOn") == nil {
            UserDefaults.standard.set(true, forKey: "isVibrationOn")
        }
    }

    private func loadSettingsState() {
        let isSoundEnabled = UserDefaults.standard.bool(forKey: "isSoundOn")
        let isVibrationEnabled = UserDefaults.standard.bool(forKey: "isVibrationOn")

        soundToggleButtonImageView.setImage(UIImage(named: isSoundEnabled ? "On" : "Off"), for: .normal)
        vibrationToggleButtonImageView.setImage(UIImage(named: isVibrationEnabled ? "On" : "Off"), for: .normal)
    }

    @objc private func switchTheSoundSettingsState() {
        let currentSoundState = soundToggleButtonImageView.currentImage == UIImage(named: "On")
        let newSoundState = !currentSoundState
        soundToggleButtonImageView.setImage(UIImage(named: newSoundState ? "On" : "Off"), for: .normal)
        UserDefaults.standard.set(newSoundState, forKey: "isSoundOn")
    }

    @objc private func switchTheVibrationSettingsState() {
        let currentVibrationState = vibrationToggleButtonImageView.currentImage == UIImage(named: "On")
        let newVibrationState = !currentVibrationState
        vibrationToggleButtonImageView.setImage(UIImage(named: newVibrationState ? "On" : "Off"), for: .normal)
        UserDefaults.standard.set(newVibrationState, forKey: "isVibrationOn")
    }

    @objc private func navigateToMainMenu() {
        dismiss(animated: false)
        exitToMenu?()
    }

    @objc private func returnToGameInterface() {
        onRetry?()
        dismiss(animated: true, completion: nil)
    }
}
