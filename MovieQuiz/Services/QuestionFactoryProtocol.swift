//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by Илья Тананыхин on 17.04.2023.
//

import Foundation

protocol QuestionFactoryProtocol {
    func requestNextQuestion() -> QuizQuestion?
}
