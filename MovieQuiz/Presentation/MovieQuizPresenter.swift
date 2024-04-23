import UIKit

final class MovieQuizPresenter {
    // MARK: - Properties
    let questionsAmount = 10
    private var currentQuestionIndex = 0
    
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
