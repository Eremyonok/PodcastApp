
import UIKit

enum SearchSection {
    case topGenres
    case browseAll
}

protocol CustomSearchBarProtocol: AnyObject {
    func changeIsSearched()
}

class SearchViewController: UIViewController {

    private let searchView = SearchView()

    private var searchResult: SearchPodcats?

    private var isSearched = false {
        didSet {
            searchView.setupSearchBar(for: isSearched)
            searchView.showCollectionView(for: isSearched)
        }
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Search"
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
    
    //MARK: - Methods
    
    private func setNavigationAppearance() {
        //set custom arrow for back button
            let backViewImage = UIImage(named: "ArrowLeft")?.withRenderingMode(.alwaysOriginal)
            navigationController?.navigationBar.backIndicatorImage = backViewImage
            navigationController?.navigationBar.backIndicatorTransitionMaskImage = backViewImage
        }
    
    private func setupViews() {
        view = searchView
        searchView.showCollectionView(for: isSearched)
        searchView.transferDelegates(dataSource: self, delegate: self)
        searchView.setupOriginalCompositionalLayout(layout: createInitialCompositionalLayout())
        searchView.transferSearchBarDelegate(delegate: self)
        searchView.transferSBDelegate(delegate: self)
        
    }
}

// MARK: - UICollectionViewDataSource

extension SearchViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        isSearched ? 1 : 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return isSearched
            ? (searchResult?.feeds?.count ?? 0)
            : CategoryList.getAllCategories().count
        default:
            return CategoryList.getAllCategories().count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch isSearched {
        case false:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchViewCell.cellID, for: indexPath) as! SearchViewCell
            cell.configureCell(CategoryList.getAllCategories()[indexPath.item])
            cell.contentView.backgroundColor = UIColor.random
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultViewCell.cellID, for: indexPath) as! SearchResultViewCell
            let podcast = searchResult?.feeds?[indexPath.item]
            cell.configureCell(podcast)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                         withReuseIdentifier: HomeViewSectionHeader.reuseID,
                                                                         for: indexPath) as! HomeViewSectionHeader
        switch indexPath.section {
        case 0:
            headerView.configureHeader(with: "Top Genres", and: false)
        default:
            headerView.configureHeader(with: "Browse All")
        }
        
        return headerView
    }
    
}

// MARK: - UICollectionViewCompositionalLayout

extension SearchViewController {
    
    private func createInitialCompositionalLayout() -> UICollectionViewLayout {
        
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            switch sectionIndex {
            case 0:
               return self?.createFirstSection()
            default:
               return self?.createSecondSection()
            }
        }
    }
    
    private func createFirstSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.48), heightDimension: .absolute(84))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 0, bottom: 12, trailing: 0)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(60))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                        elementKind: UICollectionView.elementKindSectionHeader,
                                                                        alignment: .top)
        
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
    
    private func createSecondSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(84))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 16
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(60))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                        elementKind: UICollectionView.elementKindSectionHeader,
                                                                        alignment: .top)
        
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
    
    private func createSearchResultCompositionalLaypout() -> UICollectionViewLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(84))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 16
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
}

// MARK: - UICollectionViewDelegate

extension SearchViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            if isSearched {
                let podcast = searchResult?.feeds?[indexPath.item]
                let channelVC = ChannelViewController(podcast: podcast)
                navigationController?.pushViewController(channelVC, animated: true)
            } else {
                let category = CategoryList.getAllCategories()[indexPath.item]
                fetchPodcasts(for: category)
            }
        default:
            if !isSearched {
                let category = CategoryList.getAllCategories()[indexPath.item]
                fetchPodcasts(for: category)
            }
        }
    }
}


// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if !isSearched {
            isSearched.toggle()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchResult = nil
        if let searchText = searchBar.text, !searchText.isEmpty {
            fetchSearchResult(for: searchText)
        }
        
        searchBar.resignFirstResponder()
    }
    
}

// MARK: - Networking

extension SearchViewController {
    
    private func fetchSearchResult(for searchText: String) {
        NetworkManager.shared.searchPodcasts(with: searchText) { [weak self] result in
            switch result {
            case .success(let data):
                self?.searchResult = data
                self?.searchView.setupSearchedCompositionalLayout(layout: self?.createSearchResultCompositionalLaypout() ?? UICollectionViewLayout())
                self?.searchView.reloadSearchedCollectionView()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func fetchPodcasts(for category: String) {
        NetworkManager.shared.fetchTrendingPodcast(for: category) { [weak self] result in
            switch result {
            case .success(let data):
                let podcast = data.feeds?.randomElement()
                let channelVC = ChannelViewController(podcast: podcast)
                self?.navigationController?.pushViewController(channelVC, animated: true)
            case .failure(let error):
                print(error)
            }
        }
    }
    
}

// MARK: - CustomSearchBarProtocol

extension SearchViewController: CustomSearchBarProtocol {
    
    func changeIsSearched() {
        isSearched.toggle()
        if !isSearched {
            searchResult = nil
            searchView.resignFirstResponderForSearchBar()
        }
    }

}
