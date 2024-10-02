//
//  PlayingNowViewController.swift
//  PodcastApp
//
//  Created by Дмитрий Лоренц on 24.09.2023.
//

import UIKit
import AVFoundation

final class PlayingNowViewController: UIViewController {
    
    // MARK: - AV Properties
    var player: AVPlayer?
    var timer: Timer?
    
    var testArraySongs = [
        TestModel(color: .blue, url: "https://www.kozco.com/tech/32.mp3"),
        TestModel(color: .green, url: "https://file-examples.com/storage/feaade38c1651bd01984236/2017/11/file_example_MP3_700KB.mp3"),
        TestModel(color: .orange, url: "https://www.kozco.com/tech/LRMonoPhase4.mp3"),
        TestModel(color: .red, url: "https://www.kozco.com/tech/piano2-CoolEdit.mp3"),
        TestModel(color: .yellow, url: "https://www.kozco.com/tech/organfinale.mp3")
    ]
    
    // MARK: - Private Properties
    //    private var currentPage = 0
    
    private var pageSize: CGSize {
        let layout = playingNowView.mainCollectionView.collectionViewLayout as! CustomCarouselFlowLayout
        var pageSize = layout.itemSize
        if layout.scrollDirection == .horizontal {
            pageSize.width += layout.minimumLineSpacing
        } else {
            pageSize.height += layout.minimumLineSpacing
        }
        return pageSize
    }
    
    // MARK: - Private UI Properties
    private let playingNowView = PlayingNowView()
    private let colors = [UIColor.red, UIColor.green, UIColor.brown, UIColor.blue]
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addViews()
        setupConstraints()
        setupNavigationBar()
        
        playingNowView.transferDelegates(dataSource: self, delegate: self)
        
        // настройка кнопок next и back
        setupNavigationButton()
        
        // настройка кнопки play и pause
        setupPlayPauseButton(url: testArraySongs[0].url)
        
        // настройка обновления слайдера
        //        changeActionTime()
        
    }
    
    // MARK: - Private Actions
    @objc private func rightBarButtonDidTapped() {
    }
    
    // MARK: - Privaet Methods
    
    // MARK: - AUDIO METHODS
    private func setupPlayPauseButton(url: String) {
        playingNowView.playPauseAction = { [weak self] in
            if self?.playingNowView.playPauseButton.currentImage == UIImage(named: "Play") {
                //запускаем проигрывание аудио
                self?.playAudio(with: url)
                //устаналиваем изображение Stop для кнопки
                self?.playingNowView.playPauseButton.setImage(
                    UIImage(named: "Stop"),
                    for: .normal
                )
                // обновляем значение слайдера
                self?.startUpdatingSlider()
            } else {
                // устанавливаем паузу для аудио
                self?.pauseAudio()
                
                // останавливаем обновление значения слайдера
                self?.stopUpdatingSlider()
                
                //устаналиваем изображение Play для кнопки
                self?.playingNowView.playPauseButton.setImage(
                    UIImage(named: "Play"),
                    for: .normal
                )
            }
        }
    }
    
    // воспроизводим аудто
    private func playAudio(with url: String) {
        if let audioURL = URL(string: url) {
            if player == nil {
                let playerItem = AVPlayerItem(url: audioURL)
                player = AVPlayer(playerItem: playerItem)
            }
            player?.play()
        }
    }
    
    // пауза
    private func pauseAudio() {
        player?.pause()
    }
    
    // возобновляем воспроизведение
    private func resumeAudio() {
        player?.play()
    }
    
    func stopAndPlayNewAudio(url: URL) {
        
        /*
         если у кнопки изображение play, то останавливаем воспроизведение и создаем новый плеер, но не запускаем
         */
        if playingNowView.playPauseButton.currentImage == UIImage(named: "Play") {
            player?.pause()
            
            let playerItem = AVPlayerItem(url: url)
            player = AVPlayer(playerItem: playerItem)
        } else {
            player?.pause()
            
            let playerItem = AVPlayerItem(url: url)
            player = AVPlayer(playerItem: playerItem)
            player?.play()
            
            // Начните обновлять слайдер снова, если это требуется.
            startUpdatingSlider()
        }
        
    }
    
    // обновляем слайдер
    @objc func updateSlider() {
        let currentTime = CMTimeGetSeconds(player?.currentTime() ?? CMTime.zero)
        let duration = CMTimeGetSeconds(player?.currentItem?.duration ?? CMTime.zero)
        
        if duration.isFinite && duration > 0 {
            let percentage = Float(currentTime / duration)
            playingNowView.durationSlider.value = percentage
        } else {
            playingNowView.durationSlider.value = 0
        }
    }
    
    // начинаем обновление слайдре
    func startUpdatingSlider() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateSlider), userInfo: nil, repeats: true)
    }
    
    // останавливаем обновление слайдера
    
    func stopUpdatingSlider() {
        timer?.invalidate()
        timer = nil
    }
    
    
    
    // перемотка
    //    private func changeActionTime() {
    //        playingNowView.sliderAction = { [weak self] in
    //            let timeToSeek = Double(self?.playingNowView.durationSlider.value ?? 0.0) * (self?.player.player?.currentItem!.duration.seconds ?? 0.0)
    //
    //
    //            self?.player.player?.seek(to: CMTime(seconds: timeToSeek, preferredTimescale: 1))
    //        }
    //    }
    
    // MARK: - Navigation Buttons
    private func setupNavigationButton() {
        playingNowView.nextOrBackAction = { [weak self] sender in
            self?.scrollToNextOrPreviousCell(sender)
        }
    }
    
    // метод для перехода к следующему или предыдущему item
    private func scrollToNextOrPreviousCell(_ sender: UIButton) {
        let contentOffset = playingNowView.mainCollectionView.contentOffset
        let cellSize = playingNowView.layout.itemSize
        let numberOfItems = playingNowView.mainCollectionView.numberOfItems(inSection: 0)
        let currentItemIndex = Int(round(contentOffset.x / cellSize.width))
        var currentIndexPath = IndexPath()
        
        
        if sender == playingNowView.nextButton {
            if currentItemIndex < numberOfItems - 1 {
                currentIndexPath = IndexPath(item: currentItemIndex + 1, section: 0)
            } else {
                // Если уже на последней ячейке, не изменяем индекс
                currentIndexPath = IndexPath(item: currentItemIndex, section: 0)
            }
        } else {
            if currentItemIndex > 0 {
                currentIndexPath = IndexPath(item: currentItemIndex - 1, section: 0)
            } else {
                // Если уже на первой ячейке, не изменяем индекс
                currentIndexPath = IndexPath(item: currentItemIndex, section: 0)
            }
        }
        
        guard let currentIndexLastItem = currentIndexPath.last else { return }
        if let newAudioURL = URL(string: testArraySongs[currentIndexLastItem].url) {
            stopAndPlayNewAudio(url: newAudioURL)
        }
        
        playingNowView.mainCollectionView.scrollToItem(at: currentIndexPath, at: .centeredHorizontally, animated: true)
    }
}


// MARK: - Setup UI
extension PlayingNowViewController {
    private func addViews() {
        view.addSubview(playingNowView)
    }
    
    private func setupConstraints() {
        playingNowView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupNavigationBar() {
        title = "Now playing"
        
        let rightBarButton = UIBarButtonItem(
            image: UIImage(named: "playlistIcon"),
            style: .done,
            target: self,
            action: #selector(rightBarButtonDidTapped)
        )
        
        rightBarButton.tintColor = .black
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
}

// MARK: - UICollectionViewDataSource
extension PlayingNowViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        testArraySongs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PodcastImageCell.reuseId,
                for: indexPath) as? PodcastImageCell
        else {
            return  UICollectionViewCell()
        }
        
        let song = testArraySongs[indexPath.row].color
        cell.configureView(with: song)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension PlayingNowViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        playingNowView.mainCollectionView.scrollToItem(
            at: indexPath,
            at: .centeredHorizontally,
            animated: true
        )
    }
}

// MARK: - UIScrollViewDelegate
extension PlayingNowViewController {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //        let layout = playingNowView.mainCollectionView.collectionViewLayout as! CustomCarouselFlowLayout
        //        let pageSide = (layout.scrollDirection == .horizontal)
        //        ? self.pageSize.width
        //        : self.pageSize.height
        //
        //        let offset = (layout.scrollDirection == .horizontal)
        //        ? scrollView.contentOffset.x
        //        : scrollView.contentOffset.y
        //
        //        currentPage = Int(floor((offset - pageSide / 2) / pageSide) + 1)
    }
}
