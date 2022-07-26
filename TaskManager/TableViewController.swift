import UIKit

class TableViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet var headerView: UIView!
    @IBOutlet weak var addNewTask: UITextField!
    
    var activeTasks: [Task] = []
    var doneTasks: [Task] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AppData.addData()
        separateTasks()
        
        self.tableView.tableHeaderView = headerView
        self.addNewTask.delegate = self
        self.addNewTask.autocapitalizationType = UITextAutocapitalizationType.words
    }
    
    func separateTasks(){
        
        for task in AppData.tasks{
            if task.status{
                doneTasks.append(task)
            }else{
                activeTasks.append(task)
            }
        }
        
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
            
            for i in 0..<AppData.tasks.count{
                let task = AppData.tasks[i]
                if task.name.lowercased() == newTaskName.lowercased(){
                    var refreshedTask = task
                    refreshedTask.status = false
                    self.tableView.reloadData()
                    return true
                }
            }
            
            let newTask = Task(name: newTaskName, status: false)
            AppData.tasks.append(newTask)
            activeTasks.append(newTask)
            self.tableView.beginUpdates()
            let newIndexPath = IndexPath(row: activeTasks.count-1, section: 0)
            self.tableView.insertRows(at: [newIndexPath], with: UITableView.RowAnimation.right)
            self.tableView.endUpdates()
            return true
        }else{
            return false
        }
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "Active Tasks"
        }else{
            return "Finished Tasks"
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return activeTasks.count
        }else{
            return doneTasks.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_id", for: indexPath)
        
        var simpleTask = Task()
        
        if indexPath.section == 0{
            simpleTask = activeTasks[indexPath.row]
        }else{
            simpleTask = doneTasks[indexPath.row]
        }
        
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
        
        var task = Task()
        if indexPath.section == 0{
            task = activeTasks[indexPath.row]
            task.status = true
            activeTasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.left)
            doneTasks.append(task)
            let newIndexPath = IndexPath(row: doneTasks.count - 1, section: 1)
            tableView.insertRows(at: [newIndexPath], with: UITableView.RowAnimation.right)
        }else{
            task = doneTasks[indexPath.row]
            task.status = false
            doneTasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.left)
            activeTasks.append(task)
            let newIndexPath = IndexPath(row: activeTasks.count - 1, section: 0)
            tableView.insertRows(at: [newIndexPath], with: UITableView.RowAnimation.right)
        }
        
        for i in 0..<AppData.tasks.count{
            let taskInAppData = AppData.tasks[i]
            if (taskInAppData.name == task.name){
                AppData.tasks[i] = task
            }
             
        }
   
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle != UITableViewCell.EditingStyle.delete {return}
        
        var task = Task()
        if indexPath.section == 0{
            task = activeTasks[indexPath.row]
            activeTasks.remove(at: indexPath.row)
        }else{
            task = doneTasks[indexPath.row]
            doneTasks.remove(at: indexPath.row)
        }
        
        for i in 0..<AppData.tasks.count{
            let taskInAppData = AppData.tasks[i]
            if (taskInAppData.name == task.name){
                AppData.tasks.remove(at: i)
                break
            }
        }
        
        tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.left)
    }
}
