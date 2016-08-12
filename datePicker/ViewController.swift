import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var monthTable: UITableView!
    @IBOutlet weak var dayTable: UITableView!
    @IBOutlet weak var yearTable: UITableView!

    var calendar: NSCalendar {
        get {
            return NSCalendar.currentCalendar()
        }
    }
    var currentDate = NSDate()
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == monthTable {
            return calendar.monthSymbols.count
        } else if tableView == dayTable {
        let days = calendar.rangeOfUnit(.Day, inUnit: .Month, forDate: currentDate)
            return days.length
        } else  {
            return 3
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        if tableView == monthTable {
            cell = tableView.dequeueReusableCellWithIdentifier("month")
            cell?.textLabel?.text = calendar.monthSymbols[indexPath.row]
        } else if tableView == dayTable {
            cell = tableView.dequeueReusableCellWithIdentifier("day")
        } else {
            cell = tableView.dequeueReusableCellWithIdentifier("year")
        }
        return cell!
    }
}