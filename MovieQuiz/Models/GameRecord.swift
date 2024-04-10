import Foundation

struct GameRecord: Codable {
    let correct: Int
    let total: Int
    let data: Date
    
    func isBetter(than gameRecord: GameRecord) -> Bool {
        return self.correct > gameRecord.correct
    }
}
