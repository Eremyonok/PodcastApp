import Foundation

enum Section {
    case category
    case types
    case podcasts
}

struct HomeModule {
    let categories: [PodcastCategory]
}

struct PodcastCategory {
    let category: String
    let podcasts: [PodcastInfo]
}

struct PodcastInfo {
    let name: String
    let author: String
    let imageUrl: String
}

// MARK: - Test Data

extension HomeModule {
    
    static func getData() -> [PodcastCategory] {
        
        [
            PodcastCategory(category: "Music & Fun",
                            podcasts: [PodcastInfo(name: "Ngobam", author: "Gofar Hilman", imageUrl: "goforward.45"),
                                       PodcastInfo(name: "Semprod", author: "Kuy Enter", imageUrl: "goforward.45"),
                                       PodcastInfo(name: "Sruput", author: "Funny Bunny", imageUrl: "goforward.45"),
                                       PodcastInfo(name: "Monkey", author: "Pull Request", imageUrl: "goforward.45"),
                                       PodcastInfo(name: "Love", author: "Merge Git", imageUrl: "goforward.45")]),
            
            PodcastCategory(category: "Life & Chill",
                            podcasts: [PodcastInfo(name: "Ngobam", author: "Gofar Hilman", imageUrl: "goforward.45"),
                                       PodcastInfo(name: "Semprod", author: "Kuy Enter", imageUrl: "goforward.45"),
                                       PodcastInfo(name: "Sruput", author: "Funny Bunny", imageUrl: "goforward.45"),
                                       PodcastInfo(name: "Monkey", author: "Pull Request", imageUrl: "goforward.45"),
                                       PodcastInfo(name: "Love", author: "Merge Git", imageUrl: "goforward.45")]),
            
            PodcastCategory(category: "Funny Life",
                            podcasts: [PodcastInfo(name: "Ngobam", author: "Gofar Hilman", imageUrl: "goforward.45"),
                                       PodcastInfo(name: "Semprod", author: "Kuy Enter", imageUrl: "goforward.45"),
                                       PodcastInfo(name: "Sruput", author: "Funny Bunny", imageUrl: "goforward.45"),
                                       PodcastInfo(name: "Monkey", author: "Pull Request", imageUrl: "goforward.45"),
                                       PodcastInfo(name: "Love", author: "Merge Git", imageUrl: "goforward.45")]),
            
            PodcastCategory(category: "Storie",
                            podcasts: [PodcastInfo(name: "Ngobam", author: "Gofar Hilman", imageUrl: "goforward.45"),
                                       PodcastInfo(name: "Semprod", author: "Kuy Enter", imageUrl: "goforward.45"),
                                       PodcastInfo(name: "Sruput", author: "Funny Bunny", imageUrl: "goforward.45"),
                                       PodcastInfo(name: "Monkey", author: "Pull Request", imageUrl: "goforward.45"),
                                       PodcastInfo(name: "Love", author: "Merge Git", imageUrl: "goforward.45")]),
            
            PodcastCategory(category: "Comedy",
                            podcasts: [PodcastInfo(name: "Ngobam", author: "Gofar Hilman", imageUrl: "goforward.45"),
                                       PodcastInfo(name: "Semprod", author: "Kuy Enter", imageUrl: "goforward.45"),
                                       PodcastInfo(name: "Sruput", author: "Funny Bunny", imageUrl: "goforward.45"),
                                       PodcastInfo(name: "Monkey", author: "Pull Request", imageUrl: "goforward.45"),
                                       PodcastInfo(name: "Love", author: "Merge Git", imageUrl: "goforward.45")]),
            
            PodcastCategory(category: "Sport",
                            podcasts: [PodcastInfo(name: "Ngobam", author: "Gofar Hilman", imageUrl: "goforward.45"),
                                       PodcastInfo(name: "Semprod", author: "Kuy Enter", imageUrl: "goforward.45"),
                                       PodcastInfo(name: "Sruput", author: "Funny Bunny", imageUrl: "goforward.45"),
                                       PodcastInfo(name: "Monkey", author: "Pull Request", imageUrl: "goforward.45"),
                                       PodcastInfo(name: "Love", author: "Merge Git", imageUrl: "goforward.45")]),
        
        ]
        
    }
    
    static func getCategories() -> [String] {
        ["🔥 Popular",
         "Recent",
         "Music",
         "Design",
         "Sport",
         "Comedy",
         "Politics",
         "Fashion"]
    }
    
}
