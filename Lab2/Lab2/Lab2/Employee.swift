//
//  Employee.swift
//  Lab2
//
//  Created by Brenna Pavlinchak on 11/5/24.
//

import Foundation

class Employee
{
    let employeename: String
    let username: String
    let macaddress: String
    let current_title: String
    let skills: [String]
    let past_employers: [String]
    let company: String
    let responsibilities: String
    
    var employeeEmployeename: String
    {
        get { return "\(employeename)"}
    }
    var employeeUsername: String
    {
        get { return "\(username)"}
    }
    var employeeMacaddress: String
    {
        get { return "\(macaddress)"}
    }
    var employeeCurrent_title: String
    {
        get { return "\(current_title)"}
    }
    var employeeSkills: String
    {
        get { return skills.count.description}
    }
    var employeePast_employers: String
    {
        get { return past_employers.count.description}
    }
    
    
    init(employeename: String, username: String, macaddress: String, current_title: String, skills: [String], past_employers: [String])
    {
        self.employeename = employeename
        self.username = username
        self.macaddress = macaddress
        self.current_title = current_title
        self.skills = skills
        self.past_employers = past_employers
    }
    
    func printMovie()
    {
        var printString: String = "Name: \(employeeEmployeename) Username: \(employeeUsername) Macaddress: \(employeeMacaddress)\" Title: \(employeeCurrent_title) Skills:"
        
        for Employee in Employees
        {
            printString += "\n\(skills)"
        }
        print(printString)
    }
}

