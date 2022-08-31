//
//  ViewController.swift
//  Timer
//
//  Created by Jeremy Merezhko on 5/10/22.
//

import UIKit



class ViewController: UIViewController  {
   
    static var view2 = CGRect() {
        
        didSet {
            print(view2)
        }
    }
    required init? (coder: NSCoder, timer: Timer2?) {
        self.timer = timer
        super.init(coder: coder)
   
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
   
    }
  
    
    
    override func viewDidLoad()  {
        ViewController.view2 = view.frame
        ViewFrame.frame = view.frame
        
        self.view.backgroundColor = UIColor.bodyColor
        super.viewDidLoad()
       
        self.overrideUserInterfaceStyle = UIUserInterfaceStyle.dark
        
    if let timer = timer {
        UI()
        nameLabel.text = timer.name
        timeLabelHours.text = String(timer.hours)
        timeLabelMinutes.text = String(timer.minutes)
        timeLabelSeconds.text = String(timer.seconds)
     
        name = nameLabel.text ?? ""
        hours = timer.hours
        minutes = timer.minutes
        seconds = timer.seconds
   
// everythings okay
    if hours < 10 {
        timeLabelHours.text = String(" \(0)\(hours)")
    } else {
    timeLabelHours.text = String(hours)
    }
    if minutes < 10 {
        timeLabelMinutes.text = String(" \(0)\(minutes)")
    } else {
    timeLabelMinutes.text = String(minutes)
        }
    if seconds < 10 {
        timeLabelSeconds.text = String(" \(0)\(seconds)")
    } else {
    timeLabelSeconds.text = String(seconds)
        }
    navigationItem.title =  "Edit"
    navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
    self.navigationController?.navigationBar.tintColor = UIColor.black
    navigationItem.rightBarButtonItem?.tintColor = UIColor.black
    
} else {
    UI()
    navigationItem.title = "Create New Timer"
    

    navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
   self.navigationController?.navigationBar.tintColor = UIColor.black
    navigationItem.rightBarButtonItem?.tintColor = UIColor.black
}

}
    

    // all declarations
    var timer: Timer2?
    var name = ""
    var hours = 0
    var minutes = 0
    var seconds = 0
  

    var nameLabel = TextField()
   
       var overlayOnPicker = UIView()
   var timeSetButton = UIButton()
   var picker = UIPickerView()
   var viewAfterButton = UIView()
    
    var timeLabelMinutes = UILabel()
    var timeLabelSeconds = UILabel()
    var timeLabelHours = UILabel()
    var semicolon1 = UILabel()
    var semicolon2 = UILabel()
    var timelabelsView = UIView()
    @IBOutlet weak var justHoursLabel: UILabel!
    @IBOutlet weak var justMinutesLabel: UILabel!
    @IBOutlet weak var justSecondsLabel: UILabel!
    

    
    
    @objc func playTapped(_ sender: UIButton) {
    
        if picker.isHidden == true {
            picker.isHidden = false
            justHoursLabel.isHidden = false
            justMinutesLabel.isHidden = false
            justSecondsLabel.isHidden = false
          
            print(Int(self.timeLabelHours.text!) ?? 99999)
            print(Int(self.timeLabelMinutes.text!) ?? 66666)
            print(Int(self.timeLabelSeconds.text!) ?? 66666)
            UIView.animate(withDuration: 0.2, animations: {
                sender.transform = CGAffineTransform(scaleX: 0.94, y: 0.94)
                self.moveDown(toY: 20)
            },completion: { _ in
                self.picker.selectRow(self.hours, inComponent: 0, animated: true)
                self.picker.selectRow(self.minutes, inComponent: 1, animated: true)
                self.picker.selectRow(self.seconds, inComponent: 2, animated: true)
                })
        
        } else {
            UIView.animate(withDuration: 0.1, animations:  {
                self.moveUp(toY: 810)
                sender.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.picker.selectRow(0 ,inComponent: 0, animated: true)
                self.picker.selectRow(0, inComponent: 1, animated: true)
                self.picker.selectRow(0, inComponent: 2, animated: true)
            },
        completion: {_ in
                self.picker.isHidden = true
                self.justHoursLabel.isHidden = true
                self.justMinutesLabel.isHidden = true
                self.justSecondsLabel.isHidden = true
             
               
            })
               
        }
       
    
       
    }

    
    // saving the name to the variable if editing changed or ended
    @objc func  editingEnded() {
        name = nameLabel.text  ?? "bruyh"
        print("does this work")
    }
    
    
 

    func UI() {
        // assigning data source and hiding everything that is supposed to be hidden
        picker.dataSource = self
        picker.delegate = self
        picker.isHidden = true
        justHoursLabel.isHidden = true
        justMinutesLabel.isHidden = true
        justSecondsLabel.isHidden = true
      
       
        
        
        // name label configuration:
        nameLabel.frame = CGRect(x: view.frame.width / 32, y:  (navigationController?.navigationBar.frame.maxY ?? 99999) + view.frame.maxY / 89.6, width: view.frame.width - ((view.frame.width / 41.4) * 2), height: view.frame.height / 20)
        nameLabel.tintColor = .black
        nameLabel.delegate = self
        nameLabel.textColor = .black
        nameLabel.layer.cornerRadius = 10
        nameLabel.backgroundColor = UIColor.timelabelColor
        nameLabel.font = .systemFont(ofSize: view.frame.height / 59.7)
        nameLabel.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        view.addSubview(nameLabel)
        nameLabel.addTarget(self, action: #selector(editingEnded), for: .editingChanged)
    // /////////////////////////////////////////////////////////////////////
        
        
        // timeSetButton configuration:
        timeSetButton.frame = CGRect(x: view.frame.width / 41.4 , y: nameLabel.frame.maxY +  view.frame.maxY / 50 , width: view.frame.width / 2.5, height: view.frame.height / 19)
        timeSetButton.backgroundColor = UIColor.timelabelColor
        timeSetButton.titleLabel?.font = .systemFont(ofSize: view.frame.height / 56, weight: .regular)
        timeSetButton.setTitleColor(.black, for: .normal)
        timeSetButton.setTitle("Set The Time", for: .normal)
        timeSetButton.layer.cornerRadius = 10
        timeSetButton.addTarget(self, action: #selector(playTapped), for: .touchUpInside)
        view.addSubview(timeSetButton)
        // ////////////////////////////
        
        
        // timeLabelHours configuration:
        timeLabelHours.frame = CGRect(x: timeSetButton.frame.maxX + (view.frame.maxX / 8), y: nameLabel.frame.maxY + view.frame.height / 45, width: view.frame.width / 10, height: view.frame.width / 10)
        timeLabelHours.text = "00"
        timeLabelHours.font = .systemFont(ofSize: view.frame.height / 35.84)
        timeLabelHours.textColor = .white
        timeLabelHours.textAlignment = .center
        view.addSubview(timeLabelHours)
        // ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        
        
      
        
        
        
        

        // timelabelMinutes configuration:
        timeLabelMinutes.frame = CGRect(x: timeLabelHours.frame.maxX + (view.frame.maxX / 20), y: nameLabel.frame.maxY + view.frame.height / 45 ,
                                        width: view.frame.width / 10, height: view.frame.width / 10)
        timeLabelMinutes.text = "00"
        timeLabelMinutes.font = .systemFont(ofSize: view.frame.height / 35.84)
        timeLabelMinutes.textColor = .white
        timeLabelMinutes.textAlignment = .center
        view.addSubview(timeLabelMinutes)
        // ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        
        
        // timeLabelSeconds configuration:
        timeLabelSeconds.frame = CGRect(x: timeLabelMinutes.frame.maxX + (view.frame.maxX / 20), y: nameLabel.frame.maxY + view.frame.height / 45, width: view.frame.width / 10, height: view.frame.width / 10)
        timeLabelSeconds.text = "00"
        timeLabelSeconds.font = .systemFont(ofSize: view.frame.height / 35.84)
        timeLabelSeconds.textColor = .white
        timeLabelSeconds.textAlignment = .center
        view.addSubview(timeLabelSeconds)
        
        
        //semicolon1 configuration:
        semicolon1.frame =  CGRect(x: timeLabelHours.frame.minX + (timeLabelHours.frame.width / 1.42), y: nameLabel.frame.maxY + view.frame.height / 50, width: view.frame.width / 10, height: view.frame.width / 10)
        semicolon1.text = ":"
        semicolon1.font = .systemFont(ofSize: view.frame.height / 35.84)
        semicolon1.textColor = .white
        semicolon1.textAlignment = .center
        view.addSubview(semicolon1)
        
        // semicolon2:
        semicolon2.frame =  CGRect(x: timeLabelMinutes.frame.minX + (timeLabelHours.frame.width / 1.42), y: nameLabel.frame.maxY + view.frame.height / 50, width: view.frame.width / 10, height: view.frame.width / 10)
        semicolon2.text = ":"
        semicolon2.font = .systemFont(ofSize: view.frame.height / 35.84)
        semicolon2.textColor = .white
        semicolon2.textAlignment = .center
        view.addSubview(semicolon2)
        
        
        // configuraion of the view that holds justHoursLabel, justMinutesLabel, and justSecondsLabel:
        timelabelsView.backgroundColor = .black
        timelabelsView.layer.cornerRadius = 10
        view.addSubview(timelabelsView)
        view.bringSubviewToFront(timeLabelHours)
        view.bringSubviewToFront(timeLabelMinutes)
        view.bringSubviewToFront(timeLabelSeconds)
        view.bringSubviewToFront(semicolon1)
        view.bringSubviewToFront(semicolon2)
        
        
        
        // viewAfterButton
        viewAfterButton.frame = CGRect(x: 0, y: timeSetButton.frame.maxY + (view.frame.maxY / 40) , width: view.frame.width,  height: view.frame.height / 280)
        viewAfterButton.backgroundColor = .black
        view.addSubview(viewAfterButton)
        // /////////////////////////////////////////////////////////////////////////////////////////////////////////////
        

        
        
        // picker configuration:
        picker.frame = CGRect(x: 0, y: 0, width: view.frame.width, height:  view.frame.height / 4.14)
        picker.overrideUserInterfaceStyle = UIUserInterfaceStyle.light
        view.addSubview(picker)
        
       // configuring timelabelsView frame
        // configuting the textColor and font of labels
        timelabelsView.frame = CGRect(x: view.frame.width / 1.9 , y: nameLabel.frame.maxY +  view.frame.maxY / 50, width: view.frame.width / 2.24, height: view.frame.width / 10)
        justHoursLabel.frame  = CGRect(x: view.frame.maxX / 9.84, y: 0, width: view.frame.width / 9.40 , height: view.frame.height / 33.18)
        justHoursLabel.font = .systemFont(ofSize: view.frame.height / 45)
        justHoursLabel.textColor = .black
        justMinutesLabel.frame = CGRect(x: view.frame.maxX / 1.84, y: 0, width: view.frame.width / 9.40, height: view.frame.height / 33.18)
        justMinutesLabel.font = .systemFont(ofSize: view.frame.height / 45)
        justMinutesLabel.textColor = .black
        justSecondsLabel.frame = CGRect(x: view.frame.maxX / 1.16, y: 0, width: view.frame.width / 9.40, height:  view.frame.height / 33.18)
        justSecondsLabel.font = .systemFont(ofSize: view.frame.height / 45)
        justSecondsLabel.textColor = .black
      
        // //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        
        
       // overlayOnPicker  configuration
        overlayOnPicker.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.6, alpha: 0.7)
        overlayOnPicker.alpha = 0.7
        overlayOnPicker.layer.cornerRadius = 15
        overlayOnPicker.frame  = CGRect(x: 5, y: 0, width: 409, height: view.frame.height / 25.6)
        picker.addSubview(overlayOnPicker)
        picker.bringSubviewToFront(overlayOnPicker)
      // //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   
    }
    


// moving the pickers frame down
func moveDown(toY: Int) {
    picker.frame = CGRect(x: 0, y:  view.frame.maxY / 3.80, width: view.frame.width, height:  view.frame.height / 4.14)
    justHoursLabel.frame  = CGRect(x: view.frame.maxX / 4.5, y: view.frame.maxY / 2.7, width: view.frame.width / 8 , height: view.frame.height / 33.18)
    justMinutesLabel.frame = CGRect(x: view.frame.maxX / 1.84, y: view.frame.maxY / 2.7, width: view.frame.width / 9.40, height: view.frame.height / 33.18)
    justSecondsLabel.frame = CGRect(x: view.frame.maxX / 1.16, y: view.frame.maxY / 2.7, width: view.frame.width / 9.40, height:  view.frame.height / 33.18)
    overlayOnPicker.frame  = CGRect(x: view.frame.maxX / 179.2 , y: view.frame.maxY / 10, width: view.frame.width / 1.02  , height: view.frame.height / 25.6)
   
}
    // moving the picker's frame up at the time of an animation after Set The Time
    func moveUp(toY: Int) {
        picker.frame = CGRect(x: 0, y: toY, width: 414, height: 216)
        justHoursLabel.frame  = CGRect(x: 91, y: toY + 96, width: 44, height: 27)
        justMinutesLabel.frame = CGRect(x: 225, y: toY + 96, width: 44, height: 27)
        justSecondsLabel.frame = CGRect(x: 356, y: toY + 96, width: 44, height: 27)
        overlayOnPicker.frame = CGRect(x: 5, y: toY - 720, width: 409, height: 35)
    }
    
}




// MARK: Picker Delegate and DataSource and TextFieldDataSource
extension ViewController: UIPickerViewDataSource {
    
    // number of components in picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    //  number of rows in picker
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
      

        switch component {
        case 0:
            return 13
        case 1:
            return 61
        case 2:
            return 61
        default:
            return 3
        }
        
       
    }
}
extension ViewController: UIPickerViewDelegate {
   // row height in picker
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return CGFloat(Double(ViewController.view2.height) / 29.8)
    }
    
    // configuring the font size and color for a row in picker
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label = UILabel()
               if let v = view {
                   label = v as! UILabel
               }
        label.font = .systemFont(ofSize: CGFloat(ViewController.view2.height / 35) )
     
               label.text =  String(row)
               label.textAlignment = .center
               return label
    }
  
    
 //  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent //component: Int) -> String? {
        // updating names for picker
       
   // }
    
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
      // updatitng a bunch of labels with time selected  and saving it to variables
        switch component {
        case 0:
         
            hours = row
            timeLabelHours.text = String(hours)
            if hours < 10 {
                timeLabelHours.text = String(" \(0)\(hours)")
                
                
            } else {
            timeLabelHours.text = String(hours)
                }
          
        case 1:
            minutes = row
            if minutes < 10 {
                timeLabelMinutes.text = String(" \(0)\(minutes)")
            } else {
            timeLabelMinutes.text = String(minutes)
                }
        case 2:
            seconds = row
            if seconds < 10 {
                timeLabelSeconds.text = String(" \(0)\(seconds)")
            } else {
            timeLabelSeconds.text = String(seconds)
                }
        default:
            return
        }
    }
    
    
}


// just for hiding the keyboard at appropriate time
extension ViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
       
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return (true)
    }
    
    
}

