import SwiftUI
import CocoaLumberjack

@main
struct ToDoListOfYandex_SMDApp: App {
    init() {
        log()
    }
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
    private func log() {
        DDLog.add(DDOSLogger.sharedInstance)
        let fileLogger: DDFileLogger = DDFileLogger()
        fileLogger.rollingFrequency = TimeInterval(60 * 60 * 24)
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7
        DDLog.add(fileLogger)
        print("Логи начали успешно записываться")
    }
}
