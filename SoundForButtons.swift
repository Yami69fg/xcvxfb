import UIKit
import SpriteKit
import AVFoundation

extension UIViewController {
    
    func soundsTappedButtonadd(uiButton: UIButton) {
        
        uiButton.addTarget(self, action: #selector(tappedButton(sender: )), for: .touchDown)
        
    }
    
    @objc private func tappedButton(sender: UIButton) {
        SoundTrackManger.shared.soundAndVibroAdd()
    }
}

class SoundTrackManger {
    
    static let shared = SoundTrackManger()
    private var player: AVAudioPlayer?

    private init() {}
    
    func soundAndVibroAdd() {
        
        let isSoundOn = UserDefaults.standard.bool(forKey: "isSoundOn")
        if isSoundOn {
            guard let url = Bundle.main.url(forResource: "audioButtonTappedSound", withExtension: "mp3") else { return }
            player = try? AVAudioPlayer(contentsOf: url)
            player?.play()
        }
        
        let isVibroOn = UserDefaults.standard.bool(forKey: "isVibroOn")
        if isVibroOn {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        }
    }
}

