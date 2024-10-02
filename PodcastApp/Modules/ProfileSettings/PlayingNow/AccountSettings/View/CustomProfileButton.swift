import UIKit

class CustomProfileButton: UIButton {
    
    init(title: String, imageName: String) {
        super.init(frame: .zero)
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: imageName)
        configuration.imagePlacement = .leading
        configuration.imagePadding = 5
        configuration.title = title
        configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 15)
        self.configuration = configuration
        self.tintColor = .customBlue
        self.clipsToBounds = true
        self.backgroundColor = .systemBackground
        self.layer.borderColor =  UIColor.customBlue.cgColor
        self.layer.borderWidth = 1
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
