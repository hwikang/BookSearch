//
//  Network.swift
//  BookSearch
//
//  Created by 강휘 on 2022/11/30.
//

import Foundation
import Combine

final class NetworkManager {
    
    private let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    func fetchData<T:Decodable> (url: String, dataType: T.Type, completion: @escaping ((Result<T,Error>) -> Void)){

         guard let url = URL(string: url) else {
             completion(.failure(NetworkError.urlError))
             return 
         }
         session.dataTask(with: url) { (data, response, error) in
             if let error = error {  completion(.failure(error)); return }
             guard let data = data else { completion(.failure(NetworkError.dataNil)); return }
             guard let response =  response as? HTTPURLResponse else { completion(.failure(NetworkError.invalid)); return }
             if 200..<400 ~= response.statusCode {
                 do {
                     let data = try JSONDecoder().decode(T.self, from: data)
                     completion(.success(data))
                 } catch {
                     completion(.failure(NetworkError.failToDecode(error.localizedDescription)))
                 }
             }else {
                 completion(.failure(NetworkError.serverError(response.statusCode)))
             }
         }.resume()
         
     }
}
