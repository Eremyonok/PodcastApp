import UIKit
import SnapKit
import Kingfisher

class ChannelViewController: UIViewController {
    
    private let imageChanel: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = UIColor(red: 0.68, green: 0.89, blue: 0.95, alpha: 1)
        image.layer.cornerRadius = 84/4
        image.clipsToBounds = true
        return image
    }()
    
    private let nameChannelLabel: UILabel = {
        let label = UILabel()
        label.text = "Baby Pesut Podcast"
        label.font = .custome(name: .manrope700, size: 16)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private let numberEpizodesLabel: UILabel = {
        let label = UILabel()
        label.text = "56 Eps | Dr. Oi om jean"
        label.font = .custome(name: .manrope400, size: 16)
        label.textColor = .lightGray
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let headerTableView: UILabel = {
        let label = UILabel()
        label.text = "All Episode"
        label.font = .custome(name: .manrope700, size: 16)
        label.textColor = .black
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let element = UITableView()
        element.register(ChannelViewCell.self, forCellReuseIdentifier: ChannelViewCell.reuseID)
        element.separatorStyle = .none
        element.rowHeight = UITableView.automaticDimension
        element.estimatedRowHeight = 88
        element.delegate = self
        element.dataSource = self
        return element
    }()
    
    private var podcast: Podcast?
    private var searchEpisods: SearchEpisods?
    
    //MARK: - Life cycle
    
    init(podcast: Podcast?) {
        self.podcast = podcast
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        title = "Channel"
        setupViews()
        makeConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        setLables()
        loadImage()
        fetchEpisodsForPodcast()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //hide back button text
        navigationController?.navigationBar.backItem?.title = ""
        navigationItem.backButtonTitle = ""
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    //MARK: - Methods
    
    fileprivate func setLables() {
        nameChannelLabel.text = podcast?.title
        numberEpizodesLabel.text = podcast?.author
    }
    
    private func setupViews(){
        view.addSubview(imageChanel)
        view.addSubview(nameChannelLabel)
        view.addSubview(numberEpizodesLabel)
        view.addSubview(headerTableView)
        view.addSubview(tableView)
    }
    
    private func makeConstraints(){
        
        imageChanel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(113)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(84)
        }
        
        nameChannelLabel.snp.makeConstraints { make in
            make.top.equalTo(imageChanel.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        numberEpizodesLabel.snp.makeConstraints { make in
            make.top.equalTo(nameChannelLabel.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        headerTableView.snp.makeConstraints { make in
            make.top.equalTo(numberEpizodesLabel.snp.bottom).offset(34)
            make.left.equalToSuperview().offset(32)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(headerTableView.snp.bottom).offset(13)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
    }
    
}

// MARK: - UITableViewDataSource

extension ChannelViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchEpisods?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChannelViewCell.reuseID, for: indexPath) as? ChannelViewCell else { return UITableViewCell() }
        let episode = searchEpisods?.items?[indexPath.row]
        cell.configureCell(for: episode)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ChannelViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let playVC = PlayingNowViewController(podcastEpisode: searchEpisods?.items, author: podcast?.author, index: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(playVC, animated: true)
    }
}

// MARK: - Networking

extension ChannelViewController {
    
    private func loadImage() {
        guard let imageURL = podcast?.image else { return }
        let cache = ImageCache.default
        cache.diskStorage.config.expiration = .seconds(1)
        let processor = RoundCornerImageProcessor(cornerRadius: 12, backgroundColor: .clear)
        imageChanel.kf.indicatorType = .activity
        imageChanel.kf.setImage(with: URL(string: imageURL), placeholder: nil, options: [.processor(processor),                                           .cacheSerializer(FormatIndicatedCacheSerializer.png)])
    }
    
    private func fetchEpisodsForPodcast() {
        NetworkManager.shared.fetchEpisodesForPodcast(with: podcast?.id) { [weak self] result in
            switch result {
            case .success(let data):
                self?.searchEpisods = data
                self?.numberEpizodesLabel.text = "\(self?.searchEpisods?.count ?? 0) Eps | \(self?.podcast?.author ?? "")"
                self?.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
