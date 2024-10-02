import UIKit

class PopularCategoryCell: UICollectionViewCell {
    
    static let cellID = String(describing: PopularCategoryCell.self)
    
    //MARK: - UI Elements
    
    let headerLabel: PaddledLabel = {
        let label = PaddledLabel()
        label.textColor = .black
        label.text = "Category"
        label.font = .custome(name: .manrope400, size: 16)
        label.textAlignment = .center
        label.minimumScaleFactor = 0.1
        label.adjustsFontSizeToFitWidth = true
        label.paddingLeft = 8
        label.paddingRight = 8
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            super.isSelected = isSelected
            
            switch isSelected {
            case true:
                headerLabel.font = .custome(name: .manrope700, size: 16)
                contentView.layer.shadowColor = UIColor.gray.cgColor
                contentView.layer.shadowRadius = 4
                contentView.layer.shadowOpacity = 0.3
                contentView.layer.shadowOffset = CGSize(width: 1, height: 1)
            case false:
                headerLabel.font = .custome(name: .manrope400, size: 16)
                contentView.layer.shadowColor = UIColor.clear.cgColor
            }
        }
    }
    
    //MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setHierarchy()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        headerLabel.text = nil
    }
    
    // MARK: - Setup UI
    
    private func setHierarchy() {
        contentView.addSubview(headerLabel)
        contentView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        contentView.layer.cornerRadius = 10
    }
    
    private func setConstraints() {
        headerLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(6)
        }
    }
    
    // MARK: - Configure
    
    func configureCell(_ title: String) {
        headerLabel.text = title
    }
    
    func selectCell() {
//        headerLabel.font = .custome(name: .manrope700, size: 16)
//        contentView.layer.shadowColor = UIColor.gray.cgColor
//        contentView.layer.shadowRadius = 4
//        contentView.layer.shadowOpacity = 0.3
//        contentView.layer.shadowOffset = CGSize(width: 1, height: 1)
    }
    
    func deselectCell() {
//        headerLabel.font = .custome(name: .manrope400, size: 16)
//        contentView.layer.shadowColor = UIColor.clear.cgColor
    }
}
