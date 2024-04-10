import Foundation

final class StatisticServiceImplementation: StatisticService {
    
    private let userDefaults = UserDefaults.standard
    
    var totalAccuracy: Double {
        let total = userDefaults.double(forKey: Keys.total.rawValue)
        let correct = userDefaults.double(forKey: Keys.correct.rawValue)
        let accuracy = (correct / total) * 100
        return accuracy
    }
    
    var gamesCount: Int {
        get {
            userDefaults.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameRecord {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                  let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                return .init(correct: 0, total: 0, data: Date())
            }
            return record
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Impossible to store the result")
                return
            }
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    
    init() {
        if !areAllKeysPresent() {
            print("!!!")
            userDefaults.set(0, forKey: Keys.correct.rawValue)
            userDefaults.set(0, forKey: Keys.total.rawValue)
            userDefaults.set(0, forKey: Keys.gamesCount.rawValue)
            bestGame = GameRecord(correct: 0, total: 0, data: Date())
        }
    }
    
    func store(correct count: Int, total amount: Int) {
        let currentRecord = GameRecord(correct: count, total: amount, data: Date())
        if currentRecord.isBetter(than: bestGame) {
            bestGame = currentRecord
        }
        
        let savedCorrect = userDefaults.integer(forKey: Keys.correct.rawValue)
        userDefaults.set(count + savedCorrect, forKey: Keys.correct.rawValue)
        
        let savedTotal = userDefaults.integer(forKey: Keys.total.rawValue)
        userDefaults.set(amount + savedTotal, forKey: Keys.total.rawValue)
        
        let savedGamesCount = userDefaults.integer(forKey: Keys.gamesCount.rawValue)
        userDefaults.set(savedGamesCount + 1, forKey: Keys.gamesCount.rawValue)
    }
    
    private func areAllKeysPresent() -> Bool {
        for key in Keys.allCases {
            guard let _ = userDefaults.object(forKey: key.rawValue) else {
                return false
            }
        }
        return true
    }
    
    private enum Keys: String, CaseIterable {
        case correct, total, bestGame, gamesCount
    }
}
