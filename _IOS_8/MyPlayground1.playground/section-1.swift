// Playground - noun: a place where people can play

import UIKit

println("Hello, world")

var str = "Hello, playground"
var  fl:Float = 10.0
let frt:Double = 20.0

var label = "The width is + \(fl) and \(str)"
let width = 94
let widthLabel = label + String(width)

//let emptyArray = String[]()
//let emptyDictionary = String<String, Float>()
//let emp = String[]()


let arr = []
let dic = [:]


let emptyArray = [String]()//String[]()
let emptyDictionary = [String: Float]()


enum Rank: Int {
    case Ace = 1
    case Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten
    case Jack, Queen, King
    func simpleDescription() -> String {
        switch self {
        case .Ace:
            return "ace"
        case .Jack:
            return "jack"
        case .Queen:
            return "queen"
        case .King:
            return "king"
        default:
            return String(self.rawValue)
        }
    }
}
let ace = Rank.Five
let aceRawValue = ace.rawValue

    
let individualScores = [75, 43, 103, 87, 12]

var teamScore = 0

for score in individualScores
{
    if score > 50 {
        teamScore += 3        
    } else {
        teamScore += 1
    }
}
teamScore


var sss:String? = ""
sss = nil
//str = nil


var optionalString: String! = "Hello"
optionalString = nil
optionalString == nil

var optionalName: String? = "John Appleseed"

var greeting = "Hello! " + optionalName!;
let nim = optionalName

if let name = optionalName {
    greeting = "Hello, \(name)"
} else {
    greeting = "Hi, \(optionalName)"
}


if optionalString != nil {
    println("string is \(optionalString)");
}


let vegetable = "red pepper"
switch vegetable {
case "celery":
    let vegetableComment = "Add some raisins and make ants on a log."
case "cucumber", "watercress":
    let vegetableComment = "That would make a good tea sandwich."
case let x where x.hasSuffix("pepper"):
    let vegetableComment = "Is it a spicy \(x)?"
default:
    let vegetableComment = "Everything tastes good in soup."
}

typealias AudioSample = UInt16

//let age = -3
//assert( age >= 0, "Возраст человека не может быть меньше 0")

var interestingNumbers:Dictionary = [
    "Prime": [2, 3, 5, 7, 11, 13],
    "Fibonacci": [1, 1, 2, 3, 5, 8],
    "Square": [1, 4, 9, 16, 25],
]

var largest = 0
for (kind, numbers) in interestingNumbers {

    for number in numbers {
        
        if number > largest {
            
            largest = number
            
        }
        
    }
    
}
//largest
println("res = \(largest)")

let three = 3
let pointOneFourOneFiveNine = 0.14159
let pi = Double(three) + pointOneFourOneFiveNine

let http404Error = (404, "Not Found")
let (statusCode, statusMessage) = http404Error
println("The status code is \(statusCode)")
println("The status code is \(http404Error.0)")
let http200Status = (statusCode: 200, description: "OK")



let defaultColorName = "red"
var userDefinedColorName: String? // по умолчанию равно nil
var colorNameToUse = userDefinedColorName ?? defaultColorName

let names = ["Anna", "Alex", "Brian", "Jack"]
let count = names.count
for i in 0..<count {
    println("Person \(i + 1) is called \(names[i])")
}


var emptyString = "" // пустой строковый литералvar anotherEmptyString = String() // синтаксис инициализации

if emptyString.isEmpty {
    println("Nothing to see here")}

let ss1 = "123"
//var int = ss1.lengthOfBytesUsingEncoding(UTF8)

let unusualMenagerie = "Koala , Snail , Penguin , Dromedary "
println("unusualMenagerie имеет \(countElements(unusualMenagerie)) символов")
//println("unusualMenagerie имеет \(unusualMenagerie.length) символов")


