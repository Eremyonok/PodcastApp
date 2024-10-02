import UIKit

final class CustomButton: UIButton {
    
    // MARK: - Enum
    enum CustomButtonType {
        case blueButton
        case googleButton
        case smallButton
    }
    
    // MARK: - Init
    init(title: String, font: UIFont = UIFont.boldSystemFont(ofSize: 18), buttonType: CustomButtonType, color: UIColor = .white) {
        super.init(frame: .zero)
        
        switch buttonType {
            
        case .blueButton:
            self.backgroundColor = UIColor.customBlue
            self.layer.cornerRadius = 25
            self.titleLabel?.font = UIFont.custome(name: .plusJakartaSans600, size: 17)
            self.setTitle(title, for: .normal)
            
        case .googleButton:
            self.layer.borderColor = UIColor.black.cgColor
            self.layer.borderWidth = 1
            self.layer.cornerRadius = 24
            
            let imageView = UIImageView()
            imageView.image = UIImage(named: "google")
            imageView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            imageView.contentMode = .scaleAspectFit
            
            let label = UILabel()
            label.text = title
            label.textColor = .black
            label.font = UIFont.custome(name: .plusJakartaSans600, size: 16)
            label.textAlignment = .center
            
            self.addSubview(imageView)
            self.addSubview(label)
            
            imageView.snp.makeConstraints { make in
                make.right.equalTo(label.snp.left).offset(-10)
                make.centerY.equalTo(self.snp.centerY)
                make.width.equalTo(30)
                make.height.equalTo(30)
            }
            
            label.snp.makeConstraints { make in
                make.leading.equalTo(imageView.snp.trailing).offset(10)
                make.trailing.equalTo(self.snp.trailing).offset(-60)
                make.centerY.equalTo(self.snp.centerY)
            }
            
        case .smallButton:
            self.titleLabel?.font = font
            self.setTitle(title, for: .normal)
            self.setTitleColor(color, for: .normal)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
