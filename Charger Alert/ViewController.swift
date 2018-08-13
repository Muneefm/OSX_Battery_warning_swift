//
//  ViewController.swift
//  Charger Alert
//
//  Created by Muneef m on 27/7/18.
//  Copyright © 2018 Muneef m. All rights reserved.
//

import Cocoa
import Foundation
import AVFoundation
import AVFoundation

var player: AVAudioPlayer?
let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)


class ViewController: NSViewController {
    static var context = 0

    override func viewDidLoad() {
        super.viewDidLoad()
       // startEvilService()
        if let button = statusItem.button {
            button.action = #selector(self.statusBarButtonClicked(sender:))
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }
    }

    @objc func statusBarButtonClicked(sender: NSStatusBarButton) {
        let event = NSApp.currentEvent!
        
        if event.type == NSEvent.EventType.rightMouseUp {
            print("Right click")
        } else {
            print("Left click")
        }
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func startEvilService(){
        let loop: CFRunLoopSource = IOPSNotificationCreateRunLoopSource({ (context: UnsafeMutableRawPointer?) in
            debugPrint("Power source changed")
           // let blob = IOPSCopyPowerSourcesInfo()
          //  print(blob)
            let psInfo = IOPSCopyPowerSourcesInfo().takeRetainedValue()
            let psList = IOPSCopyPowerSourcesList(psInfo).takeRetainedValue() as [CFTypeRef]
            
            for ps in psList {
                if let psDesc = IOPSGetPowerSourceDescription(psInfo, ps).takeUnretainedValue() as? [String: Any] {
                        let isCharging = (psDesc["Power Source State"] as? String)
                       if( isCharging == "Battery Power" ){
                        let sound: NSSound
                        sound =  (NSSound(named: NSSound.Name(rawValue: "suffer")))!
                        if(!sound.isPlaying){
                            sound.play()
                            print("is not playing")
                        }else{
                            print("is  playing")
                        }
                    }
                    
                }
            }
           
        }, &ViewController.context).takeRetainedValue() as CFRunLoopSource
        CFRunLoopAddSource(CFRunLoopGetCurrent(), loop, CFRunLoopMode.defaultMode)
    }

}

