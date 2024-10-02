import UIKit

final class CustomLabel: UILabel {
    
    // MARK: - Init
    init(title: String, font: UIFont = UIFont.systemFont(ofSize: 15), color: UIColor = UIColor.grayLabelColor) {
        super.init(frame: .zero)
        
        self.text = title
        self.font = font
        self.textColor = color
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
