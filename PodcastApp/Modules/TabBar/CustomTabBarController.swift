import UIKit

class CustomTabBarController: UITabBarController {

//MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setControllers()
        setAppearance()
    }
    
   //MARK: Methods
    private func setControllers() {
        let homeVC = UINavigationController(rootViewController: HomeViewController() )
        let homeSelectedImage = UIImage(named: "HomeActive")?.withRenderingMode(.alwaysOriginal)
        let homeItem = UITabBarItem(title: nil, image: UIImage(named: "Home"), selectedImage: homeSelectedImage)
        homeItem.imageInsets = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: -30)
        homeVC.tabBarItem = homeItem
        
        let searchVC = UINavigationController(rootViewController: SearchViewController() )
        let searchSelectedImage =  UIImage(named: "SearchActive")?.withRenderingMode(.alwaysOriginal)
        let searchItem = UITabBarItem(title: nil, image: UIImage(named: "Search"), selectedImage: searchSelectedImage)
        searchItem.imageInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: -10)
        searchVC.tabBarItem = searchItem
        
        let favoritesVC = UINavigationController(rootViewController: FavoritesViewController() )
        let favoritesSelectedImage = UIImage(named: "BookmarkActive")?.withRenderingMode(.alwaysOriginal)
        let favoritesItem = UITabBarItem(title: nil, image: UIImage(named: "Bookmark"), selectedImage: favoritesSelectedImage)
        favoritesItem.imageInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 10)
        favoritesVC.tabBarItem = favoritesItem
        
        let settingsVC = UINavigationController(rootViewController: ProfileSettingsViewController() )
        let settingsSelectedImage = UIImage(named: "SettingActive")?.withRenderingMode(.alwaysOriginal)
        let settingsItem = UITabBarItem(title: nil, image: UIImage(named: "Setting"), selectedImage: settingsSelectedImage)
        settingsItem.imageInsets = UIEdgeInsets(top: 0, left: -30, bottom: 0, right: 30)
        settingsVC.tabBarItem = settingsItem
        
        viewControllers = [homeVC,
                           searchVC,
                           favoritesVC,
                           settingsVC]
    }
    
    private func setAppearance() {
        view.backgroundColor = .systemBackground
        view.tintColor = .clear
        let cornerRadius: CGFloat = 20
        let positionOnX: CGFloat = 24
        let positionOnY: CGFloat = 12
        let width = tabBar.bounds.width - positionOnX * 2
        let height: CGFloat = tabBar.bounds.height + positionOnY * 2
        let shapeLayer = CAShapeLayer()
        let path = UIBezierPath(
            roundedRect: CGRect(x: positionOnX, y: tabBar.bounds.minY - positionOnY * 1.5 , width: width, height: height),
                                cornerRadius: cornerRadius)
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.systemBackground.cgColor
        //add shadow
        shapeLayer.shadowColor = UIColor.black.cgColor
        shapeLayer.shadowRadius = cornerRadius
        shapeLayer.shadowOpacity = 0.15
        shapeLayer.shadowOffset = CGSize(width: positionOnY, height: positionOnY)
        shapeLayer.shadowPath = path.cgPath
        //add custom layer
        tabBar.layer.insertSublayer(shapeLayer, at: 0)
        tabBar.itemPositioning = .fill
        
    }

}

extension CustomTabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        navigationController?.navigationItem.title = nil
        tabBarController.selectedViewController?.title = nil
        tabBarController.selectedViewController?.navigationItem.title = nil
        
        if let tabBarItems = tabBarController.tabBar.items {
            tabBarItems.forEach { $0.title = nil }
        }
    }
    
}
