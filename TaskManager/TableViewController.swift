import UIKit

class TableViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet var headerView: UIView!
    @IBOutlet weak var addNewTask: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AppData.addData()
        self.tableView.tableHeaderView = headerView
        self.addNewTask.delegate = self
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.placeholder = nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let newTaskName = textField.text{
            if newTaskName == ""{
                textField.placeholder = "Add new task"
                return true
            }
            textField.text = ""
            textField.placeholder = "Add new task"
            let newTask = Task(name: newTaskName, status: false)
            AppData.tasks.append(newTask)
            self.tableView.beginUpdates()
            let newIndexPath = IndexPath(row: AppData.tasks.count-1, section: 0)
            self.tableView.insertRows(at: [newIndexPath], with: UITableView.RowAnimation.right)
            self.tableView.endUpdates()
            return true
        }else{
            return false
        }
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppData.tasks.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_id", for: indexPath)
        let simpleTask = AppData.tasks[indexPath.row]
        
        let attributedString = NSMutableAttributedString(string: simpleTask.name)
        
        if simpleTask.status{
            cell.backgroundColor = UIColor.lightGray
            cell.accessoryType = UITableViewCell.AccessoryType.checkmark
            attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2.0, range: NSMakeRange(0, attributedString.length))
        }else{
            cell.backgroundColor = UIColor.white
            cell.accessoryType = UITableViewCell.AccessoryType.none
            attributedString.removeAttribute(NSAttributedString.Key.strikethroughStyle, range: NSMakeRange(0, attributedString.length))
        }
        
        cell.textLabel?.attributedText = attributedString
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var selectedTask = AppData.tasks[indexPath.row]
        selectedTask.status = !selectedTask.status
        AppData.tasks[indexPath.row] = selectedTask
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle != UITableViewCell.EditingStyle.delete {return}
        AppData.tasks.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.left)
    }
}
