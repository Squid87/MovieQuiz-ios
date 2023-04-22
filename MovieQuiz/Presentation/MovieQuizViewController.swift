    import UIKit

    final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {

        // переменная с индексом текущего вопроса,
        private var currentQuestionIndex: Int = 0
        // переменная со счётчиком правильных ответов
        private var correctAnswers: Int = 0
        private let questionsAmount: Int = 10
        private var questionFactory: QuestionFactoryProtocol?
        private var currentQuestion: QuizQuestion?
        private var alertModel: AlertModel?
        private var alertPresenter: AlertPresenter?
        

        
        
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
        questionFactory = QuestionFactory(delegate: self)
        alertPresenter = AlertPresenter()
        questionFactory?.requestNextQuestion()
    }

    @IBAction private func yesButtonClicked(_ sender: Any) {
        // берём текущий вопрос из массива вопросов по индексу текущего вопроса
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = true
        self.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }

    @IBAction private func noButtonClicked(_ sender: Any) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = false
        self.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }

    // приватный метод вывода на экран вопроса, который принимает на вход вью модель вопроса
    private func show(quiz step: QuizStepViewModel) {
        textLabel.text = step.question
        imageView.image = step.image
        counterLabel.text = step.questionNumber
        
    }

    // приватный метод, который меняет цвет рамки
    // принимает на вход булевое значение
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
        if currentQuestionIndex == questionsAmount - 1 {
            
            let alert1 = AlertModel(
                title: "Этот раунд закончен",
                message: "Вы ответили на \(correctAnswers) из 10, попробуйте ещё раз!",
                buttonText: "Сыграть ещё раз",
                completion: {[weak self] in
                    self?.correctAnswers = 0
                    self?.currentQuestionIndex = 0
                    self?.questionFactory?.requestNextQuestion()
                    })
            alertPresenter?.showAlert(viewController: self, model: alert1)
            
        } else {
            currentQuestionIndex += 1
            
            questionFactory?.requestNextQuestion()
        }
    }
        
        // MARK: - QuestionFactoryDelegate

        func didReceiveNextQuestion(question: QuizQuestion?) {
            guard let question = question else {
                return
            }
            
            currentQuestion = question
            let viewModel = convert(model: question)
            DispatchQueue.main.async { [weak self] in
                self?.show(quiz: viewModel)
            }
        }
        
    // метод конвертации, который принимает моковый вопрос и возвращает вью модель для экрана вопроса
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
            return questionStep
    }

}








