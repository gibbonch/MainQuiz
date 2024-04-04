import UIKit

class AlertPresenter {
    weak var delegate: MovieQuizViewController?
    
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
        
        delegate?.present(alert, animated: true, completion: nil)
    }
}
