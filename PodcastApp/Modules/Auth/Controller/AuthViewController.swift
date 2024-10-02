import UIKit
import SnapKit

final class AuthViewController: UIViewController {
    
    // MARK: - UI Components
    private let loginLabel = CustomLabel(
        title: "Enter login",
        font: UIFont.systemFont(ofSize: 15)
    )
    
    let loginField = CustomTextField(
        fieldType: .withEyeButton,
        placeholder: "Login",
        border: true
    )
    
    private let passwordLabel = CustomLabel(
        title: "Password",
        font: UIFont.systemFont(ofSize: 15)
    )
    
    lazy var passwordField: CustomTextField = {
        var passTF = CustomTextField(
            fieldType: .withEyeButton,
            placeholder: "Password",
            border: true
        )
        passTF.customEyeButton.setImage(UIImage(
            systemName: "eye.slash.fill"), for: .normal)
        passTF.isSecureTextEntry = true
        return passTF
    }()
    
    private lazy var loginButton: CustomButton = {
        var logButton = CustomButton(
            title: "Login",
            font: UIFont.boldSystemFont(ofSize: 18),
            buttonType: .blueButton
        )
        
        logButton.addTarget(
            self,
            action: #selector(loginButtonDidTapped),
            for: .touchUpInside
        )
        
        return logButton
    }()
    
    private let continueView = ContinueView()
    
    private lazy var googleButton: CustomButton = {
        var googleButton = CustomButton(
            title: "Continue with Google",
            font: UIFont.boldSystemFont(ofSize: 18),
            buttonType: .googleButton
        )
        googleButton.addTarget(
            self,
            action: #selector(googleButtonDidTapped),
            for: .touchUpInside
        )
        
        return googleButton
    }()
    
    private let registerLabel: UILabel = {
        let infoLabel = AuthLabel(
            title: "Don't have an account yet? Register",
            activeString: "Register",
            font: .small
        )
        return infoLabel
    }()
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addViews()
        setupConstraints()
        setupDelegates()
        addTapGesture()
    }
    
    // MARK: - Override Methods
    // метод для скрытия клавиатуры по тапу на экран
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    // MARK: - Private Actions
    // вход в приложение через аккаунт гугл
    @objc private func googleButtonDidTapped() {
        FirebaseManager.shared.signInWithGoogle(
            presentingViewController: self) { result in
                switch result {
                case .success(let user):
                    print("Successfully")
                    
                    let email = user.email
                    let userName = user.displayName
                    let userImage = user.photoURL
                    let stringURL = userImage?.absoluteString
                    StorageManager.shared.checkedUser(for: email, with: userName, and: stringURL)
                    
                    //navigation to next screen
                    self.navigateToHomeScreen()
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    @objc private func registerButtonDidTapped() {
        let createAccVC = CreateAccountViewController()
        navigationController?.pushViewController(createAccVC, animated: true)
    }
    
    @objc private func loginButtonDidTapped() {
        if let email = loginField.text, let password = passwordField.text {
            FirebaseManager.shared.signIn(withEmail: email, password: password) { result in
                switch result {
                case .success(_):
                    print("You login successfully")
                    
                    let imageURL = "https://kartinkof.club/uploads/posts/2022-04/1649608700_6-kartinkof-club-p-ugarnie-kartinki-pro-ugarnogo-parnya-6.jpg"
                    
                    let userInfo = UserInfo(firstName: "Красавчик",
                                            lastName: "Сердцеед",
                                            eMail: email,
                                            dateOfBithday: Date.now,
                                            gender: .Male,
                                            imageURL: imageURL)
                    StorageManager.shared.saveUser(userInfo)
                    StorageManager.shared.checkedUser(for: email)
                    
                    self.loginField.layer.borderColor = #colorLiteral(red: 0.9294117689, green: 0.9294117093, blue: 0.9294117093, alpha: 1)
                    self.passwordField.layer.borderColor = #colorLiteral(red: 0.9294117689, green: 0.9294117093, blue: 0.9294117093, alpha: 1)
                    self.loginField.text = ""
                    self.passwordField.text = ""
                    //navigation to next screen
                    self.navigateToHomeScreen()
                case .failure(let error):
                    print(error)
                    self.loginField.layer.borderColor = UIColor.red.cgColor
                    self.passwordField.layer.borderColor = UIColor.red.cgColor
                }
            }
        }
    }
    
    // MARK: - Navigation
    private func navigateToHomeScreen() {
        let isOnboardingCompleted = AppSettingsManager.onboardingStatus()
        let startVC = isOnboardingCompleted
        ? CustomTabBarController()
        : OnboardingViewController()
        startVC.modalPresentationStyle = .fullScreen
        self.present(startVC, animated: true)
    }
    
    
    // MARK: - Private Methods
    private func setupDelegates() {
        loginField.delegate = self
        passwordField.delegate = self
        
    }
    
    private func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(registerButtonDidTapped)
        )
        registerLabel.addGestureRecognizer(tapGesture)
    }
    
    private func addViews() {
        view.addSubview(loginLabel)
        view.addSubview(loginField)
        view.addSubview(passwordLabel)
        view.addSubview(passwordField)
        view.addSubview(loginButton)
        view.addSubview(continueView)
        view.addSubview(googleButton)
        view.addSubview(registerLabel)
    }
    
    private func setupConstraints() {
        loginLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(120)
            make.left.equalToSuperview().offset(16)
        }
        
        loginField.snp.makeConstraints { make in
            make.top.equalTo(loginLabel.snp.bottom).offset(7)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(45)
        }
        
        passwordLabel.snp.makeConstraints { make in
            make.top.equalTo(loginField.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(16)
        }
        
        passwordField.snp.makeConstraints { make in
            make.top.equalTo(passwordLabel.snp.bottom).offset(7)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(45)
        }
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordField.snp.bottom).offset(24)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(57)
        }
        
        continueView.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(45)
            make.centerX.equalToSuperview()
        }
        
        googleButton.snp.makeConstraints { make in
            make.top.equalTo(continueView.snp.bottom).offset(56)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.height.equalTo(56)
        }
        
        registerLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-50)
        }
    }
}

// MARK: - UITextFieldDelegate
extension AuthViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}
