//  File: SSLogoLauncher+Utils.swift
//  Project: Project32-SwiftSearcher
//  Created by: Noah Pope on 6/3/25.

//  * ADD THE MP4 FLICKER LOGO FILE
//  * ADD THE AVPLAYER+EXT FILE
//  * BE SURE 'FORRESOURCE' NAME INS CONTANTS MATCHES LAUNCHSCREEN.MP4 FILE
//  * (OPT) SEE IOS NOTES CLONE & MultiBrowser FOR REFERENCES

/**
 SCENE DELEGATE
 func sceneWillResignActive(_ scene: UIScene) { PersistenceManager.isFirstVisitStatus = true }
 ----------------------------------
 AVPLAYER+EXT
 import AVKit
 import AVFoundation

 extension AVPlayer
 {
     var isPlaying: Bool { return rate != 0 && error == nil }
 }
 ----------------------------------
 CONSTANTS
 enum SaveKeys
 {
     static let isFirstVisit = "isFirstVisitStatus"
 }

 enum VideoKeys
 {
 static let launchScreen = "launchscreen"
 static let playerLayerName = "PlayerLayerName"
 }
 ----------------------------------
 PERSISTENCE MANAGER
 enum PersistenceManager
 {
    static private let defaults = UserDefaults.standard
    static var isFirstVisitStatus: Bool! = fetchFirstVisitStatus() {
        didSet { PersistenceManager.saveFirstVisitStatus(status: self.isFirstVisitStatus) }
    }
 
 //-------------------------------------//
 // MARK: - SAVE / FETCH FIRST VISIT STATUS (FOR LOGO LAUNCHER)
 
     static func saveFirstVisitStatus(status: Bool)
     {
         do {
             let encoder = JSONEncoder()
             let encodedStatus = try encoder.encode(status)
             defaults.set(encodedStatus, forKey: SaveKeys.isFirstVisit)
         } catch {
             print("failed ato save visit status"); return
         }
     }
     
     
     static func fetchFirstVisitStatus() -> Bool
     {
         guard let visitStatusData = defaults.object(forKey: SaveKeys.isFirstVisit) as? Data
         else { return true }
         
         do {
             let decoder = JSONDecoder()
             let fetchedStatus = try decoder.decode(Bool.self, from: visitStatusData)
             return fetchedStatus
         } catch {
             print("unable to load first visit status")
             return true
         }
     }
 }
 ----------------------------------
 HOMEVC
 override func viewDidLoad()
 {
     super.viewDidLoad()
     PersistenceManager.isFirstVisitStatus = true
     // all config calls go here
 }
 
 
 override func viewWillAppear(_ animated: Bool)
 {
     logoLauncher = SSLogoLauncher(targetVC: self)
     if PersistenceManager.fetchFirstVisitStatus() {
         logoLauncher.configLogoLauncher()
     } else {
         fetchProjects()
     }
 }
 
 
 override func viewWillDisappear(_ animated: Bool) { logoLauncher = nil }
 
 
 deinit { logoLauncher.removeAllAVPlayerLayers() }
 ----------------------------------
 
 */

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
        // MAYBE LOOK INTO TINKERING W THE Z-AXIS VALUE FOR THINGS LIKE BROWSERS & SEARCHBARS CALLED EARLIER IN THE VDL
        
        PersistenceManager.isFirstVisitStatus = false
        removeAllAVPlayerLayers()
    
        // KEEP ALL CONFIG CALLS IN THE VDL (IN ONE PLACE) IF POSSIBLE SO ITS NOT NEEDED IN HERE AND THE VDAppear
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
