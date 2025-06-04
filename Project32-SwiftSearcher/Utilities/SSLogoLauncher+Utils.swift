//  File: SSLogoLauncher+Utils.swift
//  Project: Project32-SwiftSearcher
//  Created by: Noah Pope on 6/3/25.


//  * SEE IOS NOTES CLONE FOR 'ISFIRSTVISIT' REFERENCES IN SCENEDELEGATE
//  * BE SURE 'FORRESOURCE' NAME INS CONTANTS MATCHES LAUNCHSCREEN.MP4 FILE


import UIKit
import AVKit
import AVFoundation
/**
 ---------------------------------------------
 PERSISTENCE MGR
 
 static var isFirstVisitStatus: Bool! = true {
 didSet { PersistenceManager.save(firstVisitStatus: self.isFirstVisitStatus) }
 }
 
 static func save(firstVisitStatus: Bool)
 {
 do {
 let encoder = JSONEncoder()
 let encodedStatus = try encoder.encode(firstVisitStatus)
 defaults.set(encodedStatus, forKey: SaveKeys.isFirstVisit)
 } catch {
 print("cannot save is first visit bool")
 }
 }
 
 static func retrieveFirstVisitStatus() -> Bool
 {
 guard let visitStatusData = defaults.object(forKey: SaveKeys.isFirstVisit) as? Data
 else { return true }
 
 do {
 let decoder = JSONDecoder()
 let savedStatus = try decoder.decode(Bool.self, from: visitStatusData)
 return savedStatus
 } catch {
 print("unable to load first visit status")
 return true
 }
 }
 ---------------------------------------------
 AVPLAYER+EXT
 
 extension AVPlayer
 {
 var isPlaying: Bool { return rate != 0 && error == nil }
 }
 ---------------------------------------------
 CONSTANTS+UTILS
 
 enum SaveKeys
 {
 static let isFirstVisit = "FirstVisit"
 }
 
 enum VideoKeys
 {
 static let launchScreen = "launchscreen"
 static let playerLayerName = "PlayerLayerName"
 }
 
 ---------------------------------------------
 SCENE DELEGATE
 in  func sceneWillResignActive(_ scene: UIScene) { }
 PersistenceManager.isFirstVisitStatus = true
 
 ---------------------------------------------
 HOMEVC
 
 var logoLauncher: XXLogoLauncher!
 var player = AVPlayer()
 
 viewDidLoad()
 {
 PersistenceManager.isFirstVisitStatus = true
 }
 
 deinit { logoLauncher.removeAllAVPlayerLayers() }
 
 ---------------------------------------------
 */

class NCLogoLauncher
{
    var targetVC: HomeTableVC!
    var player: AVPlayer!
    var playerLayer: AVPlayerLayer!
    var animationDidPause = false
    var isFirstVisit: Bool! = PersistenceManager.retrieveFirstVisitStatus() {
        didSet { PersistenceManager.save(firstVisitStatus: isFirstVisit) }
    }
    
    init(targetVC: UIViewController) { self.targetVC = targetVC as? HomeTableVC }
    
    
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
        targetVC.addressBar.isHidden = true
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
        targetVC.addressBar.isHidden = false
        targetVC.view.backgroundColor = .systemBackground
        
        isFirstVisit = false
        removeAllAVPlayerLayers()
        
        targetVC.addWebView()
        targetVC.setDefaultTitle()
        targetVC.configNavigation()
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
        guard isFirstVisit else { return }
        if let player = player {
            playerLayer = AVPlayerLayer(player: player)
            playerLayer?.name = VideoKeys.playerLayerName
            
            if #available(iOS 10.0, *) { if player.timeControlStatus == .paused { player.play() } }
            else { if player.isPlaying == false { player.play() } }
        }
    }
}

