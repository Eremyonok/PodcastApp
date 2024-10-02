import Foundation

final class ProfileManager {
    
    static let shared = ProfileManager()
    
    private init() {}
    
    //MARK: - Public methods
    
    func saveUser(_ model: UserModel) {
        //save user to Realm DB
    }
    
    func getUser() -> UserModel {
        //get user data from Realm DB
        return .init()
    }
 }
