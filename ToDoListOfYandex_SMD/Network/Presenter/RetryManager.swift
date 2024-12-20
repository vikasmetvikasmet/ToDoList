import Foundation
import CocoaLumberjackSwift

struct RetryCongig {
    let minDelay: TimeInterval
    let maxDelay: TimeInterval
    let factor: Double
    let jitter: Double
}
actor RetryManager {
    private var retryConfig: RetryCongig
    private var currentDelay: TimeInterval
    
    init(retryConfig: RetryCongig) {
        self.retryConfig = retryConfig
        self.currentDelay = retryConfig.minDelay
    }
    
    func executedWithRetry<T: Sendable>(operation: @escaping () async throws -> T) async throws -> T {
        while true {
            do {
                let result = try await operation()
            } catch {
                DDLogVerbose("\(Date()): Операция не удалась, повторная попытка через \(nextDelay) секунд. Ошибка \(error)")
                try await Task.sleep(nanoseconds: UInt64(nextDelay * 1_000_000_000))
                
            }
        }
        
    }
    private var nextDelay: TimeInterval {
        let jitterValue =  Double.random(in: 0..<retryConfig.jitter * 2) - retryConfig.jitter
        let delayWithJitter = currentDelay * (1 + jitterValue)
        currentDelay = min(currentDelay * retryConfig.factor, retryConfig.maxDelay)
        return delayWithJitter
    }
}
