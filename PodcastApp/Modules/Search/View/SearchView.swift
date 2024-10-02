
import UIKit

class SearchView: UIView {
    
    // MARK: - UI Elements
    
    private lazy var searchBar: CustomSearchBar = {
        let searchBar = CustomSearchBar()
        searchBar.placeholder = "Podcast, channel or artists"
        searchBar.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        return searchBar
    }()
    
    private lazy var originalCollectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        collection.backgroundColor = .clear
        collection.showsVerticalScrollIndicator = false
        return collection
    }()
    
    private lazy var searchedCollectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        collection.backgroundColor = .clear
        collection.showsVerticalScrollIndicator = false
        return collection
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
    
    // MARK: - Setup UI
    private func setHierarchy() {
        backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        addSubview(searchBar)
        
        addSubview(originalCollectionView)
        addSubview(searchedCollectionView)
        
        originalCollectionView.register(HomeViewSectionHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: HomeViewSectionHeader.reuseID)
        
        originalCollectionView.register(SearchViewCell.self,
                                forCellWithReuseIdentifier: SearchViewCell.cellID)
        
        searchedCollectionView.register(SearchResultViewCell.self,
                                forCellWithReuseIdentifier: SearchResultViewCell.cellID)
    }
    
    private func setConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(superview?.safeAreaLayoutGuide.snp.top ?? self.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(superview?.safeAreaLayoutGuide.snp.leading ?? self.safeAreaLayoutGuide.snp.leading).offset(20)
            make.trailing.equalTo(superview?.safeAreaLayoutGuide.snp.trailing ?? self.safeAreaLayoutGuide.snp.trailing).offset(-20)
        }
        
        originalCollectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
        }
        
        searchedCollectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
        }
    }

}

// MARK: - Public Methods

extension SearchView {
    
    // Collections View
    
    public func showCollectionView(for isSearched: Bool) {
        switch isSearched {
        case true:
            originalCollectionView.isHidden = true
            searchedCollectionView.isHidden = false
            searchedCollectionView.reloadData()
        case false:
            originalCollectionView.isHidden = false
            searchedCollectionView.isHidden = true
            originalCollectionView.reloadData()
        }
    }
    
    public func setupOriginalCompositionalLayout(layout: UICollectionViewLayout) {
        originalCollectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    public func setupSearchedCompositionalLayout(layout: UICollectionViewLayout) {
        searchedCollectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    public func transferDelegates(dataSource: UICollectionViewDataSource, delegate: UICollectionViewDelegate) {
        originalCollectionView.dataSource = dataSource
        originalCollectionView.delegate = delegate
        searchedCollectionView.dataSource = dataSource
        searchedCollectionView.delegate = delegate
    }
    
    public func reloadOriginalCollectionView() {
        originalCollectionView.reloadData()
    }
    
    public func reloadSearchedCollectionView() {
        searchedCollectionView.reloadData()
    }
    
    // Search Bar
    
    public func transferSearchBarDelegate(delegate: UISearchBarDelegate) {
        searchBar.delegate = delegate
    }
    
    public func setupSearchBar(for isSearched: Bool) {
        searchBar.isSearched = isSearched
    }
    
    public func transferSBDelegate(delegate: CustomSearchBarProtocol) {
        searchBar.setupDelegate(delegate: delegate)
    }
    
    public func resignFirstResponderForSearchBar() {
        searchBar.resignFirstResponder()
    }
}
