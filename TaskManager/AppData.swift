import Foundation

class AppData{
   static var tasks: Array<Task>!
    
    class func addData(){
        let task1 = Task(name: "Pay rent", status: false)
        let task2 = Task(name: "Buy groceries", status: true)
        let task3 = Task(name: "Cleaning", status: true)
        let task4 = Task(name: "Call mom", status: false)
        let task5 = Task(name: "Wash the car", status: true)
        let task6 = Task(name: "Write to George", status: false)
        
        tasks = [task1, task2, task3, task4, task5, task6]

    }
}
