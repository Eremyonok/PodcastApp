import Foundation
import RealmSwift

enum GenderType: String, PersistableEnum {
    case Male, Female, NoGender
}

final class UserInfo: Object {
    @Persisted var firstName: String?
    @Persisted var lastName: String?
    @Persisted var eMail = ""
    @Persisted var dateOfBithday: Date?
    @Persisted var gender: GenderType?
    @Persisted var imageURL: String?
    @Persisted var image: Data?
    
    @Persisted var podcasts = List<PodcastModel>()
    
    convenience init(firstName: String? = nil, lastName: String? = nil, eMail: String = "", dateOfBithday: Date? = nil, gender: GenderType? = nil, imageURL: String? = nil, image: Data? = nil) {
        self.init()
        self.firstName = firstName
        self.lastName = lastName
        self.eMail = eMail
        self.dateOfBithday = dateOfBithday
        self.gender = gender
        self.imageURL = imageURL
        self.image = image
    }
}

final class PodcastModel: Object {
    @Persisted var id: Int?
    @Persisted var title: String?
    @Persisted var author: String?
    @Persisted var imageURL: String?
    
    convenience init(id: Int?, title: String?, author: String?, imageURL: String?) {
        self.init()
        self.id = id
        self.title = title
        self.author = author
        self.imageURL = imageURL
    }
}
