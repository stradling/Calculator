//
//  ViewController.swift
//  Calculator
//
//  Created by Alden Stradling on 6/1/15.
//  Copyright (c) 2015 Alden Stradling. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    
    var userIsInTheMiddleOfTypingANumber = false

    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        println("digit = \(digit)")
        if userIsInTheMiddleOfTypingANumber {
            display.text = display.text! + digit
        } else {
            display.text =  digit
            userIsInTheMiddleOfTypingANumber = true
        }

    }

    @IBAction func Operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber{
            enter()
        }
        switch operation {
            case "×": performOperation {$0 * $1}
            case "÷": performOperation {$1 / $0}
            case "+": performOperation {$0 + $1}
            case "−": performOperation {$1 - $0}
            default: break
        }
        
    }
   
    func performOperation(operation:(Double, Double) -> Double) {
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
            
    }
    var operandStack = Array<Double>()
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        operandStack.append(displayValue)
        println("operandStack = \(operandStack)")
    }
    
    var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
        }
    }
}





// Characters reference
// +−÷×
//→π√␡⏎±
//sin cos tan