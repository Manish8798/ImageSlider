//
//  RequestManager.swift
//  ImageSlider
//
//  Created by Manish kumar on 19/12/24.
//

import Foundation


class RequestManager<T: Codable> {
    private lazy var sharedInstance: RequestManager<T> = {
        let instance = RequestManager<T>()
        return instance
    }()
    
    var shared: RequestManager<T> {
        return sharedInstance
    }
    // MARK: GET CAll
    func get(url: URL, headers: [String: String]?, completion: @escaping (Result<(T, Int), Error>) -> Void) {
        // Create a request
        var request = URLRequest(url: url)
        
        // Define the request method
        request.httpMethod = "GET"
        
        // Define the headers for the request
        request.allHTTPHeaderFields = headers
        
        // URLSession task
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
//            guard let data = data else {
//                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Data not found"])))
//                return
//            }
            
            guard let data = data, let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Data not found"])))
                return
            }
            
            do {
//                 if let responseString = String(data: data, encoding: .utf8) {
//                     print("RequestManager GET DATA:", responseString)
//                 }
                let decoder = JSONDecoder()
                let response = try decoder.decode(T.self, from: data)
                // Return both the response and the status code
                completion(.success((response, httpResponse.statusCode)))
                
            } catch let error {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    
    // MARK: PUT CALL
    func patch(url: URL, headers: [String: String]?, body: [String: Any], completion: @escaping (Result<(T, Int), Error>) -> Void) {
        // Create a request
        var request = URLRequest(url: url)
        
        // Define the request method
        request.httpMethod = "PATCH"
        
        // Define the headers for the request
        request.allHTTPHeaderFields = headers
        
        // Set the request body
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            completion(.failure(error))
            return
        }
        
        // URLSession task
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data, let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Data not found"])))
                return
            }
            
//            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
//                print("PATCH request Status Code:", statusCode)
//            }
            
            do {
                // Uncomment the following lines if you want to print the response data
                // if let responseString = String(data: data, encoding: .utf8) {
                //     print("PUT data: \(url) \(headers)", responseString)
                // }
                let decoder = JSONDecoder()
                let response = try decoder.decode(T.self, from: data)
                completion(.success((response, httpResponse.statusCode)))
            } catch let error {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    
    func delete(url: URL, headers: [String: String]?, completion: @escaping (Result<T, Error>) -> Void) {
        // Create a request
        var request = URLRequest(url: url)
        
        // Define the request method
        request.httpMethod = "DELETE"
        
        // Define the headers for the request
        request.allHTTPHeaderFields = headers
        
        // URLSession task
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Data not found"])))
                return
            }
            
            do {
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Delete data: \(url)", responseString)
                }
                let decoder = JSONDecoder()
                let response = try decoder.decode(T.self, from: data)
                completion(.success(response))
            } catch let error {
                completion(.failure(error))
            }
        }
        task.resume()
        
    }
    
    // MARK: POST CALL
    func post(url: URL, headers: [String: String]?, body: [String: Any]?, completion: @escaping (Result<T, Error>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        
        if let body = body {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            } catch {
                completion(.failure(error))
                return
            }
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Data not found"])))
                return
            }
            
            // Print response for debugging
            if let responseString = String(data: data, encoding: .utf8) {
                print("Response:", responseString)
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(T.self, from: data)
                completion(.success(response))
            } catch let error {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    // MARK: POST CALL WITHOUT BODY
    func post2(url: URL, headers: [String : String]? , completion: @escaping (Result<T, Error>) -> Void) {
        
        // create URL Request
        var request = URLRequest(url: url)
        
        // Define the call method
        request.httpMethod = "POST"
        
        // Set the Headers
        request.allHTTPHeaderFields = headers
        
        // URLSession Task
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Data not found"])))
                return
            }
            
            
            do {
//                if let responseString = String(data: data, encoding: .utf8) {
//                    print("POST data:", responseString)
//                }
                let decoder = JSONDecoder()
                
                let response = try decoder.decode(T.self, from: data)
                completion(.success(response))
            } catch let error {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    // MARK: PUT CALL
    
    func put(url: URL, headers: [String : String]? , body: [String : Any]?, completion: @escaping (Result<T, Error>) -> Void) {
        
        // create URL Request
        var request = URLRequest(url: url)
        
        // Define the call method
        request.httpMethod = "PUT"
        
        // Set the Headers
        request.allHTTPHeaderFields = headers
        
        // Handle the body
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: body ?? [], options: [])
            request.httpBody = jsonData
        } catch let error {
            completion(.failure(error))
            return
        }
        
        // URLSession Task
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Data not found"])))
                return
            }
            
            do {
//                if let responseString = String(data: data, encoding: .utf8) {
//                    print("\(url) PUT data:", responseString)
//                }
                let decoder = JSONDecoder()
                let response = try decoder.decode(T.self, from: data)
                completion(.success(response))
            } catch let error {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    
    // MARK: POST CALL WITH BODY AS String
    func postWithStringBody(url: URL, headers: [String : String]? , body: String, completion: @escaping (Result<T, Error>) -> Void) {
        
        // create URL Request
        var request = URLRequest(url: url)
        
        // Define the call method
        request.httpMethod = "POST"
        
        // Set the Headers
        request.allHTTPHeaderFields = headers
        
        // Handle the body
        request.httpBody = body.data(using: .utf8)
        
        // URLSession Task
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Data not found"])))
                return
            }
            
            do {
                //                if let responseString = String(data: data, encoding: .utf8) {
                //                    print("\(url) PUT data:", responseString)
                //                }
                let decoder = JSONDecoder()
                let response = try decoder.decode(T.self, from: data)
                completion(.success(response))
            } catch let error {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    
    // MARK: Create Journal POST call
    func createJournal(noteId: Int? , journalEntryCopy: [String: Any] ) async -> [String: Any]{
        let params: [String: Any] = [
            "note": noteId ?? "",
            "content": journalEntryCopy,
            "is_done": true
        ]
        
        let url = URL(string: "usernotes/")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer ", forHTTPHeaderField: "Authorization")
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: params)
            request.httpBody = jsonData
            let (data, _) = try await URLSession.shared.data(for: request)
            let newFormat = try JSONSerialization.jsonObject(with: data) as? [String: Any] ?? [:]
            // Handle response...
            return newFormat
        } catch {
            // Handle error...
            return ["error": error]
        }
    }
    
    
}
