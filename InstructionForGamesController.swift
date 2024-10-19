import UIKit
import SnapKit

class InstructionForGamesController: UIViewController {
    
    var text = ""
    
    private var instructionForGame: UILabel = {
        let instructionLabel = UILabel()
        instructionLabel.numberOfLines = 0
        instructionLabel.textAlignment = .center
        instructionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return instructionLabel
    }()
    
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "BackGroundGame")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let secondaryBackgroundForLabelsAndButtons: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "BGForAll")
        return imageView
    }()
    
    private let instructionGirl: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "InstructionWomen")
        return imageView
    }()
    
    private let centralInstructionIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "InstructionLabel")
        return imageView
    }()
    
    private let buttonBackToMenu: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "ButtonExitToMenu"), for: .normal)
        return button
    }()
    
    init(text: String) {
        self.text = text
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonBackToMenu.addTarget(self, action: #selector(openLevelView), for: .touchUpInside)
        soundsTappedButtonadd(uiButton: buttonBackToMenu)
        
        view.addSubview(backgroundImageView)
        view.addSubview(secondaryBackgroundForLabelsAndButtons)
        view.addSubview(instructionGirl)
        view.addSubview(centralInstructionIconImageView)
        view.addSubview(buttonBackToMenu)
        
        let text = NSMutableAttributedString(string: text)
        text.addAttributes([.font: UIFont(name: "Questrian", size: 20) ?? UIFont.systemFont(ofSize: 24), .foregroundColor: UIColor.white], range: NSRange(location: 0, length: text.length))
        instructionForGame.attributedText = text
        
        view.addSubview(instructionForGame)
        
        
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        secondaryBackgroundForLabelsAndButtons.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.centerY).offset(50)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalToSuperview().multipliedBy(0.35)
        }
        
        instructionGirl.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.right.equalTo(secondaryBackgroundForLabelsAndButtons.snp.centerX).offset(50)
            make.width.equalToSuperview().multipliedBy(0.6)
            make.height.equalToSuperview().multipliedBy(0.5)
        }
        
        centralInstructionIconImageView.snp.makeConstraints { make in
            make.bottom.equalTo(secondaryBackgroundForLabelsAndButtons.snp.top).offset(50)
            make.centerX.equalTo(secondaryBackgroundForLabelsAndButtons.snp.centerX)
            make.width.equalToSuperview().multipliedBy(0.7)
            make.height.equalTo(85)
        }
        
        buttonBackToMenu.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.width.height.equalTo(50)
        }
        
        instructionForGame.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(centralInstructionIconImageView.snp.bottom).offset(10)
            make.left.equalTo(secondaryBackgroundForLabelsAndButtons.snp.left).offset(7)
            make.right.equalTo(secondaryBackgroundForLabelsAndButtons.snp.right).offset(-7)
        }
        
    }
    
    @objc func openLevelView(){
        self.dismiss(animated: false)
    }
    
}

