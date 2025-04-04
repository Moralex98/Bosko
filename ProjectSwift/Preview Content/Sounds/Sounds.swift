//
//  Sounds.swift
//  ProjectSwift
//
//  Created by Freddy Morales on 15/03/25.
//

import Foundation
import AVKit

var backgroundPlayer: AVAudioPlayer!
var effectPlayer: AVAudioPlayer!

enum SoundOption: String{
    case Basura
    case IntroCumbia
    case Introduc
    case mar
    case selva
    case coin
    case power
}

func playBackgroundSound(sound: SoundOption, fadeOutPrevious: Bool = true) {
    guard let url = Bundle.main.url(forResource: sound.rawValue, withExtension: "mp3") else {
        print("No se encontró el sonido de fondo: \(sound.rawValue)")
        return
    }

    // Si ya está sonando ese sonido, no hagas nada
    if backgroundPlayer != nil, backgroundPlayer.isPlaying,
       backgroundPlayer.url == url {
        return
    }

    if fadeOutPrevious, backgroundPlayer != nil {
        backgroundPlayer.setVolume(0, fadeDuration: 1.0)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            startNewBackgroundSound(url: url)
        }
    } else {
        startNewBackgroundSound(url: url)
    }
}

private func startNewBackgroundSound(url: URL) {
    do {
        backgroundPlayer = try AVAudioPlayer(contentsOf: url)
        backgroundPlayer.volume = 1.0
        backgroundPlayer.numberOfLoops = -1
        backgroundPlayer.play()
    } catch {
        print("Error al reproducir música de fondo: \(error.localizedDescription)")
    }
}


func stopBackgroundSound() {
    backgroundPlayer?.stop()
}

func playEffectSound(sound: SoundOption) {
    if !areEffectsEnabled { return } // ← se respeta configuración

    guard let url = Bundle.main.url(forResource: sound.rawValue, withExtension: "mp3") else {
        print("No se encontró el efecto: \(sound.rawValue)")
        return
    }
    
    do {
        effectPlayer = try AVAudioPlayer(contentsOf: url)
        effectPlayer?.play()
    } catch {
        print("Error al reproducir efecto: \(error.localizedDescription)")
    }
}


