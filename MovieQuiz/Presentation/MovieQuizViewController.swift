    import UIKit

    final class MovieQuizViewController: UIViewController {

    // переменная с индексом текущего вопроса,
    private var currentQuestionIndex: Int = 0
    // переменная со счётчиком правильных ответов
    private var correctAnswers: Int = 0

    //вывод картинки
    @IBOutlet weak private var imageView: UIImageView!
    //вывод текста
    @IBOutlet private weak var textLabel: UILabel!
    //вывод текущего номера вопроса
    @IBOutlet private weak var counterLabel: UILabel!
    
    //свойства кнопоки да
    @IBOutlet weak private var yesButtonOutlet: UIButton!
    //свойства кнопоки нет
    @IBOutlet weak private var noButtonOutlet: UIButton!
        
        
        
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        show(quiz: convert(model: questions[currentQuestionIndex]))
    }

    @IBAction private func yesButtonClicked(_ sender: Any) {
        // берём текущий вопрос из массива вопросов по индексу текущего вопроса
        let currentQuestion = questions[currentQuestionIndex]
        let givenAnswer = true
        self.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }

    @IBAction private func noButtonClicked(_ sender: Any) {
        let currentQuestion = questions[currentQuestionIndex]
        let givenAnswer = false
        self.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }

    // приватный метод вывода на экран вопроса, который принимает на вход вью модель вопроса и ничего не возвращает
    private func show(quiz step: QuizStepViewModel) {
        textLabel.text = step.question
        imageView.image = step.image
        counterLabel.text = step.questionNumber
        
    }

    // приватный метод, который меняет цвет рамки
    // принимает на вход булевое значение и ничего не возвращает
    private func showAnswerResult(isCorrect: Bool) {
        
        yesButtonOutlet.isEnabled = false
        noButtonOutlet.isEnabled = false
        if isCorrect {
                correctAnswers += 1
            }
       // метод красит рамку
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor: UIColor.ypRed.cgColor
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
        } 
        yesButtonOutlet.isEnabled = true
        noButtonOutlet.isEnabled = true
    }

    // приватный метод, который содержит логику перехода в один из сценариев
    // метод ничего не принимает и ничего не возвращает
    private func showNextQuestionOrResults() {
        imageView.layer.borderColor = UIColor.clear.cgColor //перекрасили рамку в белый
        // идём в состояние "Результат квиза"
        if currentQuestionIndex == questions.count - 1 {
            let text = "Ваш результат: \(correctAnswers)/10"
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз")
            show(quiz: viewModel)
        } else {
            currentQuestionIndex += 1
            let nextQuestion = questions[currentQuestionIndex]
            let viewModel = convert(model: nextQuestion)
            
            show(quiz: viewModel)
        }
    }
        
    // метод конвертации, который принимает моковый вопрос и возвращает вью модель для экрана вопроса
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
      // Попробуйте написать код конвертации самостоятельно
        let questionStep = QuizStepViewModel( // 1
                image: UIImage(named: model.image) ?? UIImage(), // 2
                question: model.text, // 3
                questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)") // 4
            return questionStep
    }

    // приватный метод для показа результатов раунда квиза
    // принимает вью модель QuizResultsViewModel и ничего не возвращает
    private func show(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
            guard let self = self else {return}
            
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            
            let firstQuestion = self.questions[self.currentQuestionIndex]
            let viewModel = self.convert(model: firstQuestion)
            self.show(quiz: viewModel)
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
}








