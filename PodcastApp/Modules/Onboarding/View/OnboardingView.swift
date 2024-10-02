import UIKit

final class OnboardingView: UIView {
    
    // MARK: - Closures
    // замыкание для перехода нa tab bar по нажатию на Start или Skip
    var buttonAction: (() -> Void)?
    // замыкание для обновления UI при нажании на кнопку nextButton
    var nextButtonAction: (() -> Void)?
    
    // MARK: - Public Properties
    var currentSlideIndex = 0
 
    // MARK: - Public UI Properties
    lazy var skipButton: UIButton = {
        var skipButton = UIButton(type: .system)
        skipButton.setTitle("Skip", for: .normal)
        skipButton.titleLabel?.font = UIFont.custome(name: .manrope700, size: 16)
        skipButton.setTitleColor(.black, for: .normal)
        skipButton.addTarget(
            self,
            action: #selector(buttonTapped),
            for: .touchUpInside
        )
        return skipButton
    }()
    
    lazy var startButton: UIButton = {
        var startButton = UIButton(type: .system)
        startButton.setTitle("Get Started", for: .normal)
        startButton.setTitleColor(.white, for: .normal)
        startButton.titleLabel?.font = UIFont.custome(name: .manrope700, size: 16)
        startButton.backgroundColor = #colorLiteral(red: 0.1589552164, green: 0.5085405111, blue: 0.9443863034, alpha: 1)
        startButton.layer.cornerRadius = 16
        startButton.isHidden = true
        startButton.addTarget(
            self,
            action: #selector(buttonTapped),
            for: .touchUpInside
        )
        return startButton
    }()
    
    lazy var mainCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let myCV = UICollectionView(frame: .zero, collectionViewLayout: layout)
        myCV.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.reuseID)
        myCV.isPagingEnabled = true
        myCV.showsHorizontalScrollIndicator = false
        myCV.isScrollEnabled = false
        
        return myCV
    }()
    
    lazy var pageControl: UIPageControl = {
        var pageControll = UIPageControl()
        pageControll.numberOfPages = 3
        pageControll.currentPageIndicatorTintColor = .black
        pageControll.isEnabled = false
        return pageControll
    }()
    
    lazy var nextButton: UIButton = {
        var nextButton = UIButton(type: .system)
        nextButton.setTitle("Next", for: .normal)
        nextButton.setTitleColor(.black, for: .normal)
        nextButton.backgroundColor = #colorLiteral(red: 0.9257928729, green: 0.9576769471, blue: 0.9981418252, alpha: 1)
        nextButton.layer.cornerRadius = 20
        nextButton.titleLabel?.font = UIFont.custome(name: .manrope700, size: 16)
        nextButton.addTarget(
            self,
            action: #selector(nextButtonDidTapped),
            for: .touchUpInside
        )
        return nextButton
    }()
    
    // MARK: - Private UI Properties
    private lazy var infoView: UIView = {
        var secondView = UIView()
        secondView.backgroundColor = #colorLiteral(red: 0.6869879365, green: 0.8190694451, blue: 0.9799563289, alpha: 1)
        secondView.layer.cornerRadius = 30
        return secondView
    }()
    
    private lazy var infoTitle: UILabel = {
        var infoTitle = UILabel()
        infoTitle.numberOfLines = 0
        infoTitle.backgroundColor = .clear
        infoTitle.textAlignment = .center
        infoTitle.font = UIFont.custome(name: .manrope700, size: 23)
        return infoTitle
    }()
    
    private lazy var infoSubtitle: UILabel = {
        var infoSubtitle = UILabel()
        infoSubtitle.adjustsFontSizeToFitWidth = true
        infoSubtitle.minimumScaleFactor = 0.5
        infoSubtitle.backgroundColor = .clear
        infoSubtitle.numberOfLines = 0
        infoSubtitle.textAlignment = .center
        infoSubtitle.font = UIFont.custome(name: .manrope700, size: 20)
        infoSubtitle.textColor = .white
        return infoSubtitle
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemBackground
        addViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    public func transferDelegates(dataSource: UICollectionViewDataSource, delegate: UICollectionViewDelegate) {
        mainCollectionView.dataSource = dataSource
        mainCollectionView.delegate = delegate
    }
    
    public func updatePageControl(_ value: Int) {
        pageControl.currentPage = value
    }
    
    public func updateInfoLabels(_ slide: Slide) {
        infoTitle.text = slide.title
        infoSubtitle.text = slide.secontTitle
    }
    
    public func setupPageControl(_ values: Int) {
        pageControl.numberOfPages = values
    }
    
    // MARK: - Private Actions
    @objc private func buttonTapped() {
        buttonAction?()
    }
    
    @objc private func nextButtonDidTapped() {
        nextButtonAction?()
    }
}

// MARK: - Setup UI
extension OnboardingView {
    private func addViews() {
        self.addSubview(mainCollectionView)
        self.addSubview(infoView)
        infoView.addSubview(pageControl)
        infoView.addSubview(nextButton)
        infoView.addSubview(skipButton)
        infoView.addSubview(startButton)
        infoView.addSubview(infoTitle)
        infoView.addSubview(infoSubtitle)
    }
    
    private func setupConstraints() {
        mainCollectionView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(20)
            make.left.equalToSuperview().offset(28)
            make.right.equalToSuperview().offset(-28)
            make.bottom.equalTo(infoView.snp.top).offset(-20)
        }
        
        infoView.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-30)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.height.equalTo(330)
        }
        
        pageControl.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-20)
            make.centerX.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints { make in
            make.bottom.equalTo(pageControl.snp.top).offset(-20)
            make.right.equalToSuperview().offset(-30)
            make.width.equalTo(85)
            make.height.equalTo(58)
        }
        
        skipButton.snp.makeConstraints { make in
            make.bottom.equalTo(pageControl.snp.top).offset(-20)
            make.centerY.equalTo(nextButton.snp.centerY)
            make.left.equalToSuperview().offset(30)
        }
        
        startButton.snp.makeConstraints { make in
            make.bottom.equalTo(pageControl.snp.top).offset(-20)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.height.equalTo(58)
        }
        
        infoTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalTo(infoSubtitle.snp.top).offset(-5)
        }
        
        infoSubtitle.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalTo(nextButton.snp.top).offset(-5)
        }
    }
}
