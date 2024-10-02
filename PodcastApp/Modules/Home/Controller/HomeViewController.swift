import UIKit
import SnapKit

class HomeViewController: UIViewController {
    
    private let homeView = HomeView()
    
    private var podcastsFirstData: [SearchedResult]?
    private var podcastsSecondData: SearchedResult?
    
    private var selectedIndexPath = IndexPath(item: 0, section: 1)
    
    // MARK: - Initial
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = homeView
        homeView.transferDelegates(dataSource: self, delegate: self)
        homeView.setupCompositionalLayout(layout: createInitialCompositionalLayout())
        
        fetchFirstPodcastsData(for: CategoryList.getFirstCategoryList())
        fetchSecondPodcastsData()
        //navigationItem.backButtonTitle = ""
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setNavigationAppearance()
        getUser()
    }
    
    //MARK: - Methods
    
    private func setNavigationAppearance() {
    //set custom arrow for back button
        let backViewImage = UIImage(named: "ArrowLeft")?.withRenderingMode(.alwaysOriginal)
        navigationController?.navigationBar.backIndicatorImage = backViewImage
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = backViewImage
    }
    
    private func getUser() {
        let user = StorageManager.shared.getCurrentUser()
        homeView.setupUser(for: user)
    }
}

// MARK: - UICollectionViewDataSource

extension HomeViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
           return CategoryList.getFirstCategoryList().count
        case 1:
            return CategoryList.getSecondCategoryList().count
        default:
            return podcastsSecondData?.feeds?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryHomeViewCell.cellID, for: indexPath) as! CategoryHomeViewCell
            let title = CategoryList.getFirstCategoryList()[indexPath.item]
            let category = podcastsFirstData?[indexPath.item]
            cell.configureCell(with: title, for: category)
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PopularCategoryCell.cellID, for: indexPath) as! PopularCategoryCell
            let categories = CategoryList.getSecondCategoryList()
            cell.configureCell(categories[indexPath.item])
            cell.isSelected = indexPath == selectedIndexPath
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PodcastHomeViewCell.cellID, for: indexPath) as! PodcastHomeViewCell
            let podcast = podcastsSecondData?.feeds?[indexPath.item]
            cell.configureCell(podcast)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: HomeViewSectionHeader.reuseID,
                                                                             for: indexPath) as! HomeViewSectionHeader
            return headerView
    }
    
    
}

// MARK: - UICollectionViewCompositionalLayout

extension HomeViewController {
    
    private func createInitialCompositionalLayout() -> UICollectionViewLayout {
        
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            switch sectionIndex {
            case 0:
               return self?.createFirstSection()
            case 1:
               return self?.createSecondSection()
            default:
              return self?.createThirdSection()
            }
        }
    }
    
    private func createFirstSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 16)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.48), heightDimension: .absolute(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 0, bottom: 12, trailing: 0)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(60))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                        elementKind: UICollectionView.elementKindSectionHeader,
                                                                        alignment: .top)
        
        section.boundarySupplementaryItems = [sectionHeader]
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        
        return section
    }
    
    private func createSecondSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(20), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(20), heightDimension: .absolute(36))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: .none, top: .none, trailing: .fixed(10), bottom: .none)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 24, leading: 20, bottom: 24, trailing: 20)
                
        return section
    }
    
    private func createThirdSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(84))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(96))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        group.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: .none, top: .none, trailing: .none, bottom: .fixed(8))
    
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        
        return section
    }
}

// MARK: - UICollectionViewDelegate

extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0:
            let podcast = podcastsFirstData?.first?.feeds?[indexPath.item]
            let channelVC = ChannelViewController(podcast: podcast)
            navigationController?.pushViewController(channelVC, animated: true)
        case 1:
            if let _ = collectionView.cellForItem(at: indexPath) as? PopularCategoryCell {
                selectedIndexPath = indexPath
                
                if indexPath.item == 0 {
                    fetchSecondPodcastsData()
                } else {
                    let category = CategoryList.getSecondCategoryList()[indexPath.item]
                    fetchSecondPodcastsData(for: category)
                }
            }
        default:
            let podcast = podcastsSecondData?.feeds?[indexPath.item]
            let channelVC = ChannelViewController(podcast: podcast)
            navigationController?.pushViewController(channelVC, animated: true)
        }
    }
    
}

// MARK: - Networking

extension HomeViewController {
    
    private func fetchFirstPodcastsData(for categories: [String]) {
        NetworkManager.shared.fetchGroupTrendingPodcast(for: categories) { result in
            switch result {
            case .success(let data):
                self.podcastsFirstData = data
                self.homeView.reloadSection(for: 0)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func fetchSecondPodcastsData(for category: String? = nil) {
        NetworkManager.shared.fetchTrendingPodcast(for: category) { [weak self] result in
            switch result {
            case .success(let data):
                self?.podcastsSecondData = data
                self?.homeView.reloadSection(for: 2)
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
