//
//  SoundsViewController.swift
//  Timer
//
//  Created by Jeremy Merezhko on 8/31/22.
//

import UIKit
import AVFoundation
import Combine

class SoundsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AVAudioPlayerDelegate {
    
    var subscriptions = Set<AnyCancellable>()
    //var audioPlayer = AVAudioPlayer()
    var tableView = UITableView()
    var doneButton = UIButton()
    let selectedSound  = UILabel()
    let sortBy = UIButton()
    var subscriptionsCreated = 0
    
    static let willDisappear = PassthroughSubject<String, Never>()
     
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("STOPPED")
        if AudioPlayer.audioPlayer.isPlaying {
        AudioPlayer.audioPlayer.stop()
        
        SoundsData.soundFiles[ AudioPlayer.currentIndex.row].isPlaying = false
           
         
        }
        SoundsViewController.willDisappear.send("willDisappear")
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        SoundsData.soundFiles[indexPath.row].isSelected = true
  
     
        
        tableView.reloadData()
        print("reloading")
      
    }
    
    
     func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
         print( AudioPlayer.currentIndex)
         let cell = tableView.cellForRow(at:   AudioPlayer.currentIndex) as! SoundControllerCell
         SoundsData.soundFiles[ AudioPlayer.currentIndex.row].isPlaying = false
         cell.updateStart(v: SoundsData.soundFiles[ AudioPlayer.currentIndex.row].isPlaying)
         tableView.reloadRows(at: [ AudioPlayer.currentIndex], with: .none)
         AudioPlayer.audioPlayer  = AVAudioPlayer()
    }
   
    
    
  
    func start() {
        let pathToSound = Bundle.main.path(forResource: SoundsData.soundFiles[ AudioPlayer.currentIndex.row].file, ofType: "wav")!
        print("curent index = ",  AudioPlayer.currentIndex)
         print(pathToSound)
           do {
               print("player is playing", AudioPlayer.audioPlayer.isPlaying)
                let url = URL(fileURLWithPath: pathToSound)
                AudioPlayer.audioPlayer = try AVAudioPlayer(contentsOf: url)
                AudioPlayer.audioPlayer.delegate = self
                AudioPlayer.audioPlayer.play()
               //DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                   self.tableView.reloadRows(at: [ AudioPlayer.currentIndex], with: .none)
              // }
               if let cell = tableView.cellForRow(at:  AudioPlayer.currentIndex) {
                   cellPlaying = cell as! SoundControllerCell
                   cellPlaying.updateStart(v: true)
                  
               }
        } catch {
        
        }
}
    
    func stop() {
        AudioPlayer.audioPlayer.stop()
        cellPlaying.updateStart(v: false)
        if let indexPath = tableView.indexPath(for: cellPlaying) {
            tableView.reloadRows(at: [indexPath], with: .none)
        }
      
    }
    
    var cellPlaying = SoundControllerCell()
    func tappedSoundIcon() {
        
        SoundControllerCell.tapped.sink { value in
            
            
            
            
            if let current = self.tableView.indexPath(for: value) {
                AudioPlayer.currentIndex = current
                print("updated current index to: ", AudioPlayer.currentIndex)
                
                       if AudioPlayer.audioPlayer.isPlaying == false {
                           self.start()
                       } else {
                           if self.cellPlaying == value {
                               self.stop()
                           } else {
                               self.stop()
                              
                               self.start()
                               
                           }
                       }
            }
            
    
        }.store(in: &subscriptions)
    }
    
    func updateLabel() {
        SoundControllerCell.updateLabel.sink { value in
            
            self.selectedSound.text = value
            self.selectedSound.textColor = .black
        }.store(in: &subscriptions)
        
    }
    
  
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        SoundsData.soundFiles.count
       
    }
    
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        print( "reloading mf")
        var cell = tableView.dequeueReusableCell(withIdentifier: SoundControllerCell.identifier, for: indexPath) as! SoundControllerCell
        
        cell.descriptionLabel.text = SoundsData.soundFiles[indexPath.row].name
 
   
        cell.updateStart(v: SoundsData.soundFiles[indexPath.row].isPlaying)
       
                
        let pathToSound = Bundle.main.path(forResource: SoundsData.soundFiles[indexPath.row].file, ofType: "wav")!
        let asset = AVURLAsset(url: NSURL(fileURLWithPath: pathToSound) as URL, options: nil)
        let audioDuration = asset.duration
         let audioDurationSeconds = Int(CMTimeGetSeconds(audioDuration))
        
        cell.durationLabel.text = "Duration: \(audioDurationSeconds)s"

      
        
        print(SoundControllerCell.desc)
        print(SoundsData.soundFiles[indexPath.row].name)
 
          
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height / 15
    }
    
    

    override func viewWillLayoutSubviews() {
        view.addSubview(tableView)
    }
    
    @objc func unwindBack() {
        dismiss(animated: true  ,completion: nil )
    }
    
    
    override func viewDidLoad() {
        
        sortBy.isHidden = true
        self.view.frame = ViewFrame.frame
        super.viewDidLoad()
        
       
        if subscriptionsCreated == 0 {
        tappedSoundIcon()
        updateLabel()
            subscriptionsCreated += 1
        }
        AudioPlayer.audioPlayer.stop()
        tableView.reloadData()
        tableView.register(SoundControllerCell.self, forCellReuseIdentifier: SoundControllerCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = CGRect(x: view.frame.minX  + 10, y: view.frame.minY + 60, width: view.frame.width - view.frame.width / 21, height: view.frame.height - 20)
        tableView.layer.cornerRadius = 10
        tableView.backgroundColor = .bodyColor
        tableView.allowsSelection = false
        
        doneButton.frame = CGRect(x: view.frame.width / 1.24, y:  view.frame.minY + view.frame.maxY / 100 , width: view.frame.width / 6, height: view.frame.width / 10)
        doneButton.setTitle("Done", for: .normal)
        doneButton.backgroundColor = .bodyColor
        doneButton.setTitleColor(.black, for: .normal)
        doneButton.layer.cornerRadius = 10
        doneButton.addTarget(self, action: #selector(unwindBack), for: .touchUpInside)
        doneButton.titleLabel?.font = .systemFont(ofSize: view.frame.width / 23, weight: .regular)
        doneButton.dropShadow()
        view.addSubview(doneButton)
       
        selectedSound.text = "Tap on Sound To select"
        selectedSound.frame = CGRect(x: view.frame.width / 28, y:  view.frame.minY + view.frame.maxY / 100 , width: view.frame.width / 2, height: view.frame.width / 10)
        selectedSound.font = .systemFont(ofSize: view.frame.width / 23, weight: .regular)
        selectedSound.backgroundColor = .bodyColor
        selectedSound.clipsToBounds = true
        selectedSound.layer.cornerRadius = 10
        selectedSound.textAlignment = .center
        selectedSound.textColor = .black
        view.addSubview(selectedSound)
        
        view.backgroundColor = .bar2ControllerColor
    
        sortBy.frame = CGRect(x: view.frame.width / 28, y:  view.frame.minY + view.frame.maxY / 100 , width: view.frame.width / 6, height: view.frame.width / 10)
        
        sortBy.setTitle("Filter", for: .normal)
        sortBy.backgroundColor = .bodyColor
        sortBy.setTitleColor(.black, for: .normal)
        sortBy.layer.cornerRadius = 10
        sortBy.titleLabel?.font = .systemFont(ofSize: view.frame.width / 23, weight: .regular)
        sortBy.dropShadow()
        view.addSubview(sortBy)
    }
    
    

}
