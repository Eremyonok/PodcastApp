//
//  FavoriteViewCell.swift
//  PodcastApp
//
//  Created by Elizaveta Eremyonok on 29.09.2022.
//


import UIKit
import Kingfisher

class FavouriteChannelCell: UITableViewCell {
    
    static var reuseID = String(describing: FavouriteChannelCell.self)
    
    // MARK: - UI Elements
    
    private lazy var background: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var favoriteImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.backgroundColor = UIColor(
            red: 0.93, green: 0.94, blue: 0.99, alpha: 1.00)
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var favChannelTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = .custome(name: .manrope700, size: 14)
        return label
    }()
    
    private lazy var episodesNumberLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 1
        label.textColor = .darkGray
        label.font = .custome(name: .manrope400, size: 12)
        return label
    }()
    
    
    // MARK: - cell initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        favoriteImageView.image = nil
        favChannelTitleLabel.text = nil
        episodesNumberLabel.text = nil
        
    }
    
    //MARK: - Methods
    
    private func setupCell() {
        contentView.addSubview(background)
        background.addSubview(favoriteImageView)
        background.addSubview(favChannelTitleLabel)
        background.addSubview(episodesNumberLabel)
    }
    
    private func setupConstraints() {
        
        background.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview().inset(4)
        }
        
        favoriteImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(8)
            make.width.height.equalTo(48)
        }
        
        favChannelTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(15)
            make.leading.equalTo(favoriteImageView.snp.trailing).offset(19)
            make.trailing.equalToSuperview().inset(16)
        }
        
        episodesNumberLabel.snp.makeConstraints { make in
            make.top.equalTo(favChannelTitleLabel.snp.bottom).offset(5)
            make.leading.equalTo(favoriteImageView.snp.trailing).offset(19)
            make.trailing.equalToSuperview().inset(15)
            make.bottom.equalToSuperview().inset(14)
        }
    }
    
    // MARK: - Configure cell
    
    func configureCell(for podcast: Podcast) {
        favChannelTitleLabel.text = podcast.title
//        episodesNumberLabel.text = "\(chanel.numberOfEpisodes) Eps"
        
        let cache = ImageCache.default
        cache.diskStorage.config.expiration = .seconds(1)
        let processor = RoundCornerImageProcessor(cornerRadius: 12, backgroundColor: .clear)
        favoriteImageView.kf.indicatorType = .activity
        favoriteImageView.kf.setImage(with: URL(string: podcast.image ?? ""), placeholder: nil, options: [.processor(processor),                                           .cacheSerializer(FormatIndicatedCacheSerializer.png)])
    }
}
