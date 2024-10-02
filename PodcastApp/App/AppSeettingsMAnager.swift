import Foundation

struct AppSettingsManager {
    static private let isOnboardingCompleted = "OnnboardingCompleted"
    
    static func setCompleted() {
        UserDefaults.standard.set(true, forKey: isOnboardingCompleted)
    }
    
    static func onboardingStatus() -> Bool {
        UserDefaults.standard.bool(forKey: isOnboardingCompleted)
    }
}
