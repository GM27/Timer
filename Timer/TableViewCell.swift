//
//  TableViewCell.swift
//  Timer
//
//  Created by Jeremy Merezhko on 5/10/22.
//

import UIKit
import Combine


struct swipeLeftRight {
    var description: String
    var swipeLeft: Bool
}




class TableViewCell: UITableViewCell {
    
    
    var subscriptions = Set<AnyCancellable>()
    // subjects used to send the data from cell swipe to the TableTableViewController:
    static let TableViewCellSubjcet = PassthroughSubject<swipeLeftRight, Never>()
    static let playTapped = PassthroughSubject<SendCellAndButton, Never>()
    static let resetTapped = PassthroughSubject<SendCellAndButton, Never>()
    
    
    var toReloadWith = 0
    
    
    
    
    var passingButton = UIButton()
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
        playButton.titleLabel?.text = nil
        playButton.backgroundColor = nil
        self.layer.borderWidth = 0.5
        self.layer.borderColor  = UIColor.black.cgColor
        
       // timeLabel.text = nil
        
    }
   
    
    func updateWith(cellModel: CellModel, index: Int) {
    
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
      print("init style")
        contentView.backgroundColor = .cellColor
        contentView.addSubview(playButton)
        contentView.addSubview(resetButton)
      contentView.addSubview(timeLabel)
        contentView.addSubview(name)
       
        playButton.addTarget(self, action: #selector(playtapped), for: .touchUpInside)
        resetButton.addTarget(self, action: #selector(resetButtontapped), for: .touchUpInside)
       
        }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
 
    
    var playButton = UIButton()
     
  
    
    var resetButton = UIButton()
       
       
      
        
    
    
    var timeLabel = UILabel()
        
    
    
    var name = UILabel()
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        print("layout of subviews")
        
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.black.cgColor
        playButton.frame = CGRect(x: ViewFrame.frame.width / 40, y: ViewFrame.frame.maxY / 25, width: ViewFrame.frame.width / 6.1, height: ViewFrame.frame.height / 20)
        
        
        resetButton.frame = CGRect(x: ViewFrame.frame.width / 4.5, y:  ViewFrame.frame.maxY / 25, width: ViewFrame.frame.width / 6.1, height:  ViewFrame.frame.height / 20)
        
        timeLabel.frame = CGRect(x: ViewFrame.frame.width - (ViewFrame.frame.width / 2.5 + ViewFrame.frame.width / 60), y: ViewFrame.frame.height / 100, width: ViewFrame.frame.width / 2.5, height:  ViewFrame.frame.height / 13)
        
        
        name.frame = CGRect(x: ViewFrame.frame.width / 40 , y: ViewFrame.frame.maxY / 120, width: ViewFrame.frame.width / 2.5 , height:  ViewFrame.frame.height / 40)
       
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        var subsciption = TableTableViewController.subject.sink { value in
            self.toReloadWith = value
        }
        
        self.backgroundColor = UIColor.cellColor
        self.layer.borderWidth = 0.5
    }
    
    
    
    @objc func playtapped() {
        print("playtapped")
        TableViewCell.playTapped.send(SendCellAndButton.init(cell: self, button: playButton))
    }

    @objc func resetButtontapped() {
        print("reset tapped")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            TableViewCell.resetTapped.send(SendCellAndButton.init(cell: self, button: self.resetButton))
        }
        
        UIView.animate(withDuration: 0.1, animations: {self.resetButton.transform = CGAffineTransform(scaleX: 0.94, y: 0.94)}, completion: {_ in self.resetButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)})
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    
    }

    @objc func tapped() {
        print("Gesture")
        var swipeLeftRight = swipeLeftRight(description: self.description, swipeLeft: false )
        TableViewCell.TableViewCellSubjcet.send(swipeLeftRight)
        
        
    }
   

    @objc func tapped2() {
        print("gesture")
        var swipeLeftRight = swipeLeftRight(description: self.description, swipeLeft: true )
        TableViewCell.TableViewCellSubjcet.send(swipeLeftRight)
        
        
    }

    
}


struct SendCellAndButton {
    var cell = UITableViewCell()
    var button = UIButton()
}
