import Foundation

actor RevisionManager {
    private var revision: Int = 1
    
    func getRevision() -> Int {
        return revision
    }
    
    func updateRevision(_ newRevision: Int) {
        revision = newRevision
    }
}
