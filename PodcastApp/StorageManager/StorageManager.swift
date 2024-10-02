import Foundation
import RealmSwift

class StorageManager {
    
    static let shared = StorageManager()
    
    private let realm = try! Realm()
    
    private var favorites: Results<PodcastModel>!
    
    private var isUserSaved = false
    private(set) var currentUser: UserInfo?
    
    // MARK: - Initial
    
    private init() {}
    
    // MARK: - Methods for User

    func saveUser(_ user: UserInfo) {
        try! realm.write {
            currentUser = user
            realm.add(user)
        }
    }
    
    func checkedUser(for email: String?, with userName: String? = nil, and imageURL: String? = nil) {
        if let registerdUser = realm.objects(UserInfo.self).filter("eMail == %@", email ?? "").first {
            currentUser = registerdUser
        } else {
            let userInfo = UserInfo(firstName: userName, eMail: email ?? "", imageURL: imageURL)
            currentUser = userInfo
            saveUser(userInfo)
        }
    }
    
    func getCurrentUser() -> UserInfo? {
        realm.objects(UserInfo.self).first
    }
    
    func updateUserInfo(firstName: String, lastName: String, dateOfBirth: Date, gender: GenderType, image: Data?) {
        
        try! realm.write {
            if currentUser?.eMail == getCurrentUser()?.eMail {
                currentUser?.firstName = firstName
                currentUser?.lastName = lastName
                currentUser?.dateOfBithday = dateOfBirth
                currentUser?.gender = gender
                currentUser?.image = image
            } else {
                let newUser = UserInfo()
                newUser.firstName = firstName
                newUser.lastName = lastName
                newUser.dateOfBithday = dateOfBirth
                newUser.gender = gender
                newUser.image = image
                realm.add(newUser)
            }
        }
    }
    
    func updateUserInfo(for user: UserInfo?) {
        
        try! realm.write {
            if currentUser?.eMail == getCurrentUser()?.eMail {
                currentUser?.firstName = user?.firstName
                currentUser?.lastName = user?.lastName
                currentUser?.dateOfBithday = user?.dateOfBithday
                currentUser?.gender = user?.gender
                currentUser?.imageURL = user?.imageURL
                currentUser?.image = user?.image
            } else {
                saveUser(user!)
            }
        }
    }
    
    // MARK: - Methods for podcasts
    
    func save(podcast: PodcastModel) {
        try! realm.write {
            currentUser?.podcasts.append(podcast)
        }
    }
    
    func delete(podcast: PodcastModel) {
        try! realm.write {
            let allUploadingObjects = realm.objects(PodcastModel.self).filter("id == %@", podcast.id ?? 0)
            realm.delete(allUploadingObjects)
        }
    }
    
    func read(completion: @escaping(Results<PodcastModel>) -> Void) {
        favorites = realm.objects(PodcastModel.self)
        DispatchQueue.main.async {
            completion(self.favorites)
        }
    }
    
    func isSaved(for id: Int) -> Bool {
        let object = realm.objects(PodcastModel.self).filter("id == %d", id).first
        return object != nil
    }

}

