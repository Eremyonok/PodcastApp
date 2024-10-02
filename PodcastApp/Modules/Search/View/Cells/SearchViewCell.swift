import UIKit

class SearchViewCell: UICollectionViewCell {
    
    static let cellID = String(describing: SearchViewCell.self)
    
    private lazy var title: UILabel = {
        let label = UILabel()
        label.text = "test"
        label.font = .custome(name: .manrope700, size: 14)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    // MARK: - Initial
    
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
        title.text = nil
    }
    
    // MARK: - Setup UI
    
    private func setHierarchy() {
        contentView.layer.cornerRadius = 12
        contentView.backgroundColor = #colorLiteral(red: 0.7360796332, green: 0.8482380509, blue: 0.9852609038, alpha: 1)
        
        contentView.addSubview(title)
    }
    
    private func setConstraints() {
        title.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    // MARK: - Configure Cell
    
    func configureCell(_ podcast: Podcast?) {
        title.text = podcast?.name
    }
    
    func configureCell(_ title: String) {
        self.title.text = title
    }
    
}
