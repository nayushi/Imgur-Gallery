//
//  API.swift
//  Imgur Gallery
//
//  Created by Mariana Brasil on 03/09/21.
//

import UIKit

public enum Result<Value> {
    case success(Value)
    case failure(Error)
}

public class ImagesAPIClient {
    
    // MARK: - Properties
    private let endpointURL = URL(string: "https://api.imgur.com/3/gallery/hot/viral/0")!
    var linkArray: [String] = []
    private let session: URLSession
    
    // MARK: - Lifecycle
    public init(session: URLSession = URLSession(configuration: .default)) {
        self.session = session
    }
    
    class DictionaryDecoder {
        private let jsonDecoder = JSONDecoder()
        
        func decode<T>(_ type: T.Type, from json: Any) throws -> T where T: Decodable {
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
            return try jsonDecoder.decode(type, from: jsonData)
        }
    }
    
    // MARK: - Methods
    public func fetchImages(completion: @escaping (_ result: Result<[String]>) -> Void) {
        
        var request = URLRequest(url: endpointURL)
        request.setValue("Bearer \(AppKeys.sharedInfo.accessToken)", forHTTPHeaderField: "Authorization")
        let task = session.dataTask(with: request) { data, response, error in
            
            if (response as? HTTPURLResponse) != nil {
                if let data = data, let _ = String(data: data, encoding: .utf8) {
                    do {
                        let decodedSentences = try JSONDecoder().decode(FirstData.self, from: data)
                        
                        for element in decodedSentences.data {
                            if let unwrappedImages = element.images {
                                for image in unwrappedImages {
                                    self.linkArray.append(image.link)
                                }
                            }
                        }
                        DispatchQueue.main.async {
                            completion(.success(self.linkArray))
                        }
                    } catch {
                        DispatchQueue.main.async {
                            completion(.failure(error))
                        }
                    }
                } else if let error = error {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        }
        task.resume()
    }
}
