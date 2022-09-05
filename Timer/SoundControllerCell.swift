//
//  SoundControllerCell.swift
//  Timer
//
//  Created by Jeremy Merezhko on 8/31/22.
//

import UIKit
import Combine


class SoundControllerCell: UITableViewCell {

    var subscriptions = Set<AnyCancellable>()
    static var identifier = "SoundControllerCell"
    static let tapped = PassthroughSubject<UITableViewCell, Never>()
    static let updateLabel = PassthroughSubject<String, Never>()
    static var selected = false
    static var selectedCell = SoundControllerCell()
   static var desc = "default"
      
  var count = 0
  
    func willDisappear() {
        SoundsViewController.willDisappear.sink { value in
            
            SoundControllerCell.selected = false
            SoundControllerCell.selectedCell.backgroundColor  = .clear
            SoundControllerCell.selectedCell = SoundControllerCell()
            CreatingTimerViewController.soundName = SoundControllerCell.desc
            print("willDisappearSet")
            
        }.store(in: &subscriptions)
        
    }
 
    
     

    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    
 var playingOrNot = false
    var gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(playSound))
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if count == 0 {
            willDisappear()
            print("sub created")
            count += 1
        }
       
      
    }

    @objc func playSound() {
        print("sent")
       
        SoundControllerCell.tapped.send(self)
       
    }
    
    func updateStart(v: Bool) {
        playingOrNot =  v
   
      
        
    }
    
    override func prepareForReuse() {
        self.backgroundColor = .clear
        
    }
    
    var color = UIColor()
    var updated = false
    
    func updateBackgroung(color: UIColor)  {
        self.color = color
        updated = true
        
       
    }
    
   @objc func changeBackground() {
       
       
       print("tapped button")
     
       if SoundControllerCell.selected == false {
        self.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.6, alpha: 0.3)
           print("gotcha bitch")
           SoundControllerCell.updateLabel.send(self.descriptionLabel.text!)
           SoundControllerCell.selected = true
           SoundControllerCell.selectedCell = self
           SoundControllerCell.desc = self.descriptionLabel.text!
          print(SoundControllerCell.desc)
       } else {
          if  self == SoundControllerCell.selectedCell {
               self.backgroundColor = .clear
              SoundControllerCell.selected = false
              SoundControllerCell.desc = "default"
             
          } else {
           print("gotcha bitch 2")
              SoundControllerCell.selected = false
              self.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.6, alpha: 0.3)
              SoundControllerCell.selectedCell.backgroundColor = .clear
             
              SoundControllerCell.updateLabel.send(self.descriptionLabel.text!)
              SoundControllerCell.selected = true
              SoundControllerCell.selectedCell = self
              SoundControllerCell.desc = self.descriptionLabel.text!
              }
            
        //  }
       }
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
      
      
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(playCover)
 
        contentView.addSubview(PlayView)
   
        contentView.addSubview(durationLabel)
        
        button.addTarget(self, action: #selector(playSound), for: .touchUpInside)
        contentView.addSubview(button)
        backgroundButton.addTarget(self, action: #selector(changeBackground), for: .touchUpInside)
        contentView.addSubview(backgroundButton)
   
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
      
      
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.bar2ControllerColor.cgColor
        descriptionLabel.frame = CGRect(x: contentView.frame.minX + 10, y:  contentView.frame.minY + 5, width: contentView.frame.width, height: 50)
        descriptionLabel.textColor = .black
        
        descriptionLabel.font = .systemFont(ofSize: contentView.frame.width / 23, weight: .regular)
        
        durationLabel.frame = CGRect(x: contentView.frame.minX + contentView.frame.width / 1.7, y:  contentView.frame.minY +  contentView.frame.height / 12, width: contentView.frame.width, height: 50)
        durationLabel.textColor =  .bar2ControllerColor
        
    
        durationLabel.font = .systemFont(ofSize: contentView.frame.width / 25, weight: .regular)
        
        
        playCover.frame = CGRect(x: contentView.frame.maxX -  contentView.frame.height  + contentView.frame.width / 140, y: contentView.frame.height / 10 , width:  contentView.frame.width / 8, height: contentView.frame.height / 1.23)
        playCover.image = UIImage(named: "playCover")
        
        
        PlayView.frame = CGRect(x: contentView.frame.maxX -  contentView.frame.height  + contentView.frame.width / 28, y: contentView.frame.height / 5 , width:  contentView.frame.width / 18, height: contentView.frame.height / 1.7)
        if playingOrNot == false {
        PlayView.image = UIImage(named: "playIcon")
           
            UIView.animate(withDuration: 0.2){
                
                self.playCover.transform  = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.PlayView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
            
        } else {
           
            self.PlayView.image = UIImage(named: "stopIcon")
            UIView.animate(withDuration: 0.2) {
                self.playCover.transform  = CGAffineTransform(scaleX: 0.9, y: 0.9)
                    self.PlayView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            
               
            }
           
        }
       
     
        
        button.backgroundColor = .clear
        button.frame = CGRect(x: contentView.frame.maxX -  contentView.frame.height  + contentView.frame.width / 28, y: contentView.frame.height / 5 , width:  contentView.frame.width / 18, height: contentView.frame.height / 1.7)
        
        backgroundButton.frame = CGRect(x: 0, y: 0, width: self.frame.width / 1.2, height: self.frame.height)
        
      
        
    }
    
    
    let descriptionLabel = UILabel()
    var PlayView = UIImageView()
    let button = UIButton()
    let durationLabel = UILabel()
    let playCover = UIImageView()
    let backgroundButton = UIButton()
    //let view = UIView()
}
