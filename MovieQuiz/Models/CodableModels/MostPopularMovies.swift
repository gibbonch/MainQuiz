import Foundation

struct MostPopularMovies: Codable {
    let items: [Movie]
    let errorMessage: String
}

struct Movie: Codable {
    let title: String
    let rating: Float
    let imageURL: URL
    
    private enum CodingKeys: String, CodingKey {
        case title = "fullTitle"
        case rating = "imDbRating"
        case imageURL = "image"
    }
    
    private enum ParseError: Error {
        case ratingFalure, imageFailure
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        
        let rating = try container.decode(String.self, forKey: .rating)
        guard let ratingValue = Float(rating) else {
            throw ParseError.ratingFalure
        }
        self.rating = ratingValue
        
        let urlString = try container.decode(String.self, forKey: .imageURL)
        let imageUrlString = urlString.components(separatedBy: "._")[0] + "._V0_UX600_.jpg"
        guard let url = URL(string: imageUrlString) else {
            throw ParseError.imageFailure
        }
        self.imageURL = url
    }
}
