import Foundation

extension URLSession {
    func dataTask(for urlRequest: URLRequest) async throws -> (Data, URLResponse) {
        return try await withUnsafeThrowingContinuation {continuation in
            let task = self.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                } else if let data = data, let response = response {
                    continuation.resume(returning: (data, response))
                } else {
                    continuation.resume(throwing: URLError(.badServerResponse))
                    return
                }
            }
            Task {
                await withTaskCancellationHandler {
                    task.resume()
                } onCancel: {
                    task.cancel()
                    continuation.resume(throwing: URLError(.cancelled))
                }
            }
        }
    }
}
