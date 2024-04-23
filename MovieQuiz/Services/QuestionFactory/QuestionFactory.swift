import Foundation

final class QuestionFactory: QuestionFactoryProtocol {
    private weak var delegate: QuestionFactoryDelegate?
    private let moviesLoader: MoviesLoading?
    private var movies: [Movie] = []

    init(moviesLoader: MoviesLoading?, delegate: QuestionFactoryDelegate?) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    
    func loadData() {
        moviesLoader?.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let mostPopularMovies):
                    self?.movies = mostPopularMovies.items
                    self?.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self?.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
    
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            let index = (0..<self.movies.count).randomElement() ?? 0
            guard let movie = self.movies[safe: index] else { return }
            
            var imageData = Data()
            do {
                imageData = try Data(contentsOf: movie.imageURL)
            } catch {
                DispatchQueue.main.async { [weak self] in
                    self?.delegate?.didFailToLoadImage()
                }
            }
            
            guard let lessOrMore = ["больше", "меньше"].randomElement() else { return }
            let text = "Рейтинг этого фильма \(lessOrMore) чем 8.1?"
            
            let rating = Float(movie.rating)
            let correctAnswer = lessOrMore == "больше" ? rating >= 8.1 : rating < 8.1
            
            DispatchQueue.main.async { [weak self] in
                let question = QuizQuestion(image: imageData, text: text, correctAnswer: correctAnswer)
                self?.delegate?.didReceiveNextQuestion(question: question)
            }
        }
    }
}
