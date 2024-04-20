import UIKit

struct AlertPresenter {
    func show(alert model: AlertModel, in controller: UIViewController) {
        guard let completion = model.completion else {
            return
        }
        let alert = UIAlertController(title: model.title,
                                      message: model.message,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: model.buttonText, style: .default) { _ in
            completion()
        }
        alert.addAction(action)
        controller.present(alert, animated: true, completion: nil)
    }
}
