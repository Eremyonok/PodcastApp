import Foundation
import AVFoundation


final class AudioManager {
    static let shared = AudioManager()
    
    // MARK: - Private Properties
    private var player: AVPlayer?
    
    var isPlaying = false
    private(set) var isPause = false
    
    
    private var podcasts: [PodcastEpisode] = []
    
    // MARK: - Public Properties
    var currentTime: CMTime {
        guard let currentTime = player?.currentTime() else { return CMTime() }
        return currentTime
    }
    
    var currentItemDuration: CMTime {
        guard let seconds = podcasts[currentIndex].duration else { return CMTime.zero }
        return CMTimeMake(value: Int64(seconds), timescale: 1)
    }
    
    var currentIndex = 0
    
    // MARK: - Private Init
    private init() {
        do {
            try AVAudioSession.sharedInstance().setCategory(
                .playback,
                mode: .default,
                options: [.mixWithOthers, .allowAirPlay]
            )
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Ошибка настройки аудиосесии \(error)")
        }
    }
    
    // MARK: - Public Methods
//    func playAudio() {
//        isPlaying = true
//
//        guard let currentURL = podcasts[currentIndex].enclosureUrl else { return }
//
//        if let audioURL = URL(string: currentURL) {
//            let playerItem = AVPlayerItem(url: audioURL)
//            if player == nil {
//                player = AVPlayer(playerItem: playerItem)
//            } else {
//                player?.replaceCurrentItem(with: playerItem)
//            }
//        }
//
//        player?.play()
//    }

    func playAudio() {
        isPlaying = true

        guard let currentURL = podcasts[currentIndex].enclosureUrl else { return }

        if let audioURL = URL(string: currentURL) {
            let playerItem = AVPlayerItem(url: audioURL)
            player = AVPlayer(playerItem: playerItem)
        }

        player?.play()
    }
    
    func playNextSong() {
        setNextSong()
        if isPlaying {
            playAudio()
        }
    }
    
    func playPreviousSong() {
        setPreviousSong()
        if isPlaying {
            playAudio()
        }
    }
    
    func pauseAudio() {
        isPause = true
        isPlaying = false
        player?.pause()
    }
    
    func resumeAudio() {
        isPause = false
        isPlaying = true
        player?.play()
    }
    
    func stopAudio() {
        isPlaying = false
        isPause = false
        player?.pause()
        player?.seek(to: CMTime.zero) // Перемещаемся в начало трека
    }
    
    func setPodcasts(_ podcasts: [PodcastEpisode]) {
        self.podcasts = podcasts
    }
    
    func resetPlayer() {
//        player?.pause() // На случай, если воспроизведение активно
        player = nil
    }
    
    // MARK: - Private Methods
    private func setNextSong() {
        guard !podcasts.isEmpty else { return }
        
        let wasPlaying = isPlaying
        currentIndex += 1
        
        if currentIndex >= podcasts.count {
            currentIndex = podcasts.count - 1
            stopAudio()
            return
        }
        
        player = nil
        isPlaying = false
        isPause = false
        
        if wasPlaying {
            playAudio()
        }
    }
    
    private func setPreviousSong() {
        guard !podcasts.isEmpty else { return }
        
        let wasPlaying = isPlaying
        
        currentIndex = max(0, currentIndex - 1)
        
        player = nil
        isPlaying = false
        isPause = false
        
        if wasPlaying {
            playAudio()
        }
    }
}

extension AudioManager {
    func seek(to time: CMTime) {
        player?.seek(to: time)
    }
}

extension AudioManager {
    // получение длительности подкаста для отобржанения
    func getDuration(for url: URL, completion: @escaping (CMTime?) -> Void) {
        let asset = AVAsset(url: url)
        let durationKey = "duration"
        
        // Загружаем метаданные
        asset.loadValuesAsynchronously(forKeys: [durationKey]) {
            var error: NSError? = nil
            let status = asset.statusOfValue(forKey: durationKey, error: &error)
            switch status {
            case .loaded:
                completion(asset.duration)
            case .failed, .cancelled, .loading, .unknown:
                completion(nil)
            @unknown default:
                completion(nil)
            }
        }
    }
}
