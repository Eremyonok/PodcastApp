import UIKit

final class ContinueView: UIView {
    
    // MARK: - Private Properties
    private lazy var mainLabel: CustomLabel = {
        var customLabel = CustomLabel(
            title: "Or continue with",
            font: UIFont.custome(name: .plusJakartaSans600, size: 14)
            ?? UIFont.systemFont(ofSize: 14),
            color: #colorLiteral(red: 0.4235294461, green: 0.4235294461, blue: 0.4235294461, alpha: 1)
        )
        return customLabel
    }()
    
    private lazy var leftView: UIView = {
        var leftView = UIView()
        leftView.backgroundColor = #colorLiteral(red: 0.4235294461, green: 0.4235294461, blue: 0.4235294461, alpha: 1)
        return leftView
    }()
    
    private lazy var rightView: UIView = {
        var leftView = UIView()
        leftView.backgroundColor = #colorLiteral(red: 0.4235294461, green: 0.4235294461, blue: 0.4235294461, alpha: 1)
        return leftView
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    private func addViews() {
        self.addSubview(mainLabel)
        self.addSubview(leftView)
        self.addSubview(rightView)
    }
    
    private func setupConstraints() {
        mainLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
        }
        
        leftView.snp.makeConstraints { make in
            make.right.equalTo(mainLabel.snp.left).offset(-10)
            make.centerY.equalTo(mainLabel.snp.centerY)
            make.width.equalTo(62)
            make.height.equalTo(1)
        }
        
        rightView.snp.makeConstraints { make in
            make.left.equalTo(mainLabel.snp.right).offset(10)
            make.centerY.equalTo(mainLabel.snp.centerY)
            make.width.equalTo(62)
            make.height.equalTo(1)
        }
    }
}
