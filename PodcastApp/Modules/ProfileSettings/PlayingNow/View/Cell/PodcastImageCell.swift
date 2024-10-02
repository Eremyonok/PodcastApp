import UIKit
import Kingfisher

final class PodcastImageCell: UICollectionViewCell {
    
    // MARK: - Static Properties
    static let reuseId = String(describing: PodcastImageCell.self)
    
    // MARK: - Private UI Properties
    private lazy var mainImageVIew: UIImageView = {
        var mainImageVIew = UIImageView()
        mainImageVIew.layer.cornerRadius = 25
        mainImageVIew.layer.shouldRasterize = true
        mainImageVIew.contentMode = .scaleAspectFill
        mainImageVIew.clipsToBounds = true
        mainImageVIew.kf.indicatorType = .activity
        return mainImageVIew
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(mainImageVIew)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func configureView(with imageURL: String) {
        guard let url = URL(string: imageURL) else { return }
        mainImageVIew.kf.setImage(
            with: url,
            placeholder: nil,
            options: [
                .transition(.fade(1.0)),
                .cacheOriginalImage
            ]
        )
    }
    
    // MARK: - Private Methods
    private func setupConstraints() {
        mainImageVIew.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
