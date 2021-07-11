//
//  ViewController.swift
//  assignment2
//
//  Created by gohpeijin on 10/07/2021.
//  Copyright © 2021 pj. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    //DIY popup view declaration
    @IBOutlet weak var popupView: UIView! // the whole pop up view container
    @IBOutlet weak var popUpImageView: UIImageView!
    @IBOutlet weak var labelPopupTitle: UILabel!
    @IBOutlet weak var labelPopupContent: UILabel!
    @IBOutlet weak var button_ok: UIButton! // use to close the whole screen to main menu
    let USERWIN = 1, USERLOSE = 2
    
    // declaration to hide initial user view
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    
    // declaration of intial user view
    @IBOutlet weak var labelCounter: UILabel! // display the number of the instrument viewing
    @IBOutlet weak var labelLifeCounter: UILabel! // display the life left of the game
    @IBOutlet weak var imageInstrument: UIImageView!
    @IBOutlet weak var textFieldbyUser: UITextField!
    
    //    var effect: UIVisualEffect!
    
    // Define the paramters of the instrument
    struct instrument {
        var name : String
        var image : String
    }
    var instrumentlist: [instrument] = []
    var startindex = 0 // strat index for the instrument to be shown
    var lifeCount = 3
    
    // Create instrument and store in the list
    func createArray () -> [instrument] {
        var tempInstrument: [instrument] = []
        
        let instrument1 = instrument(name: "Triangle", image: "triangle")
        let instrument2 = instrument(name: "Guitar", image: "guitar")
        //        let instrument3 = instrument(name: "Keyboard Piano", image: "keyboard_piano")
        //        let instrument4 = instrument(name: "Bongos", image: "bongos")
        //        let instrument5 = instrument(name: "Violin", image: "violin")
        //        let instrument6 = instrument(name: "Saxophone", image: "saxophone")
        //        let instrument7 = instrument(name: "Keytar", image: "keytar")
        //        let instrument8 = instrument(name: "Harp" ,image: "harp")
        //        let instrument9 = instrument(name: "Grand Piano",image: "grand-piano")
        //        let instrument10 = instrument(name: "Trumpet", image: "trumpet")
        //        let instrument11 = instrument(name: "Drum Set", image: "drum-set")
        //        let instrument12 = instrument(name: "Clarinet", image: "clarinet")
        
        tempInstrument.append(instrument1)
        tempInstrument.append(instrument2)
        //        tempInstrument.append(instrument3)
        //        tempInstrument.append(instrument4)
        //        tempInstrument.append(instrument5)
        //        tempInstrument.append(instrument6)
        //        tempInstrument.append(instrument7)
        //        tempInstrument.append(instrument8)
        //        tempInstrument.append(instrument9)
        //        tempInstrument.append(instrument10)
        //        tempInstrument.append(instrument11)
        //        tempInstrument.append(instrument12)
        
        tempInstrument.shuffle()
        return tempInstrument
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        visualEffectView.isHidden = true //hide the effect ensure behind can be clicked
        button_ok.layer.borderColor = UIColor.white.cgColor // popup ok buttong effect
        //        textFieldbyUser.borderStyle = .roundedRect
        addUnderlineLinetoTextField()
        
        instrumentlist = createArray()
        
        self.textFieldbyUser.delegate = self
        setImage()
        
    }
    
    func addUnderlineLinetoTextField(){
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: textFieldbyUser.frame.height-2, width: textFieldbyUser.frame.width, height: 2)
        bottomLine.backgroundColor = UIColor.init(red: 214/255, green: 214/255, blue: 214/255, alpha: 1).cgColor
        textFieldbyUser.borderStyle = .none
        textFieldbyUser.layer.addSublayer(bottomLine)
    }
    
    func setImage(){
        textFieldbyUser.text=""
        lifeCount = 3 //reset the life count every image have three chances
        labelLifeCounter.text = "X \(lifeCount)"
        imageInstrument.image = (UIImage(named: instrumentlist[startindex].image)!)
        labelCounter.text = "\(String(startindex+1))/\(instrumentlist.count)"
        
    }
    
    @IBAction func button_done(_ sender: UIButton) {
        done_enter_pressed()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        done_enter_pressed()
        textField.resignFirstResponder() //this code will hide the keyboard if enter pressed
        return true
    }
    
    func done_enter_pressed(){
        
        if(textFieldbyUser.text?.lowercased().trimmingCharacters(in: .whitespaces)==instrumentlist[startindex].name.lowercased()){
            if(startindex+1==instrumentlist.count){
                animatePopUp(USERWIN)
            }
            else{
                startindex+=1
                setImage()
            }
            
        }
        else{
            lifeCount-=1
            labelLifeCounter.text = "X \(lifeCount)"
            if(lifeCount<1){
                animatePopUp(USERLOSE)
            }
        }
    }
    
    // DIY popup menu
    func animatePopUp(_ userResult:Int){
        
        if(userResult==USERWIN){
            labelPopupTitle.text = "Congratulation!"
            labelPopupContent.text = "You have won the game."
            popUpImageView.image = (UIImage(named:"win"))
        }
        else{
            labelPopupTitle.text = "Oh nooo..."
            labelPopupContent.text = "You have run out of life."
            popUpImageView.image = (UIImage(named:"lose"))
        }
        
        self.view.addSubview(popupView)
        visualEffectView.isHidden = false
        popupView.center = self.view.center
        
        popupView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        popupView.alpha = 0
        
        UIView.animate(withDuration: 0.4){
            self.popupView.alpha=1
            self.popupView.transform = CGAffineTransform.identity
        }
        
    }
    
    @IBAction func button_close(_ sender: UIButton) {
        // Dismiss the scene – make it disappear
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func button_ok(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //disable landscape mode
    override var shouldAutorotate: Bool{
        return false
    }
}

