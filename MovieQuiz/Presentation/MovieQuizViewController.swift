import UIKit

final class MovieQuizViewController: UIViewController {
    
    // MARK: -  UI Elements
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var noButton: UIButton!
    
    // MARK: - Properties
    
    private var correctAnswers = 0
    private var currentQuestionIndex = 0
    private let questionsAmount = 10
    private var currentQuestion: QuizQuestion?
    private var isLastQuestion: Bool {
        return currentQuestionIndex == questionsAmount - 1
    }
    
    private var questionFactory: QuestionFactoryProtocol?
    private var alertPresenter: AlertPresenter?
    
    
    // MARK: - Lifecicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionFactory = QuestionFactory(delegate: self)
        questionFactory?.requestNextQuestion()
        
        alertPresenter = AlertPresenter(delegate: self)
    }
    
    // MARK: - Actions
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        let givenAnswer = true
        guard let currentQuestion else { return }
        let correctAnswer = currentQuestion.correctAnswer
        
        showAnswerResult(isCorrect: givenAnswer == correctAnswer)
    }
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        let givenAnswer = false
        guard let currentQuestion else { return }
        let correctAnswer = currentQuestion.correctAnswer
        
        showAnswerResult(isCorrect: givenAnswer == correctAnswer)
    }
    
    // MARK: - Methods
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(image: UIImage(named: model.image) ?? UIImage(),
                                             question: model.text,
                                             quesionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        return questionStep
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.quesionNumber
        
        imageView.layer.borderColor = UIColor.ypBlack.cgColor
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
            imageView.layer.borderColor = UIColor.ypGreen.cgColor
        } else {
            imageView.layer.borderColor = UIColor.ypRed.cgColor
        }
        
        lockButtons()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.showNextQuestionOrResult()
        }
    }
    
    private func showNextQuestionOrResult() {
        if isLastQuestion {
            let text = "Ваш результат: \(correctAnswers)/10"
            let completion: () -> Void = { [weak self] in
                self?.currentQuestionIndex = 0
                self?.correctAnswers = 0
                self?.questionFactory?.requestNextQuestion()
            }
            
            let model = AlertModel(title: "Раунд окончен!",
                                   message: text,
                                   buttonText: "Сыграть еще раз",
                                   completion: completion)
            
            alertPresenter?.show(alert: model)
        } else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
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

extension MovieQuizViewController: QuestionFactoryDelegate {
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question else {
            return
        }
        
        let viewModel = convert(model: question)
        currentQuestion = question
        
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
}

