import UIKit

final class AuthLabel: UILabel {
    
    enum FontSize {
        case small
        case medium
    }
    
    // MARK: - Init
    init(title: String, activeString: String, font: FontSize) {
        super.init(frame: .zero)
        
        textColor = UIColor.grayLabelColor
        self.font = (font == .small)
        ? UIFont.systemFont(ofSize: 13)
        : UIFont.custome(name: .plusJakartaSans600, size: 14)
        
        let attributedText = NSMutableAttributedString(string: title)
        let range = (title as NSString).range(of: activeString)
        attributedText.addAttribute(
            .foregroundColor,
            value: (font == .small) ? UIColor.customGreen : UIColor.customPurple,
            range: range
        )
        
        self.attributedText = attributedText
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
