import UIKit

// MARK: - Creates an alert and delegates its presentation to MovieQuizVC

class AlertPresenter {
    private weak var delegate: AlertPresenterDelegate?
    
    init(delegate: AlertPresenterDelegate) {
        self.delegate = delegate
    }
    
    func show(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(title: result.title,
                                      message: result.text,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self]_ in
            self?.delegate?.didAletCompleted()
        }
        alert.addAction(action)
        
        DispatchQueue.main.async { [weak delegate] in
            delegate?.present(alert, animated: true, completion: nil)
        }
    }
}
