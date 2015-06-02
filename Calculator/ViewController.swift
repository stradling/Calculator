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
    var inputHasADecimal = false

    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        println("digit = \(digit)")
        if digit == "." && inputHasADecimal {
            // Do nothing. Disallowed.
        } else {
            if digit == "." { inputHasADecimal = true }
            if userIsInTheMiddleOfTypingANumber {
                display.text = display.text! + digit
            } else {
                display.text =  digit
                userIsInTheMiddleOfTypingANumber = true
            }
        }
    }

    @IBAction func Operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber{
            enter()
        }
        switch operation {
            case "×": performDualOperation {$0 * $1}
            case "÷": performDualOperation {$1 / $0}
            case "+": performDualOperation {$0 + $1}
            case "−": performDualOperation {$1 - $0}
            case "√": performMonoOperation { sqrt($0)}
            case "sin": performMonoOperation { sin($0) }
            case "cos": performMonoOperation { cos($0) }
            case "tan": performMonoOperation { tan($0) }
            default: break
        }
        
    }
   
    func performDualOperation(operation:(Double, Double) -> Double) {
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }
    
    func performMonoOperation(operation:Double -> Double) {
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast())
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
//→π√␡⏎± 🔙
//sin cos tan