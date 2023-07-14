//
//  URLSessionExt.swift
//  ToDoList
//
//  Created by Элина Борисова on 07.07.2023.
//

import Foundation

extension URLSession {
    func dataTask(for urlRequest: URLRequest) async throws -> (Data, URLResponse) {
        return try await withCheckedThrowingContinuation { continuation in
            let task = self.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let data = data, let response = response {
                    continuation.resume(returning: (data, response))
                } else {
                    let unknownError = NSError(domain: "error", code: 0, userInfo: nil)
                    continuation.resume(throwing: unknownError)
                }
            }
            task.resume()
            if Task.isCancelled {
                task.cancel()
            }
        }
    }
}
