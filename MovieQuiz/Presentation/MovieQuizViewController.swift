import UIKit

final class MovieQuizViewController: UIViewController {
    
    // MARK: -  Outlets
    
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
    
    // Services
    private var questionFactory: QuestionFactoryProtocol?
    private var alertPresenter: AlertPresenter?
    private var statisticService: StatisticService?
    
    // MARK: - Lifecicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionFactory = QuestionFactory(delegate: self)
        alertPresenter = AlertPresenter(delegate: self)
        statisticService = StatisticServiceImplementation()
        questionFactory?.requestNextQuestion()
    }
    
    // MARK: - Actions
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        let givenAnswer = true
        guard let currentQuestion else { return }
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        let givenAnswer = false
        guard let currentQuestion else { return }
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    // MARK: - Methods
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(image: UIImage(named: model.image) ?? UIImage(),
                          question: model.text,
                          quesionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
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
        yesButton.isUserInteractionEnabled = false
        noButton.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.showNextQuestionOrResult()
        }
    }
    
    private func showNextQuestionOrResult() {
        if isLastQuestion {
            statisticService?.store(correct: correctAnswers, total: questionsAmount)
            let result = handleQuizResult()
            alertPresenter?.show(quiz: result)
        } else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
        }
        yesButton.isUserInteractionEnabled = true
        noButton.isUserInteractionEnabled = true
    }
    
    private func handleQuizResult() -> QuizResultsViewModel {
        guard let statisticService else {
            return QuizResultsViewModel(text: "")
        }
        let message = """
                Ваш результат: \(correctAnswers)/\(questionsAmount)
                Количество сыгранных квизов: \(statisticService.gamesCount)
                Рекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) (\(statisticService.bestGame.date.dateTimeString))
                Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%
        """
        return QuizResultsViewModel(text: message)
    }
    
}

// MARK: - MovieQuizViewController Extensions

extension MovieQuizViewController: QuestionFactoryDelegate {
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question else { return }
        let viewModel = convert(model: question)
        currentQuestion = question
        
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
}

extension MovieQuizViewController: AlertPresenterDelegate {
    func didAletCompleted() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }
}
