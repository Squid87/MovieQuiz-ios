//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Илья Тананыхин on 18.04.2023.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)    
}
