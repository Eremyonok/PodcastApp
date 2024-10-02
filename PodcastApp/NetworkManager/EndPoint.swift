import Foundation

enum EndPoint {
    case getCategoryList
    case getTrendingPodcast
    case searchPodcasts
    case getEpisodsForPodcats
    
    var path: String {
        switch self {
        case .getCategoryList:
            return "/api/1.0/categories/list"
        case .getTrendingPodcast:
            return "/api/1.0/podcasts/trending"
        case .searchPodcasts:
            return "/api/1.0/search/byterm"
        case .getEpisodsForPodcats:
            return "/api/1.0/episodes/byfeedid"
        }
    }
}
