import UIKit

final class OnboardingViewController: UIViewController {
    
    // MARK: - Privaet UI Properties
    private let onboardingView = OnboardingView()
    
    // MARK: - Private Properties
    private let infoSlides = Slide.getInfoSlides()
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(onboardingView)
        setupConstraints()
        
        onboardingView.transferDelegates(
            dataSource: self,
            delegate: self
        )
        
        onboardingView.updateInfoLabels(infoSlides[0])
        setupButtonAction()
        setupNextButton()
        onboardingView.setupPageControl(infoSlides.count)
    }
    
    // MARK: - Private Methods
    private func setupConstraints() {
        onboardingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // переход на таб бар после нажания на кнопку Start или skip
    private func setupButtonAction() {
        onboardingView.buttonAction = { [weak self] in
            AppSettingsManager.setCompleted()
            let tabBarVC = CustomTabBarController()
            tabBarVC.modalPresentationStyle = .fullScreen
            self?.present(tabBarVC, animated: true)
        }
    }
    
    private func setupNextButton() {
        onboardingView.nextButtonAction = { [weak self] in
            self?.handleNextButtonTapped()
        }
    }
    
    // обновления UI при нажатии на кнопку nextButton
    private func handleNextButtonTapped() {
        if onboardingView.currentSlideIndex < onboardingView.pageControl.numberOfPages - 1 {
            onboardingView.currentSlideIndex += 1
            
            let slide = infoSlides[onboardingView.currentSlideIndex]
            onboardingView.updateInfoLabels(slide)
            let indexPath = IndexPath(item: onboardingView.currentSlideIndex, section: 0)
            onboardingView.mainCollectionView.scrollToItem(
                at: indexPath,
                at: .centeredHorizontally,
                animated: true
            )
            onboardingView.pageControl.currentPage = onboardingView.currentSlideIndex
            if onboardingView.currentSlideIndex == 2 {
                onboardingView.skipButton.isHidden = true
                onboardingView.nextButton.isHidden = true
                onboardingView.startButton.isHidden = false
            }
        }
    }
}

// MARK: - UICollectionViewDataSource
extension OnboardingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        infoSlides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ImageCell.reuseID,
                for: indexPath) as? ImageCell
        else {
            return UICollectionViewCell()
        }
        
        let imageName =  infoSlides[indexPath.item].imageName
        
        cell.configure(with: imageName)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension OnboardingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        collectionView.frame.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}
