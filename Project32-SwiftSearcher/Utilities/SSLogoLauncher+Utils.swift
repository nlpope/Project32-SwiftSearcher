//  File: SSLogoLauncher+Utils.swift
//  Project: Project32-SwiftSearcher
//  Created by: Noah Pope on 6/3/25.


//  * SEE IOS NOTES CLONE FOR 'ISFIRSTVISIT' REFERENCES IN SCENEDELEGATE
//  * BE SURE 'FORRESOURCE' NAME INS CONTANTS MATCHES LAUNCHSCREEN.MP4 FILE


import UIKit
import AVKit
import AVFoundation

class SSLogoLauncher
{
    var targetVC: HomeVC!
    var player: AVPlayer!
    var playerLayer: AVPlayerLayer!
    var animationDidPause = false

    
    init(targetVC: UIViewController) { self.targetVC = targetVC as? HomeVC }
    
    
    func configLogoLauncher( )
    {
        maskHomeVCForIntro()
        configNotifications()
        
        guard let url = Bundle.main.url(forResource: VideoKeys.launchScreen, withExtension: ".mp4")
        else { return }
        
        player = AVPlayer.init(url: url)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.videoGravity = AVLayerVideoGravity.resizeAspect
        playerLayer?.frame = targetVC.view.layer.frame
        playerLayer?.name = VideoKeys.playerLayerName
        player?.actionAtItemEnd = AVPlayer.ActionAtItemEnd.none
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, options: AVAudioSession.CategoryOptions.mixWithOthers)
        } catch {
            print("Background noise inclusion unsuccessful")
        }
        
        player?.play()
        
        targetVC.view.layer.insertSublayer(playerLayer!, at: 0)
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
    }
    
    
    func maskHomeVCForIntro()
    {
        targetVC.navigationController?.isNavigationBarHidden = true
        targetVC.view.backgroundColor = .black
    }
    
    
    func configNotifications()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(setPlayerLayerToNil), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reinitializePlayerLayer), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setPlayerLayerToNil), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reinitializePlayerLayer), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    
    @objc func playerDidFinishPlaying()
    {
        targetVC.navigationController?.isNavigationBarHidden = false
        targetVC.view.backgroundColor = .systemBackground
        
        PersistenceManager.isFirstVisitStatus = false
        removeAllAVPlayerLayers()
        
        targetVC.configNavigation()
        targetVC.configSearchController()
        targetVC.configDiffableDataSource()
        targetVC.fetchProjects()
    }
    
    
    func removeAllAVPlayerLayers()
    {
        if let layers = targetVC.view.layer.sublayers {
            for (i, layer) in layers.enumerated() {
                if layer.name == VideoKeys.playerLayerName { layers[i].removeFromSuperlayer() }
            }
        }
    }
    
    
    @objc func setPlayerLayerToNil() { player?.pause(); playerLayer = nil }
    
    
    @objc func reinitializePlayerLayer()
    {
        guard PersistenceManager.isFirstVisitStatus else { return }
        if let player = player {
            playerLayer = AVPlayerLayer(player: player)
            playerLayer?.name = VideoKeys.playerLayerName
            
            if #available(iOS 10.0, *) { if player.timeControlStatus == .paused { player.play() } }
            else { if player.isPlaying == false { player.play() } }
        }
    }
}

