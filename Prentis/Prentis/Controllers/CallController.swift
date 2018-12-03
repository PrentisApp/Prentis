//
//  ViewController.swift
//  Prentis
//
//  Created by Shakeeb Majid on 9/1/18.
//  Copyright © 2018 PrentisApp. All rights reserved.
//

import UIKit
import AgoraRtcEngineKit
class CallController: UIViewController, AgoraRtcEngineDelegate {
    
    @IBOutlet weak var localVideo: UIView!
    @IBOutlet weak var remoteVideo: UIView!
    @IBOutlet weak var controlButtons: UIView!
    @IBOutlet weak var remoteVideoMutedIndicator: UIImageView!
    @IBOutlet weak var localVideoMutedBg: UIImageView!
    @IBOutlet weak var localVideoMutedIndicator: UIImageView!
    @IBOutlet weak var muteButton: UIButton!
    @IBOutlet weak var muteView: UIView!
    
    @IBOutlet weak var switchButton: UIButton!
    @IBOutlet weak var switchView: UIView!
    
    @IBOutlet weak var endButton: UIButton!
    @IBOutlet weak var endView: UIView!
    
    var agoraKit: AgoraRtcEngineKit?
    var workItem: DispatchWorkItem?
    var localCenter = CGPoint(x: 0,y :0)
    var channelName: String!
    var localUID: UInt!
    var remoteUID: UInt!
    
    func initializeAgoraEngine() {
        agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: "be579b93d395458bb85fae03f92ad582", delegate: self)
    }
    
    func setChannelProfile() {
        agoraKit?.setChannelProfile(.communication)
    }
    
    func enableVideo() {
        agoraKit?.enableVideo()
    }
    
    func setupLocalVideo() {
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = localUID
        print("local uid: \(videoCanvas.uid)")
        videoCanvas.view = localVideo
        videoCanvas.renderMode = .hidden
        agoraKit?.setupLocalVideo(videoCanvas)
    }
    
    func setupRemoteVideo() {
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = remoteUID
        print("remote uid: \(videoCanvas.uid)")

        videoCanvas.view = remoteVideo
        videoCanvas.renderMode = .fit
        agoraKit?.setupRemoteVideo(videoCanvas)
    }
    
    func joinChannel() {
        agoraKit?.joinChannel(byToken: nil, channelId: channelName, info:nil, uid:localUID){[weak self] (sid, uid, elapsed) -> Void in

            // Join channel "demoChannel1"
            
            print("hi the uid you joined with is \(uid)")
        }
    }
    
    
    
    func leaveChannel() {
        agoraKit?.leaveChannel(nil)
        hideControlButtons()
        UIApplication.shared.isIdleTimerDisabled = false
        remoteVideo.removeFromSuperview()
        localVideo.removeFromSuperview()
        agoraKit = nil
    }
    
    func hideControlButtons() {
        controlButtons.isHidden = true
    }
    
    @objc func toggleControlButtons(_ sender: UITapGestureRecognizer) {
        if controlButtons.isHidden {
            controlButtons.isHidden = false
            workItem = DispatchWorkItem{ self.hideControlButtons() }
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: workItem!)
        } else {
            controlButtons.isHidden = true
            workItem?.cancel()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //muteView.layer.borderWidth = 1
        muteView.layer.masksToBounds = false
        //muteView.layer.borderColor = UIColor.black.cgColor
        muteView.layer.cornerRadius = muteView.frame.height/2
        muteView.clipsToBounds = true
        let origImage = UIImage(named: "icons8-no-audio-filled-100")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        muteButton.setImage(tintedImage, for: .normal)
        muteButton.tintColor = .white

        //endView.layer.borderWidth = 1
        endView.layer.masksToBounds = false
        //endView.layer.borderColor = UIColor.black.cgColor
        endView.layer.cornerRadius = endView.frame.height/2
        endView.clipsToBounds = true
        
        let origEndImage = UIImage(named: "icons8-delete-filled-100")
        let tintedEndImage = origEndImage?.withRenderingMode(.alwaysTemplate)
        endButton.setImage(tintedEndImage, for: .normal)
        endButton.tintColor = .white
        
        //switchView.layer.borderWidth = 1
        switchView.layer.masksToBounds = false
        //switchView.layer.borderColor = UIColor.black.cgColor
        switchView.layer.cornerRadius = switchView.frame.height/2
        switchView.clipsToBounds = true
        
        let origSwitchImage = UIImage(named: "icons8-switch-camera-filled-100")
        let tintedSwitchImage = origSwitchImage?.withRenderingMode(.alwaysTemplate)
        switchButton.setImage(tintedSwitchImage, for: .normal)
        switchButton.tintColor = .white

        // Do any additional setup after loading the view, typically from a nib.
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {
            self.hideControlButtons()
        })
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.toggleControlButtons(_:)))
        remoteVideo.addGestureRecognizer(tap)
        endView.layer.zPosition = 2
        initializeAgoraEngine()
        controlButtons?.backgroundColor = UIColor(white: 1, alpha: 0.0)
        setChannelProfile()
        
        enableVideo()
        
        localVideo.layer.cornerRadius = 15;
        localVideo.layer.masksToBounds = true;
        let configuration = AgoraVideoEncoderConfiguration(size:
            AgoraVideoDimension640x360, frameRate: .fps15, bitrate: 400,
                                        orientationMode: .fixedPortrait)
        
        agoraKit?.setVideoEncoderConfiguration(configuration);
        
        setupLocalVideo()
        
        joinChannel()
        
        setupRemoteVideo()
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(self.panLocal(_:)))
        localVideo.addGestureRecognizer(pan)
    }
    
    @objc func panLocal(_ pan: UIPanGestureRecognizer) {
        if pan.state == .began {
            localCenter = localVideo.center // store old button center
        } else if pan.state == .ended || pan.state == .failed || pan.state == .cancelled {
            let location = pan.location(in: view)
            localVideo.center = location // restore button center
        } else {
            let location = pan.location(in: view) // get pan location
            localVideo.center = location // set button to where finger is
        }
    }
    
    @IBAction func onMute(_ sender: UIButton ) {
        sender.isSelected = !sender.isSelected
        agoraKit?.muteLocalAudioStream(sender.isSelected)
    }
    @IBAction func onEndCall(_ sender: Any) {
        leaveChannel()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSwitchCamera(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        agoraKit?.switchCamera()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

