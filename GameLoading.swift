import UIKit
import SnapKit

class GameLoading: UIViewController {

    private let backgroundSleeve: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "BackGroundGame")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let spinDisc: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Disc")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 100
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let blinkSpot: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "LoadLabel")
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        stageGear()
        rollOn()
        flipNext()
    }

    private func stageGear() {
        view.addSubview(backgroundSleeve)
        backgroundSleeve.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        view.addSubview(spinDisc)
        spinDisc.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(200)
        }

        view.addSubview(blinkSpot)
        blinkSpot.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(spinDisc.snp.bottom).offset(20)
            make.width.equalToSuperview().multipliedBy(0.6)
            make.height.equalToSuperview().multipliedBy(0.1)
        }
    }

    private func rollOn() {
        let spinnerTwist = CABasicAnimation(keyPath: "transform.rotation")
        spinnerTwist.toValue = NSNumber(value: Double.pi * 2)
        spinnerTwist.duration = 2
        spinnerTwist.repeatCount = .infinity
        spinDisc.layer.add(spinnerTwist, forKey: "rotationAnimation")
        
        UIView.animate(withDuration: 0.5, delay: 0, options: [.repeat, .autoreverse]) {
            self.blinkSpot.alpha = 0
        }
    }

    private func flipNext() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            let mainLine = MainMenuSquad()
            mainLine.modalTransitionStyle = .crossDissolve
            mainLine.modalPresentationStyle = .fullScreen
            self.present(mainLine, animated: true, completion: nil)
        }
    }
}

