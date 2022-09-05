//
//  TableTableViewController.swift
//  Timer
//
//  Created by Jeremy Merezhko on 5/10/22.
//

import UIKit
import Combine
import Foundation
import UserNotifications

class TableTableViewController: UITableViewController, UIGestureRecognizerDelegate {
    
    static let subject = PassthroughSubject<Int, Never>()
    
    
    
    
    //MARK: - All Important Properties
    let label = UILabel()
  
   // used when cell is being deleted, indicated wether tableView is allowed to reload yet or not, because we don't want to try deleting cell and at the same time reloading
 static  var reloadAllowed = true
    // holds an iIndexPath of a cell that is currently displaying deletion settings, used to be able to properly delete the "deletion view" and add it to another cell
    //var aboutToReload = false
    var viewReload = false
    var positionOfACellWithTheView = IndexPath()
    // button and view hold a reference to the views that we are using for displating deletion
    var button = UIButton()
    var view2 = UIView()
    var labelInError = UILabel()
    var errorView = UIView()
    var editButton = UIButton()
    // used to not allow subscriptions subscriptions to be created more than once
    var executeNumber  = 0
    // this array will hold all the timer instances:
    static var timers = [Timer2]()
    // this array will hold all the initial values of: seconds, minutes and hours (before the timers were started), so when you type the reset button of the system has to reset the timer you can load it in with approprite values:
    static var originalTimers = [TimeToReset]()
    //this array holds all necessary information about each cell:
  static var cells = [CellModel]()
    // this variable stores a subscription to the statice publisher on the Timer2 class:
    var subscriptions = Set<AnyCancellable>()
    static var wokeUp = false
    static var date = Date()
    static var indicesToReloadAt = [IndexPath]()
    
    
//MARK: - Creating subscriptions and managing internal events (Timer), (Deletion)
    
 
    
    
    
    //this function creates a subscription to the Timer2's publisher (which is subject)
    func createASubscriptionForTimer() {
         Timer2.subject.sink { value in
            print("recivedtheValue")
            //only reloads if table view is currently not editing:
            if TableTableViewController.reloadAllowed == true {
           print("subscription working ")
            // creating empty cell model, we are just going to sotre minnutes hours and seconds here
     var cell2 = CellModel(cellNumber: 0, currentHours: 0, currentMinutes: 0, currentSeconds: 0, name: "")
          // number is like the  "iterator" of a for loop, it indicate at which location in the array the loop has stopped so it'll be easy to fetch a right CellModel from an array to update
            var number = 0
              //  print(self.cells)
              //  print(self.cells.count)
            for cell in TableTableViewController.cells {
                
                print("value of cell before refilling")
                print(cell.currentHours, ":", cell.currentMinutes, ":",cell.currentSeconds)
                // if the unique number of created timer matches the same unique number of cell. Then that cell model gets updated
               // print(cell.cellNumber, "and", value.cellToRefill)
                if cell.cellNumber == value.cellToRefill  {
                   
                    print("refilling cell with number: " ,cell.cellNumber)
                    print("for timer with number: ", value.cellToRefill)
                    print("with:", value.hours, ":", value.minutes, ":", value.seconds )
                //updating the current model to assign it's properties to an actual cell later
                    cell2.currentSeconds = value.seconds
                    cell2.currentMinutes = value.minutes
                    cell2.currentHours = value.hours
                  // stop the loop when found a match:
                    break
                   
                } else {
               // moving on in the array of timers if the condition in if statement is not matched
                number += 1
                }
            }
            // updating the cell at the right position in the array
               // print(TableTableViewController.cells)
                TableTableViewController.cells[number].currentSeconds = cell2.currentSeconds
                TableTableViewController.cells[number].currentMinutes = cell2.currentMinutes
                TableTableViewController.cells[number].currentHours = cell2.currentHours
                self.tableView.reloadRows(at: [IndexPath(row: number , section: 0)], with: .none)
              //  }
                print("subscription working 3")
                // making a number a 0 so the next time the subscription gets utilized, the while loop won't build on the previous value of a number
                // this might not be needed, but im too lazy to check
                number = 0
            
            }
            // storing in subscriptions, so the subscription doesn't immediately cancel
        }.store(in: &subscriptions)
        
    }
    
    
    func playTappedInCell() {
        let subscription = TableViewCell.playTapped.sink { value in
            print("value received")
            // getting a cell of a seneder:
            let cell = value.cell as! TableViewCell
            // getting the index path of a cell to make appropriate updates to elements in arrays:
            if let indexPath = self.tableView.indexPath(for: cell) {
                print("in playtapped")
                print(TableTableViewController.cells[indexPath.row])
                //
                if TableTableViewController.cells[indexPath.row].playTapped == false {
                 var notification =  TableTableViewController.timers[indexPath.row].notification
                    NotificationManager.shared.scheduleNotification(task: notification)
                    UIView.animate(withDuration: 0.1, delay: 0.0, animations: {value.button.transform = CGAffineTransform(scaleX: 0.94, y: 0.94)})
                 // fetching the right cell to edit after the bplay button has been tapped:
                 
                  
                
                    print("timer started")
                    // changing the values of a cell to indicate that the play  button has been tapped:
                 //   cells[indexPath.row].playTapped = true
                 
                    TableTableViewController.cells[indexPath.row].pauseTapped = false
                    TableTableViewController.cells[indexPath.row].playTapped  = true
                    self.tableView.reloadRows(at: [indexPath], with: .none)
                    print(TableTableViewController.cells[indexPath.row])
                    // starting a timer:
                            TableTableViewController.timers[indexPath.row].start()
                      print("started timer at index path: \(indexPath)")
                   
                } else {
                   // if pause was tapped, stopping the timer:
                    var notification =  TableTableViewController.timers[indexPath.row].notification
                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notification.id])

                    TableTableViewController.timers[indexPath.row].stop()
                    
                    print("stopped timer at index path: \(indexPath)")
                    // adjusting the cell:
                  //  UIView.animate(withDuration: 0.1, delay: 0.0, animations: {value.button.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)})
                   // value.button.backgroundColor = .greenWeNeed
                   // value.button.setTitle("Play", for: .normal)
                    // still adjusting the cell to indicate that the pause has been pressed:
                  
                    TableTableViewController.cells[indexPath.row].pauseTapped = true
                    TableTableViewController.cells[indexPath.row].playTapped = false
                    //print(TableTableViewController.cells[indexPath.row])
                    //cell.updateWith(cellModel: TableTableViewController.cells[indexPath.row])
                    self.tableView.reloadRows(at: [indexPath], with: .none)
                        }
        }
            
        }.store(in: &subscriptions)
    }
    
    func createSubscriptionFromReset() {
     
       
        
        let subscription = TableViewCell.resetTapped.sink { value in
            TableTableViewController.reloadAllowed = false
            
         
            
            let cell = value.cell
            if let indexPath = self.tableView.indexPath(for: cell) {
               // cells[indexPath.row].playTapped == false &&
                if  TableTableViewController.cells[indexPath.row].currentHours == TableTableViewController.originalTimers[indexPath.row].hours &&  TableTableViewController.cells[indexPath.row].currentMinutes == TableTableViewController.originalTimers[indexPath.row].minutes, TableTableViewController.cells[indexPath.row].currentSeconds == TableTableViewController.originalTimers[indexPath.row].seconds   {
                } else {
                    if TableTableViewController.timers[indexPath.row].isEnabled == true {
                var notification =  TableTableViewController.timers[indexPath.row].notification
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notification.id])
                    TableTableViewController.timers[indexPath.row].stop()
                    }
                    TableTableViewController.timers[indexPath.row].minutes = TableTableViewController.originalTimers[indexPath.row].minutes
                    TableTableViewController.timers[indexPath.row].seconds = TableTableViewController.originalTimers[indexPath.row].seconds
                    TableTableViewController.timers[indexPath.row].hours = TableTableViewController.originalTimers[indexPath.row].hours
                    TableTableViewController.cells[indexPath.row].currentMinutes = TableTableViewController.originalTimers[indexPath.row].minutes
                    TableTableViewController.cells[indexPath.row].currentSeconds = TableTableViewController.originalTimers[indexPath.row].seconds
                    TableTableViewController.cells[indexPath.row].pauseTapped = true
                    TableTableViewController.cells[indexPath.row].playTapped = false
                    self.tableView.reloadRows(at: [indexPath], with: .none)
                        
        
               }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                TableTableViewController.reloadAllowed = true
        
        }
        }.store(in: &subscriptions)
}
    
    // creating a subscription that respondes to swipes on a cell that you make:
    func createASubscriptionForCell() {
        let subscription = TableViewCell.TableViewCellSubjcet.sink { value in
          print("received")
             
            // if you swiped left on the same cell that is displaying the deletion view, then the view gets removed
            switch value.swipeLeft {
            case true:
                print("dwiped left")
                
                    for cell in self.tableView.visibleCells {
                    if cell.description == value.description {
                        if self.tableView.indexPath(for: cell) == self.positionOfACellWithTheView {
                        print("worked why?")
                        UIView.animate(withDuration: 0.2, animations: {
    
                            self.view2.frame = CGRect(x: cell.frame.minX - 200, y:  cell.frame.minY + 0.5 , width: self.view.frame.width / 2, height: cell.frame.height )
                            
                            self.button.frame = CGRect(x: cell.frame.minX - 200, y:  cell.frame.minY +  cell.frame.height / 5, width: cell.frame.width / 6, height: cell.frame.height / 1.7)
                            
                             self.editButton.frame = CGRect(x: cell.frame.minX - 200, y: cell.frame.minY +  cell.frame.height / 5, width: cell.frame.width / 6, height: cell.frame.height / 1.7)
                            
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                self.button.removeFromSuperview()
                                self.view2.removeFromSuperview()
                                self.editButton.removeFromSuperview()
                                print("removed shit")
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                self.viewReload = false
                            }
                        })
                        CellModel.isViewInUse = false
                        break
                    }
                }
                    }
                    
        // if you swiped right on a cell that is not displaying the deletion view, then if view was displaying on a different cell, it gets removed and added to a cell you currently swiped on. If it was already displaying on the view that you swiped, the coe does nothing.
            case false:
                
              
    
                        print("swipe right working")
                       if CellModel.isViewInUse == true {
                           print("removing from the superview")
                        self.button.removeFromSuperview()
                           self.view2.removeFromSuperview()
                           self.editButton.removeFromSuperview()
                           
                           DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                               self.viewReload = false
                           }
                       
                           print("should've removed from superview")
                           CellModel.isViewInUse = false
                       }
                           
                        
                            for cell in self.tableView.visibleCells {
                                if cell.description == value.description {
                                    self.createAReusableView(cell: cell)
                                    self.createAReusableButton(cell: cell)
                                    self.createEditButton(cell: cell)
                                    CellModel.isViewInUse = true
                                    if let indexpathForCell = self.tableView.indexPath(for: cell) {
                                        self.positionOfACellWithTheView = indexpathForCell
                                    }
                                    break
                                }
                            }
               
                }
            
             // never forget storing your subscriptions!!!
           }.store(in: &subscriptions)
      }
    
    
   //MARK: - Creating Deletion views: Button, UIView

    // creating  a button don't mind the arguments  cell and view they are stupid but i might need them later
    func createAReusableButton(cell: UITableViewCell) {
 //creating buttons frame a little bit to the left of a cell, so the animation of the view appearing in from the left will feel smoother
        // configuring the button:
   button = UIButton.init(frame: CGRect(x: cell.frame.minX - 50, y: cell.frame.minY +  cell.frame.height / 5 , width: 90, height: 55))
        button.setTitle("Delete", for: .normal)
        button.setTitleColor(UIColor.redWeNeed, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: view.frame.width / 20, weight: .medium)
        button.backgroundColor = UIColor.bodyColor
       // button.backgroundColor =  UIColor.redWeNeed
        button.layer.borderWidth = 1.0
        
        button.layer.borderColor = UIColor.redWeNeed.cgColor
        button.layer.cornerRadius = 10
        // adding an action to the button:
        button.addTarget(self,
                         action: #selector(buttonAction),
                        for: .touchUpInside)
        // animating a button view
        UIView.animate(withDuration: 0.15, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.1, animations: {
            self.button.frame  = CGRect(x: cell.frame.maxX / 4.0, y: cell.frame.minY +  cell.frame.height / 4.5, width: cell.frame.width / 5.0, height: cell.frame.height / 1.8)
            
        
        })
        // adding it to the main view:
          self.view.addSubview(button)
        
    
    }
   // an lebale that is displayed when the user tries to edit the existing timer with 0h 0m 0s
    func createAReusableErrorLabel(cell: UITableViewCell) {
         labelInError.frame =  CGRect(x: cell.frame.maxX + 300 , y:  cell.frame.minY +  cell.frame.height / 4.5, width: self.view.frame.width / 2, height:  cell.frame.height / 2.6)
          labelInError.font = .systemFont(ofSize: view.frame.width / 26, weight: .medium)
          labelInError.textColor = UIColor.redWeNeed
          labelInError.backgroundColor = .bodyColor
          labelInError.text = "can't update with 0:0:0"
          labelInError.layer.cornerRadius = 5
        labelInError.layer.masksToBounds = true
          labelInError.textAlignment = .center
       
          self.view.addSubview(labelInError)
          
          UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, animations: {
              self.labelInError.frame = CGRect(x: cell.frame.maxX / 1.9 , y:  cell.frame.minY +  cell.frame.height / 3.2 , width: self.view.frame.width / 2, height: cell.frame.height / 2.6 )
              
          
          })
        
      }

    
    func createAReusableErrorView(cell: UITableViewCell)  {
        // same thing as with button:
        errorView = UIView.init(frame: CGRect(x: cell.frame.maxX + 300, y:  cell.frame.minY + 0.5 , width: self.view.frame.width / 1.8, height: cell.frame.height - 1))
        errorView.backgroundColor =  UIColor.timelabelColor
        errorView.layer.cornerRadius = 10
        errorView.dropShadow()
        self.view.addSubview(errorView)
        
       // animating appearance:
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, animations: {
            self.errorView.frame = CGRect(x: cell.frame.maxX / 2, y:  cell.frame.minY + 0.5 , width: self.view.frame.width / 1.8, height: cell.frame.height - 1)
        
        
        })
     
    }

    
    
    // aslo creating and animating a view
    func createAReusableView(cell: UITableViewCell)  {
        // same thing as with button:
        view2 = UIView.init(frame: CGRect(x: cell.frame.minX - 50, y:  cell.frame.minY + 0.5 , width: self.view.frame.width / 2, height: cell.frame.height))
        view2.backgroundColor =  UIColor.timelabelColor
        view2.layer.cornerRadius = 10
        view2.dropShadow()
        self.view.addSubview(view2)
        
       // animating appearance:
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, animations: {
            self.view2.frame = CGRect(x: cell.frame.minX - 10, y:  cell.frame.minY + 0.5 , width: self.view.frame.width / 2, height: cell.frame.height )
        
        
        })
     
    }

  // label that is going to display when you don't have anything
    func createAReusableLabel() {
        label.frame =  CGRect(x: view.frame.maxX / 4, y: view.frame.maxY / 2.5, width: view.frame.width / 2, height: 60)
        label.font = .systemFont(ofSize: view.frame.width / 16, weight: .medium)
        label.textColor = UIColor.kindaDarkGray
        label.text = "Add Your Timers!"
        self.view.addSubview(label)
    }
    
    
    func createEditButton(cell: UITableViewCell) {
 //creating buttons frame a little bit to the left of a cell, so the animation of the view appearing in from the left will feel smoother
        // configuring the button:
   editButton = UIButton.init(frame: CGRect(x: cell.frame.minX - 50, y:  cell.frame.minY +  cell.frame.height / 5, width: cell.frame.width / 6, height: cell.frame.height / 1.7))
        editButton.setTitle("Edit", for: .normal)
        editButton.setTitleColor(UIColor.redWeNeed, for: .normal)
        editButton.titleLabel?.font = .systemFont(ofSize: view.frame.width / 20, weight: .medium)
        editButton.backgroundColor = UIColor.bodyColor
       // button.backgroundColor =  UIColor.redWeNeed
        editButton.layer.borderWidth = 1.0
        
        editButton.layer.borderColor = UIColor.redWeNeed.cgColor
        editButton.layer.cornerRadius = 10
        // adding an action to the button:
        editButton.addTarget(self,
                         action: #selector(editTapped),
                        for: .touchUpInside)
        // animating a button view
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.3, animations: {
            self.editButton.frame  = CGRect(x: cell.frame.minX  + cell.frame.maxX / 31.25, y:  cell.frame.minY +  cell.frame.height / 4.5, width: cell.frame.width / 5.0, height: cell.frame.height / 1.8)
            
        
        })
        // adding it to the main view:
        self.view.addSubview(editButton)
        
    
    }

    
    
    
    // MARK: - UIButton events and actions
// this action will be executed each time user will tap play/pause button
    
    // when edit button is tapped
    @objc func editTapped() {
        // goes to an edit screen and removes the view's from the cell
        tableView.selectRow(at: positionOfACellWithTheView, animated: false, scrollPosition: .none)
  performSegue(withIdentifier: "fromCell", sender: nil)
        view2.removeFromSuperview()
        button.removeFromSuperview()
        editButton.removeFromSuperview()
      
        
    }
    
    // Deletion method, activated when user taps delete on the cell:
    @objc func buttonAction() {
        // pauses the table view's reloading of the cells
        TableTableViewController.reloadAllowed = false
        // removes the cell's model from all of the arrays:
        // and also stops or deallocates the timer, becuase it might not be in array, but it will still continue sending in the values:

        
        TableTableViewController.timers[positionOfACellWithTheView.row].stop()
        let  notification =  TableTableViewController.timers[positionOfACellWithTheView.row].notification
      
        // removes notification from the element in the array, removes the edit and delete buttons with their view and deletes the row from the table view
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notification.id])
        TableTableViewController.timers.remove(at:  positionOfACellWithTheView.row)
        TableTableViewController.cells.remove(at: positionOfACellWithTheView.row)
        TableTableViewController.originalTimers.remove(at: positionOfACellWithTheView.row)
        tableView.beginUpdates()
        tableView.deleteRows(at: [positionOfACellWithTheView], with: .left)
        tableView.endUpdates()
        view2.removeFromSuperview()
        button.removeFromSuperview()
        editButton.removeFromSuperview()
        
        // setting an indicator that the views are not longer in use and can be used in another cell:
        CellModel.isViewInUse = false
        // checking if cells is empty so if it is we can pull up "add your timers" label at a right time
    if TableTableViewController.cells.isEmpty == true {
     createAReusableLabel()
    }
        // giving this function enough time to make all the adjustments and update the data, before starting to edit the cells again:
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
     // allowing the reload:
            TableTableViewController.reloadAllowed = true
          
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "cell")
        ViewFrame.frame = view.frame
   
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationManager.shared.requestAuthorization { granted in
            
        }
        
    }
    //MARK: - tableViewLifeCycle
    
    // function that gets called when you enter foreground
    @objc func reloadData(_ notification: Notification?) {
        tableView.reloadData()
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    // funcion that will regognize which gesture was activated and in which cell,  and  sends a notification to subsciptions so
    @objc func tapEdit(recognizer: UISwipeGestureRecognizer)  {
     
        if recognizer.state == UIGestureRecognizer.State.ended {
            let tapLocation = recognizer.location(in: self.tableView)
            if let tapIndexPath = self.tableView.indexPathForRow(at: tapLocation) {
                if let tappedCell = self.tableView.cellForRow(at: tapIndexPath) as? TableViewCell {
                    
                    if recognizer.direction == .left {
                    TableViewCell.TableViewCellSubjcet.send(swipeLeftRight(description: tappedCell.description, swipeLeft: true))
                    } else {
                        TableViewCell.TableViewCellSubjcet.send(swipeLeftRight(description: tappedCell.description, swipeLeft: false))
                    }
                    
                 }
             }
         }
     }
    
    
    @objc func swipeUp() {
        print("working swipe")
        TableTableViewController.reloadAllowed = false
    }
    
    
    override func viewDidLoad() {
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "cell")
      
        // two gestures for the left and right swipes:
        var tapGesture = UISwipeGestureRecognizer(target: self, action: #selector(tapEdit))
        tapGesture.direction = .left
         tableView.addGestureRecognizer(tapGesture)
         tapGesture.delegate = self
        
        var tapGesture2 = UISwipeGestureRecognizer(target: self, action: #selector(tapEdit))
        tapGesture2.direction = .right
         tableView.addGestureRecognizer(tapGesture2)
         tapGesture2.delegate = self
        
        var swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swipeUp))
        swipeUp.direction = .up
        tableView.addGestureRecognizer(swipeUp)
        swipeUp.delegate = self
        
        
        
        // listens for the notification from sceneWilEnterForeground to reload properly
    NotificationCenter.default.addObserver(self, selector: #selector(self.reloadData(_:)), name: NSNotification.Name("ReloadNotification"), object: nil)
        
    
      // creates the subscriptions when entering fro the terminated state
        if executeNumber == 0 {
            createASubscriptionForTimer()
            createASubscriptionForCell()
            playTappedInCell()
            createSubscriptionFromReset()
            executeNumber += 1
            print("subscription created")
        }
        
        
        
        navigationItem.title = "Timers"
     
        // creates add you timres labels if there is nothing else to show
        if TableTableViewController.cells.isEmpty == true {
         createAReusableLabel()
        }
        
        // some more interface styling
        tableView.backgroundColor = UIColor.bodyColor
        let navigationBarAppearance =  UINavigationBarAppearance()
        
        navigationBarAppearance.backgroundColor =  UIColor.bar2ControllerColor
          let navig = UINavigationBar()
        navigationBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        navig.standardAppearance = navigationBarAppearance
          navig.compactAppearance = navigationBarAppearance
          navig.scrollEdgeAppearance = navigationBarAppearance
          navigationController?.navigationBar.standardAppearance = navig.standardAppearance
          navigationController?.navigationBar.compactAppearance = navig.compactAppearance
          navigationController?.navigationBar.scrollEdgeAppearance = navig.scrollEdgeAppearance
      
        navigationController?.navigationBar.alpha = 1.0
        self.tableView.separatorColor = UIColor.black
        self.tableView.separatorInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
       navigationItem.rightBarButtonItem?.tintColor = UIColor.black
     
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17.0, weight: .medium),
            NSAttributedString.Key.foregroundColor: UIColor.black],
                for: .normal)
     
        
         
        // making sure user doesn't swipe  lot of cells all at once:
        self.tableView.allowsMultipleSelection = false
        // only supports dark mode to avoid changing and reconfiguring your whole interfece for .light and .dark modes
        self.overrideUserInterfaceStyle = UIUserInterfaceStyle.dark
        
    }

    
    // MARK: - Table view data source and Segues
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

   
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TableTableViewController.timers.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("dequeed cell")
        
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
      
        // getting the right model to fill up the cell with:
     
        
        var cellModel = TableTableViewController.cells[indexPath.row]
        
        
        // if the timer has run out of time updating all the stuff:
        if cellModel.currentSeconds == 0 && cellModel.currentMinutes == 0 && cellModel.currentHours == 0 {
            TableTableViewController.timers[indexPath.row].stop()
            cellModel.currentHours = TableTableViewController.originalTimers[indexPath.row].hours
            cellModel.currentMinutes = TableTableViewController.originalTimers[indexPath.row].minutes
            cellModel.currentSeconds = TableTableViewController.originalTimers[indexPath.row].seconds
            TableTableViewController.timers[indexPath.row].seconds =  TableTableViewController.originalTimers[indexPath.row].seconds
            TableTableViewController.timers[indexPath.row].minutes = TableTableViewController.originalTimers[indexPath.row].minutes
            TableTableViewController.timers[indexPath.row].hours = TableTableViewController.originalTimers[indexPath.row].hours
            TableTableViewController.cells[indexPath.row].currentHours = TableTableViewController.originalTimers[indexPath.row].hours
        TableTableViewController.cells[indexPath.row].currentMinutes = TableTableViewController.originalTimers[indexPath.row].minutes
        TableTableViewController.cells[indexPath.row].currentSeconds = TableTableViewController.originalTimers[indexPath.row].seconds
            TableTableViewController.cells[indexPath.row].playTapped = false
            TableTableViewController.cells[indexPath.row].pauseTapped = true
            cellModel.playTapped = false
            cellModel.pauseTapped = true
        }
  
        
  
       // filling up the cell with data:
        if TableTableViewController.cells[indexPath.row].playTapped == true {
            cell.playButton.layer.cornerRadius = 10
            cell.playButton.setTitleColor(.black, for: .normal)
            cell.playButton.transform = CGAffineTransform(scaleX: 0.94, y: 0.9)
            cell.playButton.setTitle("Pause", for: .normal)
            cell.playButton.backgroundColor = UIColor.redWeNeed
            cell.playButton.titleLabel?.font = .systemFont(ofSize: ViewFrame.frame.width / 30)
       
           
        
     }
        // configuring the buttons:
        
        if TableTableViewController.cells[indexPath.row].pauseTapped == true {
            print("this works")
            cell.playButton.layer.cornerRadius = 10
            cell.playButton.setTitleColor(.black, for: .normal)
            cell.playButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            cell.playButton.setTitle("Play", for: .normal)
            cell.playButton.titleLabel?.font = .systemFont(ofSize: ViewFrame.frame.width / 30)
            cell.playButton.backgroundColor  = .greenWeNeed
           
           }
        
       
        cell.name.font = .systemFont(ofSize: ViewFrame.frame.width / 30 )
        cell.name.textColor = UIColor.black
        cell.name.textAlignment = .left
       cell.name.text = TableTableViewController.cells[indexPath.row].name
      
        cell.timeLabel.layer.cornerRadius = 10
        cell.timeLabel.layer.masksToBounds = true
        cell.timeLabel.backgroundColor = .viewColor
        cell.timeLabel.textColor = UIColor.black
        cell.timeLabel.font = .systemFont(ofSize: ViewFrame.frame.width / 12)
        cell.timeLabel.textAlignment = .center
      
        
        var numbers = [TableTableViewController.cells[indexPath.row].currentHours, TableTableViewController.cells[indexPath.row].currentMinutes, TableTableViewController.cells[indexPath.row].currentSeconds]
        var textToDisplay = ""
        for element in numbers {
            if element < 9 {
                textToDisplay += "0\(element):"
            } else {
                textToDisplay += "\(element):"
            }
        }
        textToDisplay.removeLast()
        
        cell.timeLabel.text = textToDisplay
        
        cell.resetButton.backgroundColor = UIColor.resetColor
        cell.timeLabel.textColor = UIColor.black
        cell.resetButton.layer.cornerRadius = 10
        cell.resetButton.setTitleColor(.black, for: .normal)
        cell.resetButton.setTitle("Reset", for: .normal)
        cell.resetButton.backgroundColor = UIColor.resetColor
        cell.resetButton.titleLabel?.font = .systemFont(ofSize: ViewFrame.frame.width / 30)
    
        print(cell.playButton.titleLabel?.text)
        
        print(cell.timeLabel.text)
        
        return cell
        
    }
    
 
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("wahhaa")
        TableTableViewController.reloadAllowed = false
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        TableTableViewController.reloadAllowed = true 
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // setting the height of the cell:
        return view.frame.height / 10
    }
    
 

// unwinding from creating a new timer
    @IBAction func unwindFromCreation(segue: UIStoryboardSegue) {
     // checking wether the cell was edited or added
     
        if tableView.indexPathForSelectedRow == nil {
            print("no indexPath bruh...")
        if let modelToFill = segue.source as? CreatingTimerViewController {
           
            // creating a timer to append to array, if timer's minutes, seconds and hours are 0 then the if statement will do nothing and nothing will be added to the arrays:
            if modelToFill.seconds == 0 && modelToFill.minutes == 0 && modelToFill.hours == 0 {
            } else {
                
                // creting a new Timer2 instance to add to the array
                var nameToFill = ""
                for sound in SoundsData.soundFiles {
                    if sound.name ==  CreatingTimerViewController.soundName {
                        nameToFill = sound.file + ".wav"
                    }
                }
                if nameToFill == "" {
                    nameToFill = "COMCell_Message 1 (ID 1111)_BSB.wav"
                }
                let element = Timer2(seconds: modelToFill.seconds, minutes: modelToFill.minutes, hours: modelToFill.hours, name: modelToFill.name, isEnabled: false, notification: Task( name: modelToFill.name, completed: false, reminderEnabled: true, reminder: Reminder(timeInterval: TimeInterval((modelToFill.seconds + ((modelToFill.hours * 60 * 60)) + (modelToFill.minutes * 60))), date: nil, repeats: false), sound: nameToFill))
               
            
                
                
                // we append out timer to array
                TableTableViewController.timers.append(element)
           // append a cell model based on a timer
                TableTableViewController.cells.append(CellModel(cellNumber: element.objectIndex, currentHours: modelToFill.hours, currentMinutes: modelToFill.minutes, currentSeconds: modelToFill.seconds, name: modelToFill.name))
                // create a subscription between the static publisher of Timer2, so that when one of the timers "countdown" publisher would emit a "Set" of updatedValues that timer has calculated, and the timers unique number, then in TableTableViewController this subscription would find a CellModel in the array and update it's values:
                // and reload the rows upon receiving the values
                
                // creating a model using which you will reset all the timers if needed
                let modelToReset = TimeToReset(hours: modelToFill.hours, minutes: modelToFill.minutes, seconds: modelToFill.seconds)
                // appending the model to all the others
                TableTableViewController.originalTimers.append(modelToReset)
            
            }
            // removes the label from the superview, because there are multiple timers
            if TableTableViewController.cells.isEmpty == false {
                label.removeFromSuperview()
            }
            // update tableView to show the newly added cell
            tableView.reloadData()
        }
           
        } else {
            if let modelToFill = segue.source as? CreatingTimerViewController, let indexPath = tableView.indexPathForSelectedRow {
                
            if modelToFill.seconds == 0 && modelToFill.minutes == 0 && modelToFill.hours == 0 {
             // if user tries to update the cell with 0h 0m 0s
                // takes care of all the logic
                createAReusableErrorView(cell:  tableView.cellForRow(at: indexPath) ?? TableViewCell())
            createAReusableErrorLabel(cell: tableView.cellForRow(at: indexPath) ?? TableViewCell())
               
            var cell =  tableView.cellForRow(at: indexPath) ?? TableViewCell()
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, animations: {
                        
                        self.errorView.frame  = CGRect(x: self.view.frame.maxX + 300, y:  cell.frame.minY + 1 , width: self.view.frame.width / 1.8, height: cell.frame.height - 1)
                        
                        self.labelInError.frame =  CGRect(x: self.view.frame.maxX + 200 , y: cell.frame.maxY / 3.1, width: self.view.frame.width / 2, height:  cell.frame.height / 2.6)
                    }, completion: {_ in self.errorView.removeFromSuperview(); self.labelInError.removeFromSuperview()})
                }
                
            // if the cell was modified and the tableView.indexPathForSelectedRow is NOT Empty it fetches the currentViewController with all it's values and also fetches the index of a cell that was modified
            } else {
                
            if let newData = segue.source as? CreatingTimerViewController, let indexPath = tableView.indexPathForSelectedRow {
                
                
                // and updates all of the arrays based on the new / modified information
                // and reload the updated row:
                // reconfiguring a notification
              
                TableTableViewController.timers[indexPath.row].hours = newData.hours
                TableTableViewController.timers[indexPath.row].minutes = newData.minutes
                TableTableViewController.timers[indexPath.row].seconds = newData.seconds
                TableTableViewController.timers[indexPath.row].name = newData.name
                var nameToFill = ""
                for sound in SoundsData.soundFiles {
                    if sound.name ==  CreatingTimerViewController.soundName {
                        nameToFill = sound.file + ".wav"
                    }
                }
                if nameToFill == "" {
                    nameToFill = "COMCell_Message 1 (ID 1111)_BSB.wav"
                }
                TableTableViewController.timers[indexPath.row].notification.sound = nameToFill
                TableTableViewController.timers[indexPath.row].notification.reminder.timeInterval = TimeInterval((newData.seconds + ((newData.hours * 60 * 60)) + (newData.minutes * 60)))
                TableTableViewController.timers[indexPath.row].notification.name = newData.name
                TableTableViewController.originalTimers[indexPath.row].hours = newData.hours
                TableTableViewController.originalTimers[indexPath.row].minutes = newData.minutes
                TableTableViewController.originalTimers[indexPath.row].seconds = newData.seconds
                TableTableViewController.cells[indexPath.row].currentHours = newData.hours
                TableTableViewController.cells[indexPath.row].currentMinutes = newData.minutes
                TableTableViewController.cells[indexPath.row].currentSeconds = newData.seconds
                TableTableViewController.cells[indexPath.row].name = newData.name
             
                tableView.reloadRows(at: [indexPath], with: .none)
                
            }
            
            }
        }
        }
    }
    
    
    @IBSegueAction func segueFromCell(_ coder: NSCoder) -> CreatingTimerViewController? {
        
        print("segue from cell")
        if let cell =  tableView.cellForRow(at: tableView.indexPathForSelectedRow ?? IndexPath(row: 200, section: 0)) as? TableViewCell {
            
            print("workennnng")
            cell.resetButton.titleLabel?.font = .systemFont(ofSize: CreatingTimerViewController.view2.width / 30)
        }
// creates the placeholder variable fo IndexPath, because you are going to fill this variable with proper indexPath in `if let` statement.
        var indexPath = IndexPath()
        // force unwrapping the `tableView.indexPathForSelectedRow` and assigning a proper indexPath to a variable:
        if let indexPathofAnElement = tableView.indexPathForSelectedRow {
           indexPath = indexPathofAnElement
        }
        // creating a reference to the timer Model that you're going to modify :
        let timer = TableTableViewController.timers[indexPath.row]
  //stopping the timer
        timer.stop()
    var notification = TableTableViewController.timers[indexPath.row].notification
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notification.id])
        //updating the cell's Model after stopping the timer to match the "stopped state" of the timer:
        //NOTE: if the timer was already stopped we don't modify the cells array, because it has already been modified
        // also reloading the table view to update the interface of a cell, bu because we reloaded the cell, it means that it's not selected anymore and we have to select it in order for `unwindSegue` to work properly:
       
        
        let controller = CreatingTimerViewController(coder: coder, timer: timer)
        if TableTableViewController.cells[indexPath.row].playTapped == true && TableTableViewController.cells[indexPath.row].pauseTapped == false {
            TableTableViewController.cells[indexPath.row].pauseTapped = true
            TableTableViewController.cells[indexPath.row].playTapped = false
            tableView.reloadRows(at: [indexPath], with: .none)
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
        //creating a viewControllerInstance to return and filling it up with data
        return controller
    }
    
    // adding a new timer:
    @IBSegueAction func addSegue(_ coder: NSCoder) -> CreatingTimerViewController? {
        print("add segue")
        //creating a viewControllerInstance to return and filling it up with data
        return CreatingTimerViewController(coder: coder, timer: nil)
    }
    
    //disablig editing mode:
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
}



