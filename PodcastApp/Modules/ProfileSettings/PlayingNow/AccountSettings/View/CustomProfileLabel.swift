import UIKit

class CustomProfileLabel: UILabel {
    
    init(title: String) {
        super.init(frame: .zero)
        self.text = title
        self.font = .custome(name: .plusJakartaSans500, size: 14)
        self.textColor = .grayLabelColor
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
