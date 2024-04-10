import Foundation

struct QuizResultsViewModel {
    let title: String
    let text: String
    let buttonText: String
    
    init(title: String = "Раунд окончен!",
         text: String,
         buttonText: String = "Сыграть еще раз") {
        self.title = title
        self.text = text
        self.buttonText = buttonText
    }
}
