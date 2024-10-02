import UIKit

final class CreateAccountViewController: UIViewController {
    
    // MARK: - Private Properties
    private let welcomeLabel = CustomLabel(
        title: "Create account",
        font: UIFont.boldSystemFont(ofSize: 24),
        color: .white
    )
    
    private lazy var whiteView: UIView = {
        var whiteView = UIView()
        whiteView.layer.cornerRadius = 30
        whiteView.backgroundColor = .white
        return whiteView
    }()
    
    private let emailLabel = CustomLabel(
        title: "Email"
    )
    
    private let emailField = CustomTextField(
        fieldType: .withoutEyeButton,
        placeholder: "Enter your email address",
        border: false
    )
    
    private lazy var continueButton: CustomButton = {
        var contButton = CustomButton(
            title: "Continue with Email",
            buttonType: .blueButton
        )
        contButton.addTarget(
            self,
            action: #selector(continueButtonDidTapped),
            for: .touchUpInside
        )
        return contButton
    }()
    
    private let continueView = ContinueView()
    
    private lazy var googleButton: CustomButton = {
        var googleButton = CustomButton(
            title: "Continue with Google",
            buttonType: .googleButton
        )
        googleButton.addTarget(
            self,
            action: #selector(googleButtonDidTapped),
            for: .touchUpInside
        )
        return googleButton
    }()
    
    private let loginLabel: UILabel = {
        let loginLabel = AuthLabel(
            title: "Already have an account? Login",
            activeString: "Login",
            font: .medium
        )
        return loginLabel
    }()
    
    private lazy var errorLabel: UILabel = {
        var errorLabel = CustomLabel(
            title: "Enter your email",
            color: .systemRed
        )
        errorLabel.isHidden = true
        return errorLabel
    }()
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.customBlue
        emailField.delegate = self
        navigationItem.hidesBackButton = true
        
        addViews()
        setupConstraints()
        addTapGesture()
        setNavigationAppearance()
    }
    
    //MARK: - Methods
    
    private func setNavigationAppearance() {
    //set custom arrow for back button
        let backViewImage = UIImage(named: "ArrowBackBig")?.withRenderingMode(.alwaysOriginal)
        navigationController?.navigationBar.backIndicatorImage = backViewImage
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = backViewImage
    }
    
    // MARK: - Override Methods
    // метод для скрытия клавиатуры по тапу на экран
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    // MARK: - Private Actions
    @objc private func googleButtonDidTapped() {
        FirebaseManager.shared.signInWithGoogle(
            presentingViewController: self) { result in
                switch result {
                case .success(_):
                    print("Successfully")
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
    
    @objc private func loginButtonDidTapped() {
        // очищаем textField в AuthViewController при возврате на экран
        if let authVC = navigationController?.viewControllers.first as? AuthViewController {
            authVC.loginField.text = ""
            authVC.passwordField.text = ""
        }
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func continueButtonDidTapped() {
        // если emailTF не пустой, то делаем переход
        if emailField.text != "" {
            let registerVC = RegistrationViewController()
            registerVC.selectedEmail = emailField.text
            navigationController?.pushViewController(registerVC, animated: true)
            // скрываем ошибку
            errorLabel.isHidden = true
        } else {
            // если пустой, то показываем ошибку
            errorLabel.isHidden = false
        }
    }
    
    // MARK: - Private Methods
    
    private func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(loginButtonDidTapped)
        )
        loginLabel.addGestureRecognizer(tapGesture)
    }
    
    private func addViews() {
        view.addSubview(welcomeLabel)
        view.addSubview(whiteView)
        whiteView.addSubview(emailLabel)
        whiteView.addSubview(emailField)
        whiteView.addSubview(continueButton)
        whiteView.addSubview(continueView)
        whiteView.addSubview(googleButton)
        whiteView.addSubview(loginLabel)
        whiteView.addSubview(errorLabel)
    }
    
    private func setupConstraints() {
        welcomeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.centerX.equalToSuperview()
        }
        
        whiteView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(200)
            make.bottom.equalToSuperview().offset(25)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        emailLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(47)
            make.left.equalToSuperview().offset(24)
        }
        
        emailField.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.height.equalTo(60)
        }
        
        errorLabel.snp.makeConstraints { make in
            make.top.equalTo(emailField.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        continueButton.snp.makeConstraints { make in
            make.top.equalTo(errorLabel.snp.bottom).offset(15)
            make.left.equalToSuperview().offset(25)
            make.right.equalToSuperview().offset(-25)
            make.height.equalTo(56)
        }
        
        continueView.snp.makeConstraints { make in
            make.top.equalTo(continueButton.snp.bottom).offset(32)
            make.centerX.equalToSuperview()
        }
        
        googleButton.snp.makeConstraints { make in
            make.top.equalTo(continueView.snp.bottom).offset(55)
            make.left.equalToSuperview().offset(25)
            make.right.equalToSuperview().offset(-25)
            make.height.equalTo(56)
        }
        
        loginLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-50)
        }
    }
}

// MARK: - UITextFieldDelegate
extension CreateAccountViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}
