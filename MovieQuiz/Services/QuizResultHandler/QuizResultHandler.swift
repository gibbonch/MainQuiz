import Foundation

class QuizResultHandler {
    private weak var statisticService: StatisticService?
    
    init(statisticService: StatisticService? = nil) {
        self.statisticService = statisticService
    }
    
    func handleQuizResult(_ correctAnswers: Int, _ questionsAmount: Int) -> QuizResultsViewModel {
        guard let statisticService else { return QuizResultsViewModel(text: "")}
        
        let message = """
                Ваш результат: \(correctAnswers)/\(questionsAmount)
                Количество сыгранных квизов: \(statisticService.gamesCount)
                Рекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) (\(Date().dateTimeString))
                Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%
        """
        
        let resultModel = QuizResultsViewModel(text: message)
        
        return resultModel
    }

    
}
