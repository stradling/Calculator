//
//  ViewController.swift
//  Calculator
//
//  Created by Alden Stradling on 6/1/15.
//  Copyright (c) 2015 Alden Stradling. All rights reserved.
//

import UIKit

extension String
{
    public func indexOfCharacter(char: Character) -> (Int?, String.Index?) {
        if let idx = find(self, char) {
            return (distance(self.startIndex, idx), idx)
        }
        return (nil,nil)
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    
    var userIsInTheMiddleOfTypingANumber = false
    var inputHasADecimal = false
    var knownNonNumericCharacters = "→π√␡⏎± 🔙+−÷×"

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
            case "×": performBinaryOperation {$0 * $1}
            case "÷": performBinaryOperation {$1 / $0}
            case "+": performBinaryOperation {$0 + $1}
            case "−": performBinaryOperation {$1 - $0}
            case "√": performUnaryOperation { sqrt($0)}
            case "sin": performUnaryOperation { sin($0) }
            case "cos": performUnaryOperation { cos($0) }
            case "tan": performUnaryOperation { tan($0) }
            case "π": insertConstant(M_PI, visible: operation)
            case "±": performUnaryOperation { -$0 }
            default: break
        }
        
    }
   
    func performBinaryOperation(operation:(Double, Double) -> Double) {
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }
    
    func performUnaryOperation(operation:Double -> Double) {
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }
    
    func insertConstant(my_constant: Double, visible: String) {
        userIsInTheMiddleOfTypingANumber = true
        operandStack.append(my_constant)
        if display.text != "0" {
            display.text = display.text! + visible
        } else {
            display.text = visible
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
            var tempstring = display.text!
            for testcharacter in knownNonNumericCharacters {
                while tempstring.indexOfCharacter(testcharacter).1 != nil {
                    tempstring.removeAtIndex(tempstring.indexOfCharacter(testcharacter).1!)
                }
            }
            return NSNumberFormatter().numberFromString(tempstring)!.doubleValue
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