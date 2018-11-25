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
    
    @IBOutlet weak var endButton: UIButton!
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
        // Do any additional setup after loading the view, typically from a nib.
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {
            self.hideControlButtons()
        })
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.toggleControlButtons(_:)))
        remoteVideo.addGestureRecognizer(tap)
        endButton.layer.zPosition = 2
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

