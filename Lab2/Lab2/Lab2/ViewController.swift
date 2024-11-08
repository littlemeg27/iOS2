import UIKit

class ViewController: UIViewController
{
    var employees = [Employee]()
    var currentIndex = 0
    
    @IBOutlet weak var EmployeeNameLabel: UILabel!
    @IBOutlet weak var EmployeeUsernameLabel: UILabel!
    @IBOutlet weak var EmployeeMacAddressLabel: UILabel!
    @IBOutlet weak var EmployeeTitleLabel: UILabel!
    @IBOutlet weak var EmployeeSkillsLabel: UITextView!
    @IBOutlet weak var EmployeePastEmployLabel: UILabel!
    @IBOutlet weak var EmployeeCompanyLabel: UITextView!
    @IBOutlet weak var EmployeeResponsibityLabel: UITextView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if let path = Bundle.main.path(forResource: "EmployeeData", ofType: "json")
        {
            let url = URL(fileURLWithPath: path)
            
            do
            {
                let data = try Data(contentsOf: url)
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
                parseJSON(jsonObject: jsonObject)
                
                // Display the first employee after loading data
                if !employees.isEmpty
                {
                    displayEmployee(at: currentIndex)
                }
            }
            catch
            {
                print("Error loading JSON: \(error.localizedDescription)")
            }
        }
    }
    
    func displayEmployee(at index: Int)
    {
        guard index >= 0 && index < employees.count else { return }
        
        let employee = employees[index]
        
        EmployeeNameLabel.text = employee.employeename
        EmployeeUsernameLabel.text = employee.username
        EmployeeMacAddressLabel.text = employee.macaddress
        EmployeeTitleLabel.text = employee.current_title
        EmployeeSkillsLabel.text = employee.skills.joined(separator: ", ")
        EmployeePastEmployLabel.text = "\(employee.past_employers.count)"
        
        if let firstPastEmployer = employee.past_employers.first
        {
            EmployeeCompanyLabel.text = firstPastEmployer.company
            EmployeeResponsibityLabel.text = firstPastEmployer.responsibilities.joined(separator: ", ")
        }
        else
        {
            EmployeeCompanyLabel.text = "No Company"
            EmployeeResponsibityLabel.text = "No Responsibilities"
        }
    }
    
    func parseJSON(jsonObject: [[String: Any]]?)
    {
        guard let jsonObject = jsonObject else { return }
        
        for item in jsonObject
        {
            guard let employeename = item["employeename"] as? String,
                  let username = item["username"] as? String,
                  let macaddress = item["macaddress"] as? String,
                  let current_title = item["current_title"] as? String else
            {
                continue
            }
            
            let skills = item["skills"] as? [String] ?? []
            
            var pastEmployers: [PastEmployer] = []
            if let pastEmployersArray = item["past_employers"] as? [[String: Any]]
            {
                for employerDict in pastEmployersArray
                {
                    let company = employerDict["company"] as? String ?? "Unknown Company"
                    let responsibilities = employerDict["responsibilities"] as? [String] ?? []
                    let pastEmployer = PastEmployer(company: company, responsibilities: responsibilities)
                    pastEmployers.append(pastEmployer)
                }
            }

            let employee = Employee(employeename: employeename, username: username, macaddress: macaddress, current_title: current_title, skills: skills,
                past_employers: pastEmployers)
                employees.append(employee)
        }
    }
    
    @IBAction func nextEmployee(_ sender: UIButton)
    {
        if currentIndex < employees.count - 1
        {
            currentIndex += 1
            displayEmployee(at: currentIndex)
        }
    }
    
    @IBAction func previousEmployee(_ sender: UIButton)
    {
        if currentIndex > 0
        {
            currentIndex -= 1
            displayEmployee(at: currentIndex)
        }
    }
}
