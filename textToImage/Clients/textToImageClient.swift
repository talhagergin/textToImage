//
//  textToImageClient.swift
//  textToImage
//
//  Created by Talha Gergin on 9.01.2025.
//
import Foundation
enum NetworkError: Error{
    case badUrl
    case badRequest
    case invalidResponse
    case decodingerror
}
struct textToImageClient {

    func postLeaguesByCountry(requestBody: String) async throws -> String {
        guard let url = URL(string: APIEndpoint.baseURL) else {
            throw NetworkError.badUrl
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = APIEndpoint.headers
        
        // JSON payload for POST request
        
         let requestBody: [String: Any] = [
             "text": requestBody,
             "width": 512,
             "height": 512,
             "steps": 1
         ]
         
         // Convert the requestBody to JSON data
         let jsonData = try JSONSerialization.data(withJSONObject: requestBody, options: [])
         
         // Attach the body to the request
         request.httpBody = jsonData
         
         let (data, response) = try await URLSession.shared.data(for: request)

         if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
             throw NetworkError.badRequest
         }

         // Parse the response
         let responseJson = try JSONDecoder().decode([String: String].self, from: data)
         
         // Extract the generated image URL from the response
         if let generatedImageUrl = responseJson["generated_image"] {
             return generatedImageUrl
         } else {
             throw NetworkError.invalidResponse
         }
     }
 }
