import UIKit
class CustomSearchBar: UISearchBar {
    
    var isSearched = false {
        didSet {
            setupCustomSearchBar(for: isSearched)
            layoutIfNeeded()
        }
    }
    
    private var delegateSB: CustomSearchBarProtocol?
    
    // MARK: - layoutSubviews
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupCustomSearchBar(for: isSearched)
    }
    
    // MARK: - Private methods
    
    private func setupCustomSearchBar(for isUseSearchBar: Bool) {
        if isUseSearchBar {
            searchedStyle(for: self.searchTextField, with: .gray, and: .none)
            addRightButton(for: self.searchTextField, for: isUseSearchBar)
        } else {
            searchedStyle(for: self.searchTextField, with: .white, and: .roundedRect)
            addRightButton(for: self.searchTextField, for: isUseSearchBar)
        }
    }
    
    private func searchedStyle(for textField: UITextField, with color: UIColor, and borderStyle:  UITextField.BorderStyle) {
        layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        layer.borderWidth = 2
        
        let border = CALayer()
        let borderWidth: CGFloat = 1.0
        border.frame = CGRect(x: 0,
                              y: textField.frame.size.height - borderWidth,
                              width: textField.frame.width,
                              height: borderWidth)
        border.borderWidth = borderWidth
        border.borderColor = color.cgColor
        textField.layer.addSublayer(border)
        
        textField.borderStyle = borderStyle
        textField.layer.masksToBounds = true
        
        deleteLeftButton(for: textField)
        
    }
    
    private func deleteLeftButton(for textField: UITextField) {
        textField.leftView = nil
    }
    
    private func addRightButton(for textField: UITextField, for isSearched: Bool) {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: isSearched ? "clearBarButton" : "searchBarButton"), for: .normal)
        button.sizeToFit()
        button.addTarget(self, action: #selector(clearSearchBrTapped), for: .touchUpInside)
        textField.rightView = button
        textField.rightViewMode = .always
    }
    
    @objc func clearSearchBrTapped() {
        if isSearched {
            searchTextField.text = nil
            delegateSB?.changeIsSearched()
        }
    }
    
    // MARK: - Public methods
    
    func setupDelegate(delegate: CustomSearchBarProtocol) {
        delegateSB = delegate
    }
}
