//
//  PlayerManager.swift
//  PodcastApp
//
//  Created by Kirill Taraturin on 04.10.2023.
//

import Foundation
import AVFoundation


final class AudioManager {
    static let shared = AudioManager()
    
    private var player: AVPlayer?
    
    private init() {}

}
