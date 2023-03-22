//
//  VideoPlayerView.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/03/22.
//

import UIKit
import AVFoundation

class VideoPlayerView: UIView {
    
    // 연산 프로퍼티 추가해서 매번 하위클래스를 캐스팅 할 필요없도록
    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }
    
    var player: AVPlayer? {
        get {
            return playerLayer.player
        }
        set {
            playerLayer.player = newValue
        }
    }
    
    // 기본 CALayer대신 AVPlayerLayer사용
    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadXib()
    }
    
    private func loadXib() {
        let identifier = String(describing: type(of: self))
        let nibs = Bundle.main.loadNibNamed(identifier, owner: self, options: nil)
        
        guard let customView = nibs?.first as? UIView else { return }
        self.addSubview(customView)
    }
}
