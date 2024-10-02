import UIKit

class ProfileCustomButton:UIButton {
    
    // MARK: - Properties
    private let bacgrounForSimvols: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.93, green: 0.94, blue: 0.99, alpha: 1)
        view.layer.cornerRadius = 12
        return view
    }()
    
    private let simvolImage: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .clear
        image.tintColor = UIColor(red: 0.07, green: 0.07, blue: 0.07, alpha: 0.5)
        return image
    }()
    
    private let nameButtonLabel: UILabel = {
        let label = UILabel()
        label.font = .custome(name: .manrope700, size: 14)
        label.textColor = UIColor(red: 0.26, green: 0.25, blue: 0.32, alpha: 1)
        return label
    }()
    
    private let arrowImage: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .clear
        image.image = UIImage(systemName: "chevron.right")
        image.contentMode = .scaleAspectFit
        image.tintColor = UIColor(red: 0.53, green: 0.52, blue: 0.59, alpha: 1)
        return image
    }()
    
    // MARK: - Init
    
    init(nameButton: String, image: UIImage) {
        super.init(frame: .zero)
        nameButtonLabel.text = nameButton
        simvolImage.image = image
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    
    private func setupView(){
        addSubview(bacgrounForSimvols)
        addSubview(simvolImage)
        addSubview(nameButtonLabel)
        addSubview(arrowImage)
    }
    // MARK: - Constraints
    
    private func setupConstraints(){
        bacgrounForSimvols.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(32)
            make.height.width.equalTo(42)
        }
        
        simvolImage.snp.makeConstraints { make in
            make.center.equalTo(bacgrounForSimvols.snp.center)
            make.height.width.equalTo(20)
        }
        
        nameButtonLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(bacgrounForSimvols.snp.trailing).offset(16)
        }
        
        arrowImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-32)
            make.height.width.equalTo(20)
        }
    }
    
}
