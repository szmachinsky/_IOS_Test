// Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"


let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "MyTestSwiftCell")

cell.textLabel.text = "Habrapost"
cell.detailTextLabel?.text = "Hi"
cell.detailTextLabel?.textColor = UIColor.purpleColor()

cell