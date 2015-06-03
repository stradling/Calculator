//
//  ViewController.swift
//  Calculator
//
//  Created by Alden Stradling on 6/1/15.
//  Copyright (c) 2015 Alden Stradling. All rights reserved.
//

// Completed assignment 1. Adapted to XCode 6.3 (Swift 1.2) by providing a Unary and Binary operator rather than overloading.

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
    @IBOutlet weak var operationsLogger: UILabel!
    
    var userIsInTheMiddleOfTypingANumber = false
    var inputHasADecimal = false
    var knownNonNumericCharacters = "→π√␡⏎± 🔙+−÷×e"
    var operandStack = Array<Double>()
    var buttonPush = true
    
    //Why is this error type?
    var brain = CalculatorBrain()

    @IBAction func clearCalculator() {
        userIsInTheMiddleOfTypingANumber = false
        inputHasADecimal = false
        operandStack = Array<Double>()
        displayValue = 0
        display.text = "0"
        operationsLogger.text = ""
    }

    
    @IBAction func deleteDigit() {
        if userIsInTheMiddleOfTypingANumber {
            if count(display.text!) >= 1 {
                var lastcharIndex = advance(display.text!.endIndex, -1)
                display.text = display.text!.substringToIndex(lastcharIndex)
            }
        }
    }
    
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

    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber{
            buttonPush = false
            enter()
            buttonPush = true
        }
        operationsLogger.text = operationsLogger.text! + " \(operation) "
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
            case "e": insertConstant(M_E, visible: operation)
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

    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        //Failing here because brain is errortype
        
        if let result = brain.pushOperand(displayValue) {
            displayValue = result
        }
        operandStack.append(displayValue)
        operationsLogger.text = operationsLogger.text! + " \(display.text!) "
        if buttonPush == true { operationsLogger.text = operationsLogger.text! + " ⏎ " }
        
        
    }
    
    var displayValue: Double {
        get {
            if display.text! == "" { display.text! = "0" }
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

