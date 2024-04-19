import Foundation

final class StatisticServiceImplementation: StatisticService {
    private enum Keys: String, CaseIterable {
        case correct, total, bestGame, gamesCount
    }
    
    private let defaults = UserDefaults.standard
    
    var totalAccuracy: Double {
        let total = defaults.double(forKey: Keys.total.rawValue)
        let correct = defaults.double(forKey: Keys.correct.rawValue)
        let accuracy = (correct / total) * 100
        return accuracy
    }
    
    var gamesCount: Int {
        get {
            defaults.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            defaults.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameRecord {
        get {
            guard let data = defaults.data(forKey: Keys.bestGame.rawValue),
                  let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                return .init(correct: 0, total: 0, date: Date())
            }
            return record
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Impossible to store the result")
                return
            }
            defaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    
    init() {
        guard !areAllKeysPresent() else { return }
        defaults.set(0, forKey: Keys.correct.rawValue)
        defaults.set(0, forKey: Keys.total.rawValue)
        defaults.set(0, forKey: Keys.gamesCount.rawValue)
        bestGame = GameRecord(correct: 0, total: 0, date: Date())
    }
    
    func store(correct count: Int, total amount: Int) {
        let currentRecord = GameRecord(correct: count, total: amount, date: Date())
        if currentRecord.isBetter(than: bestGame) {
            bestGame = currentRecord
        }
        
        let savedCorrect = defaults.integer(forKey: Keys.correct.rawValue)
        defaults.set(count + savedCorrect, forKey: Keys.correct.rawValue)
        
        let savedTotal = defaults.integer(forKey: Keys.total.rawValue)
        defaults.set(amount + savedTotal, forKey: Keys.total.rawValue)
        
        let savedGamesCount = defaults.integer(forKey: Keys.gamesCount.rawValue)
        defaults.set(savedGamesCount + 1, forKey: Keys.gamesCount.rawValue)
    }
    
    private func areAllKeysPresent() -> Bool {
        for key in Keys.allCases {
            guard let _ = defaults.object(forKey: key.rawValue) else {
                return false
            }
        }
        return true
    }
}
