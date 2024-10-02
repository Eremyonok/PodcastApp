import UIKit
import FirebaseAuth

final class RegistrationViewController: UIViewController {
    
    // MARK: - Public Properties
    var selectedEmail: String?
    
    // MARK: - Private UI Properties
    private let welcomeLabel = CustomLabel(
        title: "Complete your account",
        font: UIFont.boldSystemFont(ofSize: 24),
        color: .black
    )
    
    private lazy var signUpButton: CustomButton = {
        var signButton = CustomButton(
            title: "Sign Up",
            buttonType: .blueButton
        )
        signButton.addTarget(
            self,
            action: #selector(signUpButtonDidTapped),
            for: .touchUpInside
        )
        return signButton
    }()
    
    private let loginLabel: UILabel = {
        let loginLabel = AuthLabel(
            title: "Already have an account? Login",
            activeString: "Login",
            font: .medium
        )
        return loginLabel
    }()
    
    // MARK: - FirstName Properties
    private let firstNameLabel = CustomLabel(title: "First Name")
    
    private let firstNameField = CustomTextField(
        fieldType: .withoutEyeButton,
        placeholder: "Enter you first name",
        border: false
    )
    
    private lazy var firstNameStackView: UIStackView  = {
        var firstNameSV = UIStackView(
            arrangedSubviews: [firstNameLabel, firstNameField]
        )
        firstNameSV.axis = .vertical
        firstNameSV.spacing = 10
        return firstNameSV
    }()
    
    // MARK: - LastName Properties
    private let lastNameLabel = CustomLabel(title: "Last Name")
    
    private let lastNameField = CustomTextField(
        fieldType: .withoutEyeButton,
        placeholder: "Enter you last name",
        border: false
    )
    
    private lazy var lastNameStackView: UIStackView  = {
        var lastNameSV = UIStackView(
            arrangedSubviews: [lastNameLabel, lastNameField]
        )
        lastNameSV.axis = .vertical
        lastNameSV.spacing = 10
        return lastNameSV
    }()
    
    // MARK: - Email Properties
    private let emailLabel = CustomLabel(title: "E-mail")
    
    private var emailField = CustomTextField(
        fieldType: .withoutEyeButton,
        placeholder: "Enter you email",
        border: false
    )
    
    private lazy var emailStackView: UIStackView  = {
        var emailSV = UIStackView(
            arrangedSubviews: [emailLabel, emailField]
        )
        emailSV.axis = .vertical
        emailSV.spacing = 10
        return emailSV
    }()
    
    // MARK: - Password Properties
    private let passwordLabel = CustomLabel(title: "Password")
    
    private lazy var passwordField: CustomTextField = {
        var passField = CustomTextField(
            fieldType: .withEyeButton,
            placeholder: "Enter you password",
            border: false
        )
        passField.customEyeButton.setImage(UIImage(
            systemName: "eye.slash.fill"), for: .normal)
        passField.isSecureTextEntry = true
        passField.layer.cornerRadius = 25
        passField.textContentType = .oneTimeCode
        return passField
    }()
    
    private lazy var passwordStackView: UIStackView  = {
        var passwordSV = UIStackView(
            arrangedSubviews: [passwordLabel, passwordField]
        )
        passwordSV.axis = .vertical
        passwordSV.spacing = 10
        return passwordSV
    }()
    
    // MARK: - ConfirmPassword Properties
    private let confirmPasswordLabel = CustomLabel(title: "Confirm Password")
    
    private lazy var confirmPasswordField: CustomTextField = {
        var passField = CustomTextField(
            fieldType: .withEyeButton,
            placeholder: "Enter you password",
            border: false
        )
        passField.customEyeButton.setImage(UIImage(
            systemName: "eye.slash.fill"), for: .normal)
        passField.isSecureTextEntry = true
        passField.layer.cornerRadius = 25
        passField.textContentType = .oneTimeCode
        return passField
    }()
    
    private lazy var confirmPasswordStackView: UIStackView  = {
        var passSV = UIStackView(
            arrangedSubviews: [confirmPasswordLabel, confirmPasswordField]
        )
        passSV.axis = .vertical
        passSV.spacing = 10
        return passSV
    }()
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign Up"
        view.backgroundColor = .white
        addViews()
        setupConstraints()
        setupTextFields()
        addTapGesture()
        addObservers()
        
        setupCustomBackButton()
        //принимаем почту с экрана СreateAccountVC
        emailField.text = selectedEmail
    }
    
    // MARK: - Override Methods
    // метод для скрытия клавиатуры по тапу на экран
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    // MARK: - Private Actions
    @objc private func loginButtonDidTapped() {
        //возвращаемся на экран AuthViewController
        if let authVC = navigationController?.viewControllers.first as? AuthViewController {
            // очищаем текст в AuthViewController при переходе
            authVC.loginField.text = ""
            authVC.passwordField.text = ""
            navigationController?.popToViewController(authVC, animated: true)
        }
    }
    
    // регистрация пользовался и проверка всех textFields
    @objc private func signUpButtonDidTapped() {
        let textFieldsToCheck = [firstNameField, lastNameField, emailField, passwordField, confirmPasswordField]
        
        var isAllFieldsValid = true
        
        for textField in textFieldsToCheck {
            if let text = textField.text, text.isEmpty {
                // Если поле не заполнено, устанавливаем красную границу
                textField.layer.borderColor = UIColor.red.cgColor
                textField.layer.borderWidth = 1.0
                isAllFieldsValid = false
            } else {
                // Если поле не пустое, сбрасываем границу (или устанавливаем стандартный стиль)
                textField.layer.borderWidth = 0.0
            }
        }
        
        if !isAllFieldsValid {
            // Остановка регистрации, если не все поля заполнены
            return
        }
        
        let password = passwordField.text ?? ""
        let confirmPassword = confirmPasswordField.text ?? ""
        let email = emailField.text ?? ""
        
        // Проверка совпадения паролей
        if password != confirmPassword {
            passwordField.layer.borderColor = UIColor.red.cgColor
            passwordField.layer.borderWidth = 1.0
            confirmPasswordField.layer.borderColor = UIColor.red.cgColor
            confirmPasswordField.layer.borderWidth = 1.0
            return
        } else {
            passwordField.layer.borderWidth = 0.0
            confirmPasswordField.layer.borderWidth = 0.0
        }
        
        // Проверка длины пароля
        if password.count < 6 {
            passwordField.layer.borderColor = UIColor.red.cgColor
            passwordField.layer.borderWidth = 1.0
            return
        } else {
            passwordField.layer.borderWidth = 0.0
        }
        
        // Проверка наличия "@" в email
        if !email.contains("@") {
            emailField.layer.borderColor = UIColor.red.cgColor
            emailField.layer.borderWidth = 1.0
            return
        } else {
            emailField.layer.borderWidth = 0.0
        }
        
        // Если все проверки пройдены, регистрируем пользователя
        FirebaseManager.shared.createUser(withEmail: email, password: password) { result in
            switch result {
                
            case .success(_):
                print("User was successfully registered")
                let userInfo = UserInfo(firstName: textFieldsToCheck[0].text ?? "",
                                        lastName: textFieldsToCheck[1].text ?? "",
                                        eMail: textFieldsToCheck[2].text ?? "")
                StorageManager.shared.saveUser(userInfo)
                
                //navigation to next screen
                let isOnboardingCompleted = AppSettingsManager.onboardingStatus()
                let startVC = isOnboardingCompleted ? CustomTabBarController() : OnboardingViewController()
                startVC.modalPresentationStyle = .fullScreen
                self.present(startVC, animated: true)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: - Private methods
    // поднимаем view когда выезжает клавиатура
    private func addObservers() {
        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillShowNotification,
            object: nil,
            queue: nil) { _ in
                self.view.frame.origin.y = -200
            }
        
        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: nil) { _ in
                self.view.frame.origin.y = 0
            }
    }
    
    // отбратотка нажания на loginLabel
    private func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(loginButtonDidTapped)
        )
        loginLabel.addGestureRecognizer(tapGesture)
    }
    
    private func addViews() {
        view.addSubview(welcomeLabel)
        view.addSubview(firstNameStackView)
        view.addSubview(lastNameStackView)
        view.addSubview(emailStackView)
        view.addSubview(passwordStackView)
        view.addSubview(confirmPasswordStackView)
        view.addSubview(signUpButton)
        view.addSubview(loginLabel)
    }
    
    private func setupConstraints() {
        welcomeLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.centerX.equalToSuperview()
        }
        
        firstNameStackView.snp.makeConstraints { make in
            make.top.equalTo(welcomeLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
        }
        
        lastNameStackView.snp.makeConstraints { make in
            make.top.equalTo(firstNameStackView.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
        }
        
        emailStackView.snp.makeConstraints { make in
            make.top.equalTo(lastNameStackView.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
        }
        
        passwordStackView.snp.makeConstraints { make in
            make.top.equalTo(emailStackView.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
        }
        
        confirmPasswordStackView.snp.makeConstraints { make in
            make.top.equalTo(passwordStackView.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.top.equalTo(confirmPasswordStackView.snp.bottom).offset(18)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.height.equalTo(56)
        }
        
        loginLabel.snp.makeConstraints { make in
            make.top.equalTo(signUpButton.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-30)
        }
        
        firstNameField.snp.makeConstraints { make in
            make.height.equalTo(45)
        }
        
        lastNameField.snp.makeConstraints { make in
            make.height.equalTo(45)
        }
        
        emailField.snp.makeConstraints { make in
            make.height.equalTo(45)
        }
        
        passwordField.snp.makeConstraints { make in
            make.height.equalTo(45)
        }
        
        confirmPasswordField.snp.makeConstraints { make in
            make.height.equalTo(45)
        }
    }
    
    private func setupTextFields() {
        firstNameField.delegate = self
        lastNameField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
        confirmPasswordField.delegate = self
    }
}

// MARK: - UITextFieldDelegate
extension RegistrationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}

// MARK: - NavigationBar
extension RegistrationViewController {
    private func setupCustomBackButton() {

        let customView = UIView()
        customView.backgroundColor  = #colorLiteral(red: 0.9215686321, green: 0.9215685725, blue: 0.9215685725, alpha: 1)
        customView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        customView.layer.cornerRadius = customView.frame.height / 2
        customView.clipsToBounds = true
        
        let arrowImageView = UIImageView(image: UIImage(systemName: "arrow.left"))
        arrowImageView.tintColor = .black
        arrowImageView.frame = CGRect(x: 12, y: 12, width: 17, height: 15)
        
        customView.addSubview(arrowImageView)
        
        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(backButtonDidTapped)
        )
        
        customView.addGestureRecognizer(tapGestureRecognizer)
        
        let customBackButton = UIBarButtonItem(customView: customView)
        navigationItem.leftBarButtonItem = customBackButton
    }
    
    @objc private func backButtonDidTapped() {
        navigationController?.popViewController(animated: true)
    }
}
