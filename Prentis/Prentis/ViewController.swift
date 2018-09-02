//
//  ViewController.swift
//  Prentis
//
//  Created by Shakeeb Majid on 9/1/18.
//  Copyright © 2018 PrentisApp. All rights reserved.
//

import UIKit
import AgoraRtcEngineKit

class ViewController: UIViewController, AgoraRtcEngineDelegate {
    
    @IBOutlet weak var localVideo: UIView!
    @IBOutlet weak var remoteVideo: UIView!
    @IBOutlet weak var controlButtons: UIView!
    @IBOutlet weak var remoteVideoMutedIndicator: UIImageView!
    @IBOutlet weak var localVideoMutedBg: UIImageView!
    @IBOutlet weak var localVideoMutedIndicator: UIImageView!
    
    var agoraKit: AgoraRtcEngineKit?
    
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
        videoCanvas.uid = 5
        print("local uid: \(videoCanvas.uid)")
        videoCanvas.view = localVideo
        videoCanvas.renderMode = .hidden
        agoraKit?.setupLocalVideo(videoCanvas)
    }
    
    func setupRemoteVideo() {
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = 6
        print("remote uid: \(videoCanvas.uid)")

        videoCanvas.view = remoteVideo
        videoCanvas.renderMode = .fit
        agoraKit?.setupRemoteVideo(videoCanvas)
    }
    
    func joinChannel() {
        agoraKit?.joinChannel(byToken: nil, channelId: "demoChannel1", info:nil, uid:5){[weak self] (sid, uid, elapsed) -> Void in

            // Join channel "demoChannel1"
            
            print("hi the uid you joined with is \(uid)")
        }
    }
    
    func leaveChannel() {
        agoraKit?.leaveChannel(nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        initializeAgoraEngine()
        
        setChannelProfile()
        
        enableVideo()
        
        let configuration = AgoraVideoEncoderConfiguration(size:
            AgoraVideoDimension640x360, frameRate: .fps15, bitrate: 400,
                                        orientationMode: .fixedPortrait)
        
        agoraKit?.setVideoEncoderConfiguration(configuration);
        
        setupLocalVideo()
        
        joinChannel()
        
        setupRemoteVideo()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

