import YasumidokiCore

enum YasumidokiStoreFactory {
    static func makeStore() -> any YasumidokiStore {
        do {
            return try FileBackedYasumidokiStore.defaultStore()
        } catch {
            return InMemoryYasumidokiStore()
        }
    }
}
