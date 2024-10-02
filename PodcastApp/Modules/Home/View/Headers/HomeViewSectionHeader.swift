import UIKit

class HomeViewSectionHeader: UICollectionReusableView {
    
    static let reuseID = String(describing: HomeViewSectionHeader.self)
    
    // MARK: - UI Elements
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Category"
        label.textAlignment = .left
        label.font = .custome(name: .manrope700, size: 16)
        return label
    }()
    
    private lazy var seeAllButton: UIButton = {
        let button = UIButton(type: .system)
        var config = UIButton.Configuration.plain()
        config.title = "See all"
        config.baseForegroundColor = .gray
        button.configuration = config
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setHierarchy()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    
    private func setHierarchy() {
        backgroundColor = .clear
        addSubview(titleLabel)
        addSubview(seeAllButton)
    }
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
        }
        
        seeAllButton.snp.makeConstraints { make in
            make.trailing.top.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Public methods
    
    func configureHeader(with title: String, and isButtonHidden: Bool = true) {
        titleLabel.text = title
        seeAllButton.isHidden = isButtonHidden
    }
    
}

