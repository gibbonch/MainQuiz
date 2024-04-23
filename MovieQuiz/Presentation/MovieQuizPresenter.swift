import UIKit

final class MovieQuizPresenter {
    // MARK: - Properties
    weak var viewController: MovieQuizViewController?
    
    // State of Quiz
    var currentQuestion: QuizQuestion?
    let questionsAmount = 10
    private var currentQuestionIndex = 0
    
    // MARK: - Action Methods
    func yesButtonClicked() {
        guard let currentQuestion else {
            return
        }
        viewController?.lockButtons()
        let givenAnswer = true
        viewController?.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    func noButtonClicked() {
        guard let currentQuestion else {
            return
        }
        viewController?.lockButtons()
        let givenAnswer = false
        viewController?.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    // MARK: - Methods
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(image: UIImage(data: model.image) ?? UIImage(),
                          question: model.text,
                          quesionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
}
