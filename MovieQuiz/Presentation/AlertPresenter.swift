import UIKit

// MARK: - Creates an alert and delegates its presentation to AlertPresenterDelegate (MovieQuizVC)

class AlertPresenter {
    weak var delegate: AlertPresenterDelegate?
    
    init(delegate: MovieQuizViewController?) {
        self.delegate = delegate
    }
    
    func show(alert model: AlertModel) {
        let alert = UIAlertController(title: model.title,
                                      message: model.message,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: model.buttonText, style: .default) { _ in
            model.completion()
        }
        alert.addAction(action)
        
        delegate?.didRecieveAlert(alert)
    }
}
