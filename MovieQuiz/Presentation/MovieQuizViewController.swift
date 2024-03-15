import UIKit

final class MovieQuizViewController: UIViewController {
    // MARK: - Mock data
    
    private let questions: [QuizQuestion] = [
        QuizQuestion(image: "The Godfather",
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: true),
        QuizQuestion(image: "The Dark Knight",
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: true),
        QuizQuestion(image: "Kill Bill",
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: true),
        QuizQuestion(image: "The Avengers",
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: true),
        QuizQuestion(image: "Deadpool",
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: true),
        QuizQuestion(image: "The Green Knight",
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: true),
        QuizQuestion(image: "Old",
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: false),
        QuizQuestion(image: "The Ice Age Adventures of Buck Wild",
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: false),
        QuizQuestion(image: "Tesla",
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: false),
        QuizQuestion(image: "Vivarium",
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: false),
    ]
    
    // MARK: -  Properties
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var noButton: UIButton!
    
    private var isLastQuestion: Bool {
        return currentQuestionIndex == questions.count - 1
    }
    
    // MARK: - Lifecicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ImageView setup
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
        
        // Display first question
        let viewModel = convert(model: questions[currentQuestionIndex])
        show(quiz: viewModel)
    }
    
    // MARK: - Methods
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        let givenAnswer = true
        let correctAnswer = questions[currentQuestionIndex].correctAnswer
        
        showAnswerResult(isCorrect: givenAnswer == correctAnswer)
    }
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        let givenAnswer = false
        let correctAnswer = questions[currentQuestionIndex].correctAnswer
        
        showAnswerResult(isCorrect: givenAnswer == correctAnswer)
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(image: UIImage(named: model.image) ?? UIImage(),
                                             question: model.text,
                                             quesionNumber: "\(currentQuestionIndex + 1)/\(questions.count)")
        return questionStep
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.quesionNumber
        
        imageView.layer.borderColor = UIColor.ypBlack.cgColor
    }
    
    private func show(quiz result: QuizResulsViewModel) {
        let alert = UIAlertController(title: result.title,
                                      message: result.text,
                                      preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            
            let viewModel = self.convert(model: self.questions[self.currentQuestionIndex])
            self.show(quiz: viewModel)
        }
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        lockButtons()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResult()
        }
    }
    
    private func showNextQuestionOrResult() {
        if isLastQuestion {
            let text = "Ваш результат: \(correctAnswers)/10"
            let viewModel = QuizResulsViewModel(title: "Раунд окончен!", 
                                                text: text,
                                                buttonText: "Сыграть еще раз")
            show(quiz: viewModel)
        } else {
            currentQuestionIndex += 1
            let viewModel = convert(model: questions[currentQuestionIndex])
            show(quiz: viewModel)
        }
        
        unlockButtons()
    }
    
    private func lockButtons() {
        yesButton.isUserInteractionEnabled = false
        noButton.isUserInteractionEnabled = false
    }
    
    private func unlockButtons() {
        yesButton.isUserInteractionEnabled = true
        noButton.isUserInteractionEnabled = true
    }
}

// MARK: - Models

fileprivate struct QuizQuestion {
    let image: String
    let text: String
    let correctAnswer: Bool
}

fileprivate struct QuizStepViewModel {
    let image: UIImage
    let question: String
    let quesionNumber: String
}

fileprivate struct QuizResulsViewModel {
    let title: String
    let text: String
    let buttonText: String
}

