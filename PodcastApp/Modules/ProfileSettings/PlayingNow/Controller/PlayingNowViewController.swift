import UIKit
import AVFoundation

final class PlayingNowViewController: UIViewController {
    
    // MARK: - Private UI Properties
    private let playingNowView = PlayingNowView()
    
    // MARK: - Scroll Properties
    private var previousIndex = 0
    
    // MARK: - AV Properties
    private let player = AudioManager.shared
    private var podcasts: [PodcastEpisode]?
    
    // MARK: - Private Timers
    private var sliderTimer: Timer?
    private var timeLabelsTimer: Timer?
    
    // MARK: - Layout Properties
    private var lastContentOffset: CGPoint = .zero
    private let minimumScrollDistance: CGFloat = 10
    
    private var pageSize: CGSize {
        guard
            let layout = playingNowView.mainCollectionView.collectionViewLayout
                as? CustomCarouselFlowLayout
        else {
            return CGSize.zero
        }
        
        var pageSize = layout.itemSize
        if layout.scrollDirection == .horizontal {
            pageSize.width += layout.minimumLineSpacing
        } else {
            pageSize.height += layout.minimumLineSpacing
        }
        
        return pageSize
    }
    
    // MARK: - Init
    init(podcastEpisode: [PodcastEpisode]?, author: String?, index: Int) {
        self.podcasts = podcastEpisode
        self.playingNowView.authorNameLabel.text = author
        self.player.currentIndex = index
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addViews()
        setupConstraints()
        setupNavigationBar()
        
        // разворачиваем подкасты
        guard let unwrapPodcasts = podcasts else { return }
        
        // передаем массив с подкастами и индекс в playerManager
        player.setPodcasts(unwrapPodcasts)
        playingNowView.podcastTitleLabel.text = unwrapPodcasts[player.currentIndex].title
        
        playingNowView.transferDelegates(dataSource: self, delegate: self)
        
        previousIndex = player.currentIndex
        
        // настройка кнопок next и back
        setupNavigationButton()
        
        // настройка кнопки play и pause
        setupPlayPauseButton()
        
        // устанавливаем длительность подкаста при загрузке экрана
        setupCurrentRemainingTimeLabel(with: player.currentIndex)
        
        // настройка обновления слайдера
        changeActionTime()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        
        let indexPath = IndexPath(item: player.currentIndex, section: 0)
        
        // отображаем ячейку по индексу который пришел из предыдущего экрана
        DispatchQueue.main.async {
            self.playingNowView.mainCollectionView.scrollToItem(
                at: indexPath,
                at: .centeredHorizontally,
                animated: false
            )
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if player.isPause {
            player.resetPlayer()
        }
        
        player.isPlaying = false
    }
    
    // MARK: - Privaet Methods
    // MARK: - Setup PlayPause
    private func setupPlayPauseButton() {
        playingNowView.playPauseAction = { [weak self] in
            guard let self = self else { return }
            
            if self.player.isPlaying {
                self.player.pauseAudio()
                self.stopUpdatingSlider()
                self.stopUpdatingLabels()
                self.playingNowView.playPauseButton.setImage(
                    UIImage(named: "Play"),
                    for: .normal
                )
            } else if AudioManager.shared.isPause {
                self.player.resumeAudio()
                self.startUpdatingSlider()
                self.playingNowView.playPauseButton.setImage(
                    UIImage(named: "Stop"),
                    for: .normal
                )
            } else {
                self.player.playAudio()
                self.startUpdatingSlider()
                self.startUpdatingLabels()
                NotificationCenter.default.addObserver(
                    self,
                    selector: #selector(self.playerDidFinishPlaying),
                    name: .AVPlayerItemDidPlayToEndTime,
                    object: nil
                )
                self.playingNowView.playPauseButton.setImage(
                    UIImage(named: "Stop"),
                    for: .normal
                )
            }
        }
    }
    
    // MARK: - Slider Methods
    @objc private func updateSlider() {
        let currentTime = CMTimeGetSeconds(player.currentTime )
        let duration = CMTimeGetSeconds(player.currentItemDuration)
        
        if duration.isFinite && duration > 0 {
            let percentage = Float(currentTime / duration)
            playingNowView.durationSlider.value = percentage
            updateCurrentTimeLabel()
            updateRemainingTimeLabel()
        } else {
            playingNowView.durationSlider.value = 0
        }
    }
    
    // начинаем обновление слайдре
    private func startUpdatingSlider() {
        sliderTimer = Timer.scheduledTimer(
            timeInterval: 0.1,
            target: self,
            selector: #selector(updateSlider),
            userInfo: nil,
            repeats: true
        )
    }
    
    // останавливаем обновление слайдера
    private func stopUpdatingSlider() {
        sliderTimer?.invalidate()
        sliderTimer = nil
    }
    
    // MARK: - Finish Playing
    @objc func playerDidFinishPlaying(note: NSNotification) {
        // останавливаем обновление слайдера
        stopUpdatingSlider()
        
        //переключаемся на новую песню
        player.playNextSong()
        
        let currentIndexPath = IndexPath(row: player.currentIndex, section: 0)
        playingNowView.mainCollectionView.scrollToItem(
            at: currentIndexPath,
            at: .centeredHorizontally,
            animated: true
        )
        
        // обновляем слайдер после переключения на новую песню
        startUpdatingSlider()
    }
    
    // MARK: - Rewind
    private func changeActionTime() {
        playingNowView.sliderAction = { [weak self] in
            guard let weakSelf = self else { return }
            
            let timeToSeek = Double(weakSelf.playingNowView.durationSlider.value) * weakSelf.player.currentItemDuration.seconds
            weakSelf.player.seek(to: CMTime(seconds: timeToSeek, preferredTimescale: 1000))
        }
    }
    
    // MARK: - Next or Previous Button Logic
    private func setupNavigationButton() {
        playingNowView.nextOrBackAction = { [weak self] sender in
            self?.scrollToNextOrPreviousCell(sender)
        }
    }
    
    // метод для нахождения текущего индекса видимой ячейки
    private func centralVisibleIndexPath(in collectionView: UICollectionView) -> IndexPath? {
        let center = collectionView.convert(
            collectionView.center,
            from: collectionView.superview
        )
        return collectionView.indexPathForItem(at: center)
    }
    
    // метод для перехода к следующему или предыдущему item
    private func scrollToNextOrPreviousCell(_ sender: UIButton) {
        guard
            let currentVisibleIndexPath = centralVisibleIndexPath(in: playingNowView.mainCollectionView)
        else {
            return
        }
        
        let isNextButton = (sender == playingNowView.nextButton)
        let newIndex = updatedIndex(
            current: currentVisibleIndexPath.item,
            isNext: isNextButton
        )
        
        if isNextButton {
            player.playNextSong()
        } else {
            player.playPreviousSong()
        }
        
        if let title = podcasts?[newIndex].title {
            playingNowView.podcastTitleLabel.text = title
        }
        
        setupCurrentRemainingTimeLabel(with: newIndex)
        let nextIndexPath = IndexPath(item: newIndex, section: 0)
        playingNowView.mainCollectionView.scrollToItem(
            at: nextIndexPath,
            at: .centeredHorizontally,
            animated: true
        )
    }
    
    private func updatedIndex(current index: Int, isNext: Bool) -> Int {
        let numberOfItems = (podcasts?.count ?? 1) - 1
        if isNext {
            previousIndex += 1
            return min(index + 1, numberOfItems)
        } else {
            previousIndex -= 1
            return max(0, index - 1)
        }
    }
    
    // MARK: - Update labels with current time
    func formatTime(seconds: Double) -> String {
        if seconds.isInfinite || seconds.isNaN {
            return "00:00"
        }
        
        let minutes = Int(seconds) / 60
        let seconds = Int(seconds) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func startUpdatingLabels() {
        timeLabelsTimer = Timer.scheduledTimer(
            timeInterval: 1.0,
            target: self,
            selector: #selector(updateLabels),
            userInfo: nil,
            repeats: true
        )
        RunLoop.main.add(timeLabelsTimer!, forMode: .common)
    }
    
    func updateCurrentTimeLabel() {
        // Получите текущее время из AudioManager
        let currentTimeInSeconds = CMTimeGetSeconds(player.currentTime)
        let formattedTime = formatTime(seconds: currentTimeInSeconds)
        playingNowView.startDurationLabel.text = formattedTime
    }
    
    func updateRemainingTimeLabel() {
        // Получите текущую длительность песни и текущее время из AudioManager
        let currentTimeInSeconds = CMTimeGetSeconds(player.currentTime)
        let totalDurationInSeconds = CMTimeGetSeconds(player.currentItemDuration)
        
        let remainingTimeInSeconds = totalDurationInSeconds - currentTimeInSeconds
        let formattedTime = formatTime(seconds: remainingTimeInSeconds)
        
        playingNowView.endDurationLabel.text = formattedTime
    }
    
    // установка начальной длительности подкаста
    func setupCurrentRemainingTimeLabel(with index: Int) {
        let formattedDuration = formatTime(seconds: Double(podcasts?[index].duration ?? 0))
        playingNowView.endDurationLabel.text = formattedDuration
    }
    
    @objc func updateLabels() {
        updateCurrentTimeLabel()
        updateRemainingTimeLabel()
    }
    
    func stopUpdatingLabels() {
        timeLabelsTimer?.invalidate()
        timeLabelsTimer = nil
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
            image: UIImage(named: "PlaylistIcon"),
            style: .done,
            target: self,
            action: nil
        )
        
        rightBarButton.tintColor = .black
        navigationItem.rightBarButtonItem = rightBarButton
    }
}

// MARK: - UICollectionViewDataSource
extension PlayingNowViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        podcasts?.count ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PodcastImageCell.reuseId,
                for: indexPath) as? PodcastImageCell
        else {
            return  UICollectionViewCell()
        }
        
        let podcastImage = podcasts?[indexPath.row].image ?? ""
        cell.configureView(with: podcastImage)
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
        guard scrollView == playingNowView.mainCollectionView else { return }
        
        let visibleRect = CGRect(
            origin: scrollView.contentOffset,
            size: scrollView.bounds.size
        )
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        
        guard let indexPath = playingNowView.mainCollectionView.indexPathForItem(at: visiblePoint) else {
            return
        }
        
        // Сравниваем новый индекс с предыдущим
        if indexPath.item > previousIndex {
            player.playNextSong()
        } else if indexPath.item < previousIndex {
            player.playPreviousSong()
        }
        
        // Обновляем предыдущий индекс новым значением
        previousIndex = indexPath.item
        
        updatePlayerAndUI(for: indexPath.item)
        setupCurrentRemainingTimeLabel(with: indexPath.item)
        playingNowView.mainCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    private func updatePlayerAndUI(for index: Int) {
        player.currentIndex = index
        playingNowView.podcastTitleLabel.text = podcasts?[index].title
        setupCurrentRemainingTimeLabel(with: index)
        updateCurrentTimeLabel()
        updateSlider()
    }
}

