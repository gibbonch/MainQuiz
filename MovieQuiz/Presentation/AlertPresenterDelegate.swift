import UIKit

protocol AlertPresenterDelegate: AnyObject {
    func didRecieveAlert(_ alert: UIAlertController)
}
