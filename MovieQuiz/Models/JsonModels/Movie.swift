import Foundation

struct Movie: Codable {
    let id: String
    let rank: Int
    let title: String
    let fullTitle: String
    let year: Int
    let image: String
    let crew: String
    let imDbRating: Double
    let imDbRatingCount: Int
    
    enum CodingKeys: CodingKey {
        case id, rank, title, fullTitle, year, image, crew, imDbRating, imDbRatingCount
    }
    
    enum ParseError: Error {
        case rankFailure
        case yearFailure
        case imDbRatingFailure
        case imDbRatingCountFailure
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.fullTitle = try container.decode(String.self, forKey: .fullTitle)
        self.image = try container.decode(String.self, forKey: .image)
        self.crew = try container.decode(String.self, forKey: .crew)
        
        let rank = try container.decode(String.self, forKey: .rank)
        guard let rankValue = Int(rank) else {
            throw ParseError.rankFailure
        }
        self.rank = rankValue
        
        let year = try container.decode(String.self, forKey: .year)
        guard let yearValue = Int(year) else {
            throw ParseError.yearFailure
        }
        self.year = yearValue
        
        let imDbRating = try container.decode(String.self, forKey: .imDbRating)
        guard let imDbRatingValue = Double(imDbRating) else {
            throw ParseError.imDbRatingFailure
        }
        self.imDbRating = imDbRatingValue
        
        let imDbRatingCount = try container.decode(String.self, forKey: .imDbRatingCount)
        guard let imDbRatingCountValue = Int(imDbRatingCount) else {
            throw ParseError.imDbRatingCountFailure
        }
        self.imDbRatingCount = imDbRatingCountValue
    }
}
