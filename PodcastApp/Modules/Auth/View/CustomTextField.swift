import UIKit

final class CustomTextField: UITextField {
    
    // MARK: - Enum
    enum CustomTextFieldType {
        case withEyeButton
        case withoutEyeButton
    }
    
    // MARK: - Private Properties
    private let authFieldType: CustomTextFieldType
    let customEyeButton = UIButton(type: .custom)
    
    // MARK: - Init
    init(fieldType: CustomTextFieldType, placeholder: String, border: Bool) {
        self.authFieldType = fieldType
        super.init(frame: .zero)
        
        self.placeholder = placeholder
        self.backgroundColor = UIColor.textFieldColorTwo
        self.layer.cornerRadius = 13
        self.returnKeyType = .done
        self.autocorrectionType = .no
        self.autocapitalizationType = .none
        
        self.leftViewMode = .always
        self.leftView = UIView(frame: CGRect(
            x: 0, y: 0, width: 15,
            height: self.frame.size.height)
        )
        let placeholderText = NSAttributedString(
            string: placeholder,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.placeholderColor]
        )
        self.attributedPlaceholder = placeholderText
        
        
        if border {
            self.layer.borderColor = #colorLiteral(red: 0.9294117689, green: 0.9294117093, blue: 0.9294117093, alpha: 1)
            self.layer.borderWidth = 1
            self.backgroundColor = UIColor.textFieldColorOne
        }
        
        switch fieldType {
            
        case .withEyeButton:
            let rightView = UIView()
            rightView.frame = CGRect(x: 0, y: 0, width: 50, height: 40)
            
            
            customEyeButton.setImage(UIImage(systemName: "eye.fill"), for: .normal)
            customEyeButton.frame = CGRect(x: 10, y: 10, width: 23, height: 20)
            customEyeButton.tintColor = UIColor.systemGray2
            
            customEyeButton.addTarget(
                self,
                action: #selector(toggleTextVisibility),
                for: .touchUpInside
            )
            
            rightView.addSubview(customEyeButton)
            self.rightView = rightView
            self.rightViewMode = .always
        case .withoutEyeButton:
            self.layer.cornerRadius = 25
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Actions
    @objc private func toggleTextVisibility(_ sender: UIButton) {
        if let textField = sender.superview?.superview as? UITextField {
            textField.isSecureTextEntry.toggle()
            
            let image = textField.isSecureTextEntry
            ? UIImage(systemName: "eye.slash.fill")
            : UIImage(systemName: "eye.fill")
            
            sender.setImage(image, for: .normal)
        }
    }
}
