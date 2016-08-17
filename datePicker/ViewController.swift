import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var monthTable: UITableView!
    @IBOutlet weak var dayTable: UITableView!
    @IBOutlet weak var yearTable: UITableView!
    @IBOutlet weak var dateLabel: UILabel!

    var calendar: NSCalendar {
        get {
            return NSCalendar.currentCalendar()
        }
    }
    var currentDate = NSDate() {
        didSet {
            dateLabel.text = "\(currentDate)"
            scrollToCurrentDate(animated: true)
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        scrollToCurrentDate(animated: false)
    }

    func scrollToCurrentDate(animated animated: Bool) {
        let components = calendar.components([.Day, .Month, .Year], fromDate: currentDate)
        monthTable.selectRowAtIndexPath(NSIndexPath(forRow: components.month - 1, inSection: 0), animated: animated, scrollPosition: .Top)
        dayTable.selectRowAtIndexPath(NSIndexPath(forRow: components.day - 1, inSection: 0), animated: animated, scrollPosition: .Top)
        yearTable.selectRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0), animated: animated, scrollPosition: .Top)
    }
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
            cell?.textLabel?.text = "\(indexPath.row + 1)"
        } else {
            cell = tableView.dequeueReusableCellWithIdentifier("year")
            let year = calendar.component(.Year, fromDate: currentDate)
            cell?.textLabel?.text = "\(year - 1 + indexPath.row)"
        }
        return cell!
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let components = calendar.components([.Day, .Month, .Year], fromDate: currentDate)
        if tableView == monthTable {
            let month = indexPath.row + 1
            components.month = month
            var newDate: NSDate?
            repeat {
                newDate = calendar.dateFromComponents(components)
                components.day -= 1
            } while newDate == nil || calendar.component(.Month, fromDate: newDate!) != month
            currentDate = newDate!
            dayTable.reloadData()
            yearTable.reloadData()
        } else if tableView == dayTable {
            components.day = indexPath.row + 1
            if let newDate = calendar.dateFromComponents(components) {
                currentDate = newDate
                monthTable.reloadData()
                yearTable.reloadData()
            }
        } else  {
            let year = calendar.component(.Year, fromDate: currentDate)
            components.year = year - 1 + indexPath.row
            var newDate: NSDate?
            repeat {
                newDate = calendar.dateFromComponents(components)
                components.day -= 1
            } while newDate == nil || calendar.component(.Month, fromDate: newDate!) != components.month
            currentDate = newDate!
            monthTable.reloadData()
            dayTable.reloadData()
            yearTable.reloadData()
        }
    }
}