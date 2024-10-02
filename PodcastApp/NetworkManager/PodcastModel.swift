import Foundation

struct SearchedResult: Codable {
    
    let status: String?
    
    // в случае поиска трендовых подкастов или подкастов по категориям
    let feeds: [Podcast]?
    let description: String?
    let count: Int? // в т.ч. в случае поиска эпизодов
    
    // только в случае поиска подкаста по его ID
    let query: [String: String]?
    let feed: Podcast?
    
    // только в случае поиска эпизодов
    let items: [PodcastEpisode]?
    //    let count: Int?
}


// ПОИСК ПОДКАСТОВ

struct SearchPodcats: Codable {
    let status: String?
    let feeds: [Podcast]?
    let count: Int?
    let query: String?
    let description: String?
}


struct Podcast: Codable {
    // categories
    let name: String?
    
    // podcasts
    let id: Int?
    let title: String?
    let description: String?
    let author: String?
    let image: String?
    let artwork: String?
    
    // trending
    let url: String?
    let itunesId: Int?
    let trendScore: Int?
    let language: String?
    
    let categories: [String: String]?
    
    var categoryNames: [String] {
        guard let dict = categories else { return [] }
        return dict.map { $0.value }
    }
    
    var categoriesLabel: String {
        guard let dict = categories else { return "" }
        let categories = dict.map { $0.value }
        return categories.joined(separator: " & ")
    }
    
}

// ПОИСК ЭПИЗОДОВ

struct SearchEpisods: Codable {
    let status: String?
    let items: [PodcastEpisode]?
    let count: Int?
    let query: String?
    let description: String?
}

struct PodcastEpisode: Codable {
    let id: Int?
    let title: String?
    let link: String?
    let description: String?
    
    let enclosureUrl: String?
    let enclosureType: String?
    let enclosureLength: Int?
    let duration: Int? // The estimated length of the item specified by the enclosureUrl in seconds. Will be null for liveItem.
    
    let episode: Int?
    
    let season: Int?
    
    let image: String?
    
    let feedItunesId: Int?
    let feedImage: String?
    
    let feedId: Int?
    let feedLanguage: String?
    
    var formattedTime: String {
        guard let duration = duration else { return "00:00:00" }
        let hours = duration / 3600
        let minutes = (duration % 3600) / 60
        let seconds = (duration % 3600 ) % 60
        
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}


