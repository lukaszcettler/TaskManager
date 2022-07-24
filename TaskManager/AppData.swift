import Foundation

class AppData{
   static var tasks: Array<Task>!
    
    class func addData(){
        let task1 = Task(name: "Pay rent", status: false)
        let task2 = Task(name: "Buy groceries", status: true)
        let task3 = Task(name: "Cleaning", status: true)
        
        tasks = [task1, task2, task3]

    }
}
