//
//  main.swift
//  RecodeMaker
//
//  Created by 박태현 on 2016. 5. 17..
//  Copyright © 2016년 DevPark. All rights reserved.
//

import Foundation

protocol NTArbitrary {
  static func arbitrary() -> Self
}

extension Int: NTArbitrary {
  static func arbitrary() -> Int {
    let range: Range<Int> = 0...100
    let min = range.startIndex
    let max = range.endIndex
    return Int(arc4random_uniform(UInt32(max - min))) + min
  }
  
  static func random(from from: Int, to: Int) -> Int {
    return from + (Int(arc4random()) % (to - from))
  }
}

extension Character: NTArbitrary {
  static func arbitrary() -> Character {
    // 0~9 숫자로 구성된 Chracter 리턴
    return Character(UnicodeScalar(Int.random(from: 48, to: 57)))
  }
}

extension String: NTArbitrary {
  static func arbitrary() -> String {
    let length = 5
    let randomCharacters = Array(0..<length).map {_ in
      Character.arbitrary()
    }
    return "NC" + String(randomCharacters)
  }
}

class Employee {
  let number: String
  let score: Int
  
  init(number: String, score: Int) {
    self.number = number
    self.score = score
  }
  
  func printEmplyee() {
    print("사번 : " + self.number + " 점수 : \(self.score)")
  }
}

public class EmployeeMaker {
  var employees = [Employee]()
  var employeeDictionary = [String: Int]()
  
  func makeEmployeesWithCount(count: Int) -> [Employee] {
    Array(0..<count).forEach { _ in
      let number = getUniqueNumber()
      let score = Int.arbitrary()
      
      employees.append(Employee(number: number, score: score))
      employeeDictionary[number] = score
    }
    return employees.sort {$0.0.number < $0.1.number}
  }
  
  private func getUniqueNumber() -> String {
    var number = String.arbitrary()
    while true {
      if checkDuplication(number) == false {
        break
      } else {
        number = String.arbitrary()
      }
    }
    return number
  }
  
  private func checkDuplication(str: String) -> Bool {
    return (employeeDictionary[str] != nil) ? true : false
  }
}

// main
let start = NSDate() // <<<<<<<<<< Start time

let empMaker = EmployeeMaker()
let employees = empMaker.makeEmployeesWithCount(5000)

employees.forEach { emp in
  emp.printEmplyee()
}

print("총 사원수 : \(employees.count)")

let end = NSDate()   // <<<<<<<<<<   end time
let timeInterval: Double = end.timeIntervalSinceDate(start)

print("Time to evaluate problem: \(timeInterval) seconds")

