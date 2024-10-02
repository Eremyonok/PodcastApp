import UIKit

final class ImageCell: UICollectionViewCell {
    
    // MARK: - Publc UI Properties
    static let reuseID = String(describing: ImageCell.self)
    
    // MARK: - Private UI Properties
    private var imageView = UIImageView() {
        didSet {
            imageView.layer.cornerRadius = imageView.frame.height / 2
        }
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    public func configure(with imageName: String) {
        imageView.image = UIImage(named: imageName)
    }
    
    // MARK: - Private Methods
    private func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
}
