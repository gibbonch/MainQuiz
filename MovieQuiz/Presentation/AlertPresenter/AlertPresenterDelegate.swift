import UIKit

protocol AlertPresenterDelegate: AnyObject {
    func didAletCompleted()
    func present(_ viewControllerToPresent: UIViewController, 
                 animated flag: Bool,
                 completion: (() -> Void)?)
}
