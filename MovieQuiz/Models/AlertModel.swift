//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Илья Тананыхин on 22.04.2023.
//

import Foundation
import UIKit

struct AlertModel{
    let title: String
    let message :String
    let buttonText: String
    let completion: () -> Void
}