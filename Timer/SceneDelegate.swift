//
//  SceneDelegate.swift
//  Timer
//
//  Created by Jeremy Merezhko on 5/10/22.
//

import UIKit
import Foundation
import Combine
import UserNotifications

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
       
        print("will connect to")
  
          
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
      
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        let encodingItems = EncodingItems(timers: TableTableViewController.timers, objectsCreated: Timer2.objectsCreated, originalTimers: TableTableViewController.originalTimers, cells: TableTableViewController.cells)
        Encode.encode(encodingItems: encodingItems)
        
      for timer in TableTableViewController.timers {
           
            if timer.isEnabled == true {
            timer.stop()
          timer.isEnabled = true
            }
          
          
         
    }
       
        
    }
       
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
var index = 0
   
    func sceneWillEnterForeground(_ scene: UIScene) {
        index = 0
        print("will enter foreground")
        let model = Encode.decode()
        
     
        
        TableTableViewController.timers = model.timers
        TableTableViewController.originalTimers = model.originalTimers
        TableTableViewController.cells = model.cells
        Timer2.objectsCreated = model.objectsCreated
        TableTableViewController.wokeUp = true
         let nowDate = Date()
          
          let difference =  nowDate.timeIntervalSince(model.exitDate)
         
         
          var hours = difference.hour
          var minutes = difference.minute
        let seconds = difference.second
          var indicesToReloadAt = [IndexPath]()
          for elem in TableTableViewController.timers {
              if elem.isEnabled == true {
                  
                  let total = elem.seconds + ((elem.minutes * 60) + (elem.hours * 60 * 60))
                  print(total)
                  print(Int(difference))
                  if total > Int(difference) {
                      elem.hours -= hours
                      if elem.minutes >= minutes {
                          elem.minutes -= minutes
                        
                      } else {
                          let advantage = minutes - elem.minutes
                        elem.hours -= 1
                          elem.minutes = 60
                          elem.minutes -= advantage
                      }
                      if seconds <= elem.seconds {
                          elem.seconds -= seconds
                        
                      } else {
                          let advantage = seconds - elem.seconds
                          if minutes < 1 {
                              hours -= 1
                              minutes = 60
                              elem.minutes -= 1
                                elem.seconds = 60
                                elem.seconds -= advantage
                          } else {
                          elem.minutes -= 1
                            elem.seconds = 60
                            elem.seconds -= advantage
                              print(advantage)
                          }
                      }
                      print("not the case ")
                      print(index)
                      TableTableViewController.cells[index].currentHours =  elem.hours
                      TableTableViewController.cells[index].currentMinutes =  elem.minutes
                      TableTableViewController.cells[index].currentSeconds =  elem.seconds
                      print(TableTableViewController.cells[index])
                    
                      let random = Double.random(in: 0.2...0.7)
                     
                          DispatchQueue.main.asyncAfter(deadline: .now() + random) {
                              elem.start()
                           
                          }
                  } else {
                      print("thats the case")
                      print(TableTableViewController.originalTimers)
                      elem.hours = TableTableViewController.originalTimers[index].hours
                      elem.minutes = TableTableViewController.originalTimers[index].minutes
                      elem.seconds = TableTableViewController.originalTimers[index].seconds
                      elem.isEnabled = false
                      TableTableViewController.cells[index].currentHours = TableTableViewController.originalTimers[index].hours
                      TableTableViewController.cells[index].currentMinutes = TableTableViewController.originalTimers[index].minutes
                   TableTableViewController.cells[index].currentSeconds = TableTableViewController.originalTimers[index].seconds
                    TableTableViewController.cells[index].playTapped = false
                   TableTableViewController.cells[index].pauseTapped = true
                      indicesToReloadAt.append(IndexPath(row: index, section: 0))
                  }
              }
              
              index += 1
          }
        TableTableViewController.indicesToReloadAt = indicesToReloadAt
        NotificationCenter.default.post(name: NSNotification.Name("ReloadNotification"), object: nil)
    
    }
   
    func sceneDidEnterBackground(_ scene: UIScene) {
       
      
    }

}
