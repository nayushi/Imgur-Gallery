import UIKit

public enum Result<Value> {
    case success(Value)
    case failure(Error)
}


public class ImagesAPIClient {
    
    // MARK: - Properties
    private let endpointURL = URL(string: "https://api.imgur.com/3/gallery/hot/viral/0")!
    
    private let session: URLSession
    
    // MARK: - Life Cycle
    public init(session: URLSession = URLSession(configuration: .default)) {
        self.session = session
    }
    
    class DictionaryDecoder {
        private let jsonDecoder = JSONDecoder()

        /// Decodes given Decodable type from given array or dictionary
        func decode<T>(_ type: T.Type, from json: Any) throws -> T where T: Decodable {
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
            return try jsonDecoder.decode(type, from: jsonData)
        }
    }
    
    // MARK: - Methods
    public func fetchImages(completion: @escaping (_ result: Result<FirstData>) -> Void) {
        
        var request = URLRequest(url: endpointURL)
        
        request.setValue("Bearer \(AppKeys.sharedInfo.accessToken)", forHTTPHeaderField: "Authorization")
        
        let task = session.dataTask(with: request) { data, response, error in
            
            if let httpResponse = response as? HTTPURLResponse {
                
                
                if var data = data, let stringResponse = String(data: data, encoding: .utf8) {
           
                   
                    do {
                  
                        let decodedSentences = try JSONDecoder().decode(FirstData.self, from: data)
     
                        print(decodedSentences)
                        
                       
          
                        DispatchQueue.main.async {
                            completion(.success(decodedSentences))
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

extension String {
    func toJSON() -> Any? {
        guard let data = self.data(using: .utf8, allowLossyConversion: false) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    }
}
