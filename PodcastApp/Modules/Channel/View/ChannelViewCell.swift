import UIKit
import Kingfisher

class ChannelViewCell: UITableViewCell {
    
    static var reuseID = String(describing: ChannelViewCell.self)
    
    // MARK: - UI Elements
    
    private lazy var background: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.9434495568, green: 0.9541783929, blue: 0.9908102155, alpha: 1)
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var imageEpizode: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = #colorLiteral(red: 0.6847735047, green: 0.8535647988, blue: 0.9940004945, alpha: 1)
        image.layer.cornerRadius = 56/4
        image.clipsToBounds = true
        return image
    }()
    
    private lazy var nameEpizode: UILabel = {
        let label = UILabel()
        label.font = .custome(name: .manrope700, size: 14)
        label.numberOfLines = 0
        label.textColor = .black
        return label
    }()
    
    private lazy var epizodeSubtitle: UILabel = {
        let label = UILabel()
        label.font = .custome(name: .manrope400, size: 14)
        label.textColor = .gray
        label.textAlignment = .left
        return label
    }()
    
 // MARK: - Initial
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style , reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameEpizode.text = nil
        epizodeSubtitle.text = nil
    }
    
    // MARK: - Setup UI
    
    private func setupCell(){
        
        contentView.addSubview(background)
        
        background.addSubview(imageEpizode)
        background.addSubview(nameEpizode)
        background.addSubview(epizodeSubtitle)

        background.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(8)
        }
        
        imageEpizode.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(8)
            make.width.height.equalTo(56)
        }
        
        nameEpizode.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(15)
            make.leading.equalTo(imageEpizode.snp.trailing).offset(19)
            make.trailing.equalToSuperview().inset(16)
        }
        
        epizodeSubtitle.snp.makeConstraints { make in
            make.top.equalTo(nameEpizode.snp.bottom).offset(5)
            make.leading.equalTo(imageEpizode.snp.trailing).offset(19)
            make.trailing.equalToSuperview().inset(15)
            make.bottom.equalToSuperview().inset(14)
        }
        
    }
    
    // MARK: - Configure cell
    
    func configureCell(for episode: PodcastEpisode?) {
        nameEpizode.text = episode?.title
        epizodeSubtitle.text = "\(episode?.formattedTime ?? "00:00:00")  •  \(episode?.episode ?? 0) Eps"
        
        guard let imageURL = episode?.image else { return }
        let cache = ImageCache.default
        cache.diskStorage.config.expiration = .seconds(1)
        let processor = RoundCornerImageProcessor(cornerRadius: 12, backgroundColor: .clear)
        imageEpizode.kf.indicatorType = .activity
        imageEpizode.kf.setImage(with: URL(string: imageURL),
                                 placeholder: nil,
                                 options: [.processor(processor),
                                           .cacheSerializer(FormatIndicatedCacheSerializer.png)])
    }
}
