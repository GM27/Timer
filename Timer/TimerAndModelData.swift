//
//  modelData.swift
//  Timer
//
//  Created by Jeremy Merezhko on 5/10/22.
//

import Foundation
import Combine

class Timer2: Codable {
    // the subject that is going to send all the updates from timers:
    static let subject = PassthroughSubject<DataToRefil, Never>()
  
    // creating a new timer and increasing the objectsCreated by 1:
    init(seconds: Int, minutes: Int, hours: Int, name: String, isEnabled: Bool, notification: Task ) {
        self.seconds = seconds
        self.minutes = minutes
        self.hours = hours
        self.name = name
        self.isEnabled = isEnabled
        self.objectIndex = Timer2.objectsCreated
        Timer2.objectsCreated += 1
        self.notification = notification
    }
    
    static var objectsCreated = 0
    var objectIndex = 0
    // current hours:minutes:seconds that the timer has left:
    var seconds: Int
    var minutes: Int
    var hours: Int
    // name of each timer:
    var name: String
    // indicates wether the timer is enabled or not
    var isEnabled: Bool
    var timer: Timer?
    var notification: Task
    
    enum CodingKeys: String,  CodingKey {
       
    case objectIndex
    case seconds
    case minutes
    case hours
    case name
    case isEnabled
    case notification
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(objectIndex, forKey: .objectIndex)
        try container.encode(seconds, forKey: .seconds)
        try container.encode(minutes, forKey: .minutes)
        try container.encode(hours, forKey: .hours)
        try container.encode(name, forKey: .name)
        try container.encode(isEnabled, forKey: .isEnabled)
        try container.encode(notification, forKey: .notification)
        
        
      }
    
    
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.objectIndex = try container.decode(Int.self, forKey: .objectIndex)
        self.seconds = try container.decode(Int.self, forKey: .seconds)
        self.minutes = try container.decode(Int.self, forKey: .minutes)
        self.hours = try container.decode(Int.self, forKey: .hours)
        self.name = try container.decode(String.self, forKey: .name)
        self.isEnabled = try container.decode(Bool.self, forKey: .isEnabled)
        self.notification = try container.decode(Task.self, forKey: .notification)
       
      }
    
    
    
     func start(){
         timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerUpdate), userInfo: nil, repeats: true)
         self.isEnabled = true
    }
    func stop(){
        if let timer = timer {
            timer.invalidate()
            self.isEnabled = false
        }
    }
  
  
    @objc func timerUpdate() {
        
        if seconds > 0 {
            seconds -= 1
        } else {
            if minutes > 0 {
            minutes -= 1
            seconds = 60
            } else {
                if hours > 0  {
                hours -= 1
                    minutes = 59
                    seconds = 60
                } else {
                    if let timer = timer {
                    Timer2.subject.send(DataToRefil(hours: hours, minutes: minutes, seconds: seconds, cellToRefill: objectIndex))
                    timer.invalidate()
                      self.isEnabled = false
                    }
                }
            }
        }
        print("timer sending data:")
        
        print(hours, ":", minutes, ":", hours )
        Timer2.subject.send(DataToRefil(hours: hours, minutes: minutes, seconds: seconds, cellToRefill: objectIndex))
       
     }
    
}

// a struct to fixate the initial hours, minutes, seconds, of timers so you could easily reset them later:
struct TimeToReset: Codable {
    var hours: Int
    var minutes: Int
    var seconds: Int

}

// This struct is created for convenience as the format in which the publisher is going to send an information to a subscrinber
struct DataToRefil {
    var hours: Int
    var minutes: Int
    var seconds: Int
    var cellToRefill: Int
}


struct PrintingModel {
   static var pastDate = Date()
  static  var nowDate = Date()
    
}


