import UIKit
import SnapKit

class FavoritesViewController: UIViewController {
    
    // MARK: - User Interface
    private lazy var favouriteTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 48
        return tableView
    }()
    
    // MARK: - private properties
    private var favouriteChanels = ChannelModel.makeMockData()
    
    private var podcastData: [Podcast] = []
    
    // MARK: - Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.setupConstraints()
        self.setupTableView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Favorites"
        fetchData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setNavigationAppearance()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //hide label in tabBar
        title = nil
    }
    
    // MARK: - Private methodes
    
    private func setNavigationAppearance() {
    //set custom arrow for back button
        let backViewImage = UIImage(named: "ArrowLeft")?.withRenderingMode(.alwaysOriginal)
        navigationController?.navigationBar.backIndicatorImage = backViewImage
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = backViewImage
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        view.addSubview(favouriteTableView)
    }
    
    private func setupTableView() {
        favouriteTableView.dataSource = self
        favouriteTableView.delegate = self
        favouriteTableView.register(FavouriteChannelCell.self,
                                           forCellReuseIdentifier: FavouriteChannelCell.reuseID)
    }
    
    private func setupConstraints() {
        favouriteTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}


// MARK: - table protocols
extension FavoritesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        podcastData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: FavouriteChannelCell.reuseID,
            for: indexPath) as? FavouriteChannelCell else { return  .init()}
        
        let podcast = podcastData[indexPath.row]
        cell.configureCell(for: podcast)
        return cell
    }
}

extension FavoritesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let podcast = podcastData[indexPath.row]
        let channelVC = ChannelViewController(podcast: podcast)
        navigationController?.pushViewController(channelVC, animated: true)
    }
}

// MARK: - Realm

extension FavoritesViewController {
    
    private func fetchData() {
        podcastData = []
        StorageManager.shared.read { [weak self] result in
            result.forEach { podcastModel in
                let podcast = Podcast(name: nil,
                                      id: podcastModel.id,
                                      title: podcastModel.title,
                                      description: nil,
                                      author: podcastModel.author,
                                      image: podcastModel.imageURL,
                                      artwork: podcastModel.imageURL,
                                      url: nil,
                                      itunesId: nil,
                                      trendScore: nil,
                                      language: nil,
                                      categories: nil)
                
                self?.podcastData.append(podcast)
            }
            self?.favouriteTableView.reloadData()
        }
    }
}

