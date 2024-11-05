//
//  ViewController.swift
//  PersonalQuiz
//
//  Created by Ewgeniy Izyurov on 17.10.2024.
//

import UIKit

final class QuestionsViewController: UIViewController {
    //MARK: - IB Outlets
    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var questionProgressView: UIProgressView!
    
    @IBOutlet var singleStackView: UIStackView!
    @IBOutlet var singleButtons: [UIButton]!
    
    @IBOutlet var multipleStackView: UIStackView!
    @IBOutlet var multipleLabels: [UILabel]!
    @IBOutlet var multipleSwitches: [UISwitch]!
    
    @IBOutlet var rangeStackView: UIStackView!
    @IBOutlet var rangeLabels: [UILabel]!
    @IBOutlet var rangeSlider: UISlider!
    
    //MARK: - Private Properties
    private var questionIndex = 0
    private let questions = Question.getQuestions()
    private var answersChosen: [Answer] = []
    private var currentAnswers: [Answer] {
        questions[questionIndex].answers
    }
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        
        let answersCount = Float(currentAnswers.count - 1)
        rangeSlider.maximumValue = answersCount
        rangeSlider.value = answersCount / 2
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let resultVC = segue.destination as? ResultViewController
        
        resultVC?.answersUser = answersChosen
        
    }

    //MARK: - IB Actions
    @IBAction func singleQuestionButtonPressed(_ sender: UIButton) {
        guard let buttonIndex = singleButtons.firstIndex(of: sender) else {return}
        let currentAnswer = currentAnswers[buttonIndex]
        answersChosen.append(currentAnswer)
        
        nextQuestion()
    }
    
    @IBAction func multipleQuestionButtonPressed() {
        for (multipleSwitch, answer) in zip(multipleSwitches, currentAnswers) {
            if multipleSwitch.isOn {
                answersChosen.append(answer)
            }
        }
        
        nextQuestion()
    }
    
    @IBAction func rangeQuestionButtonPressed() {
        let index = lrintf(rangeSlider.value)
        answersChosen.append(currentAnswers[index])
        nextQuestion()
    }
    
}

// MARK: - Private Methods
private extension QuestionsViewController {
    func updateUI(){
        // Hide everything
        for stackView in [singleStackView, multipleStackView, rangeStackView] {
            stackView?.isHidden = true
        }
        
        // Set navigation title
        title = "Вопрос № \(questionIndex + 1) из \(questions.count)"
        
        //Get current question
        let currentQuestion = questions[questionIndex]
        
        // Set current question for label
        questionLabel.text = currentQuestion.title
        
        // Calculate progress
        let totalProgress = Float(questionIndex) / Float(questions.count)
        
        // Set progress for progressQuestionView
        questionProgressView.setProgress(totalProgress, animated: true)
        
        showCurrentAnswers(for: currentQuestion.type)
    }
    
    
    /// Choice of answers category
    ///
    /// Displaying answers to a question according to a category
    /// - Parameter type: Specifies the category of response
    func showCurrentAnswers(for type: ResponseType) {
        switch type {
        case .single:
            showSingleStackView(with: currentAnswers)
        case .multiple:
            showMultipleStackView(with: currentAnswers)
        case .ranged:
            showRangeStackView(with: currentAnswers)
        }
    }
    
    func showSingleStackView(with answers: [Answer]) {
        singleStackView.isHidden.toggle()
        
        for (button, answer) in zip(singleButtons, answers) {
            button.setTitle(answer.title, for: .normal)
        }
    }
    
    func showMultipleStackView(with answers: [Answer]) {
        multipleStackView.isHidden.toggle()
        
        for (label, answer) in zip(multipleLabels, answers) {
            label.text = answer.title
        }
    }
    
    func showRangeStackView(with answers: [Answer]) {
        rangeStackView.isHidden.toggle()
        
        rangeLabels.first?.text = answers.first?.title
        rangeLabels.last?.text = answers.last?.title
        
        
    }
    
    func nextQuestion() {
        questionIndex += 1
        
        if questionIndex < questions.count {
            updateUI()
            return
        }
        
        performSegue(withIdentifier: "showResult", sender: nil)
        
    }
}



