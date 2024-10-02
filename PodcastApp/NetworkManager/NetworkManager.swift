import Foundation
import CryptoKit

enum NetworkError: Error {
    case transportError(Error)
    case serverError(statusCode: Int)
    case noData
    case decodingError(Error)
}

struct NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    /// Метод создает URL
    private func createURL(for endPoint: EndPoint, with query: String?) -> URL? {
        var components = URLComponents()
        components.scheme = API.scheme
        components.host = API.host
        components.path = endPoint.path
        
        components.queryItems = makeParameters(for: endPoint, with: query).compactMap {
            URLQueryItem(name: $0.key, value: $0.value)
        }
        
        return components.url
    }
    
    /// Метод по созданию параметров
    private func makeParameters(for endPoint: EndPoint, with query: String?) -> [String: String] {
        var parameters: [String: String] = [:]
        
        switch endPoint {
        case .getTrendingPodcast:
            if query != nil {
                let formattedQuery = query?.replacingOccurrences(of: " ", with: ",") // формат должен быть cat=News,Religion,Sport
                parameters["cat"] = formattedQuery
            }
        case .searchPodcasts:
            if query != nil {
                let formattedQuery = query?.replacingOccurrences(of: " ", with: "+") // формат должен быть cat=Funny+School
                parameters["q"] = formattedQuery
            }
        case .getEpisodsForPodcats:
            if query != nil {
                parameters["id"] = query
            }
            
        default: // getCategoryList
            break
        }
        
        return parameters
    }
    
    /// Метод создает REQUEST
    private func getRequest(_ url: URL) -> URLRequest {
        // prep for crypto
        let timeInSeconds: TimeInterval = Date().timeIntervalSince1970
        let apiHeaderTime = Int(timeInSeconds)
        let data4Hash = API.apiKey + API.apiSecret + "\(apiHeaderTime)"
        
        // ======== Hash them to get the Authorization token ========
        let inputData = Data(data4Hash.utf8)
        let hashed = Insecure.SHA1.hash(data: inputData)
        let hashString = hashed.compactMap { String(format: "%02x", $0) }.joined()
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue( "\(apiHeaderTime)", forHTTPHeaderField: "X-Auth-Date")
        request.addValue( API.apiKey, forHTTPHeaderField: "X-Auth-Key")
        request.addValue( hashString, forHTTPHeaderField: "Authorization")
        request.addValue( "SuperPodcastPlayer/1.8", forHTTPHeaderField: "User-Agent")
        
        return request
    }
    
    /// Метод создает TASK
    private func makeTask<T: Codable>(for request: URLRequest, using session: URLSession = .shared, completion: @escaping (Result<T, NetworkError>) -> Void) {
        session.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(.transportError(error)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let decodeData = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodeData))
                }
            } catch {
                completion(.failure(.decodingError(error)))
            }
            
        }.resume()
    }
    
}

// MARK: - PUBLIC METHODS

extension NetworkManager {
    
    /// Запрос трендовых подкастов
    func fetchTrendingPodcast(for category: String? = nil, completion: @escaping (Result<SearchedResult, NetworkError>) -> Void) {
        guard let url = createURL(for: .getTrendingPodcast, with: category) else { return }
        let request = getRequest(url)
        makeTask(for: request, completion: completion)
    }
    
    /// Запрос трендовых подкастов по нескольким категориям
    func fetchGroupTrendingPodcast(for categories: [String], completion: @escaping (Result<[SearchedResult], NetworkError>) -> Void) {
        let dispatchGroup = DispatchGroup()
        var searchResult: [SearchedResult] = []
        
        for category in categories {
            dispatchGroup.enter()
            guard let url = createURL(for: .getTrendingPodcast, with: category) else { return }
            let request = getRequest(url)

            URLSession.shared.dataTask(with: request) { data, _, error in
                if let error = error {
                    completion(.failure(.transportError(error)))
                    dispatchGroup.leave()
                    return
                }
                
                guard let data = data else {
                    completion(.failure(.noData))
                    dispatchGroup.leave()
                    return
                }
                
                do {
                    let decodeData = try JSONDecoder().decode(SearchedResult.self, from: data)
                    searchResult.append(decodeData)
                    dispatchGroup.leave()
                } catch {
                    completion(.failure(.decodingError(error)))
                    dispatchGroup.leave()
                }
                
            }.resume()
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(.success(searchResult))
        }
        
    }
    
    /// Запрос списка категорий
    func fetchCategoryList(completion: @escaping (Result<SearchedResult, NetworkError>) -> Void) {
        guard let url = createURL(for: .getCategoryList, with: nil) else { return }
        let request = getRequest(url)
        makeTask(for: request, completion: completion)
    }
    
    /// Поиск подкастов по ключевым словам
    func searchPodcasts(with query: String, completion: @escaping (Result<SearchPodcats, NetworkError>) -> Void) {
        guard let url = createURL(for: .searchPodcasts, with: query) else { return }
        let request = getRequest(url)
        makeTask(for: request, completion: completion)
    }
    
    func fetchEpisodesForPodcast(with id: Int?, completion: @escaping (Result<SearchEpisods, NetworkError>) -> Void) {
        let idString = String(id ?? 0)
        guard let url = createURL(for: .getEpisodsForPodcats, with: idString) else { return }
        let request = getRequest(url)
        makeTask(for: request, completion: completion)
    }
    
}
