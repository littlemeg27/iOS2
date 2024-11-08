//
//  Employee.swift
//  Lab2
//
//  Created by Brenna Pavlinchak on 11/5/24.
//

import Foundation

class PastEmployer
{
    let company: String
    let responsibilities: [String]
    
    init(company: String, responsibilities: [String])
    {
        self.company = company
        self.responsibilities = responsibilities
    }
}

class Employee
{
    let employeename: String
    let username: String
    let macaddress: String
    let current_title: String
    let skills: [String]
    let past_employers: [PastEmployer]

    var employeeEmployeename: String
    {
        return employeename
    }
    var employeeUsername: String
    {
        return username
    }
    var employeeMacaddress: String
    {
        return macaddress
    }
    var employeeCurrentTitle: String
    {
        return current_title
    }
    var employeeSkills: String
    {
        return skills.count.description
    }
    var employeePastEmployersCount: String
    {
        return past_employers.count.description
    }

    init(employeename: String, username: String, macaddress: String, current_title: String, skills: [String], past_employers: [PastEmployer])
    {
        self.employeename = employeename
        self.username = username
        self.macaddress = macaddress
        self.current_title = current_title
        self.skills = skills
        self.past_employers = past_employers
    }

    func printEmployee()
    {
        var printString = """
        Name: \(employeeEmployeename)
        Username: \(employeeUsername)
        MAC Address: \(employeeMacaddress)
        Title: \(employeeCurrentTitle)
        Skills: \(skills.joined(separator: ", "))
        Past Employers:
        """
        
        for (index, employer) in past_employers.enumerated()
        {
            printString += "\n  Employer #\(index + 1): \(employer.company)"
            printString += "\n  Responsibilities (\(employer.responsibilities.count)):"
            for responsibility in employer.responsibilities
            {
                printString += "\n    - \(responsibility)"
            }
        }
        print(printString)
    }
}
