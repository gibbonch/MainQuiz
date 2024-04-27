import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    
    // MARK: -  Outlets
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    private var presenter: MovieQuizPresenter!
    private var alertPresenter: AlertPresenter!
    
    // MARK: - Lifecicle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = MovieQuizPresenter(viewController: self)
        alertPresenter = AlertPresenter()
    }
    
    // MARK: - IBAction Methods
    @IBAction private func yesButtonClicked(_ sender: Any) {
        lockButtons()
        presenter.yesButtonClicked()
    }
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        lockButtons()
        presenter.noButtonClicked()
    }
    
    // MARK: - Methods
    func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        imageView.layer.borderColor = UIColor.ypBlack.cgColor
        
        hideLoadingIndicator()
        unlockButtons()
    }
    
    func showNetworkError(message: String, handler: @escaping () -> Void) {
        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать ещё раз",
                               completion: handler)
        
        alertPresenter.show(alert: model, in: self)
    }
    
    func showQuizStatistic() {
        let message = presenter.makeResultsMessage()
        
        let model = AlertModel(title: "Раунд окончен!",
                               message: message,
                               buttonText: "Сыграть ещё раз") { [weak self] in
            self?.showLoadingIndicator()
            self?.presenter.restartGame()
        }
        alertPresenter.show(alert: model, in: self)
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
           imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
       }
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
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
