//
//  Sounds.swift
//  ProjectSwift
//
//  Created by Freddy Morales on 15/03/25.
//

import Foundation
import AVKit

var player: AVAudioPlayer!

enum SoundOption: String{
    case chilldrum
}

func playSound(sound: SoundOption){
    let url = Bundle.main.url(forResource: sound.rawValue,  withExtension: ".mp3")
            
    guard url != nil else{
        return
    }
    do{
        player = try AVAudioPlayer(contentsOf: url!)
        player?.play()
    }catch{
        print("error")
    }
}

func stopSound() {
    player?.stop()
}

