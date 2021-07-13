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
    let USERWIN = 1, USERLOSE = 2 // display state for popup view
    
    // declaration to hide initial user view when showing popup view
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    
    // declaration of intial user view
    @IBOutlet weak var labelCounter: UILabel! // display the number of the instrument viewing
    @IBOutlet weak var labelLifeCounter: UILabel! // display the life left of the game
    @IBOutlet weak var labelHelpCounter: UILabel!
    @IBOutlet weak var imageInstrument: UIImageView!
    @IBOutlet weak var textFieldbyUser: UITextField!
    let bottomLine = CALayer()
    @IBOutlet weak var labelDisplayMessage: UILabel!
    let DEFAULTSTATE = 0, CORRECTANS = 1, INCORRECTANS = 2, SHOWANS = 3, EMPTYSTRING = 4
    @IBOutlet weak var button_Done: UIButton!
    @IBOutlet weak var button_Next: UIButton!
    
    // Define the paramters of the instrument
    struct instrument {
        var name : String
        var image : String
    }
    var instrumentlist: [instrument] = []
    var startindex = 0 // strat index for the instrument to be shown
    var lifeCount = 3, helpCount = 3, correctCount = 0
    
    // Create instrument and store in the list
    func createArray () -> [instrument] {
        var tempInstrument: [instrument] = []
        
        let instrument1 = instrument(name: "Triangle", image: "triangle")
        let instrument2 = instrument(name: "Guitar", image: "guitar")
        let instrument3 = instrument(name: "Keyboard", image: "keyboard")
        let instrument4 = instrument(name: "Bongos", image: "bongos")
        let instrument5 = instrument(name: "Violin", image: "violin")
        let instrument6 = instrument(name: "Saxophone", image: "saxophone")
        let instrument7 = instrument(name: "Keytar", image: "keytar")
        let instrument8 = instrument(name: "Harp" ,image: "harp")
        let instrument9 = instrument(name: "Piano",image: "piano")
        let instrument10 = instrument(name: "Trumpet", image: "trumpet")
        let instrument11 = instrument(name: "Drum Set", image: "drum-set")
        let instrument12 = instrument(name: "Clarinet", image: "clarinet")
        let instrument13 = instrument(name: "Accordion", image: "accordion")
        let instrument14 = instrument(name: "Bass", image: "bass")
        let instrument15 = instrument(name: "Chime", image: "chime")
        let instrument16 = instrument(name: "Cymbals", image: "cymbals")
        let instrument17 = instrument(name: "Horn", image: "horn")
        let instrument18 = instrument(name: "Maracas", image: "maracas")
        let instrument19 = instrument(name: "Trombone", image: "trombone")
        let instrument20 = instrument(name: "Xylophone", image: "xylophone")
        
        tempInstrument.append(instrument1)
        tempInstrument.append(instrument2)
        tempInstrument.append(instrument3)
        tempInstrument.append(instrument4)
        tempInstrument.append(instrument5)
        tempInstrument.append(instrument6)
        tempInstrument.append(instrument7)
        tempInstrument.append(instrument8)
        tempInstrument.append(instrument9)
        tempInstrument.append(instrument10)
        tempInstrument.append(instrument11)
        tempInstrument.append(instrument12)
        tempInstrument.append(instrument13)
        tempInstrument.append(instrument14)
        tempInstrument.append(instrument15)
        tempInstrument.append(instrument16)
        tempInstrument.append(instrument17)
        tempInstrument.append(instrument18)
        tempInstrument.append(instrument19)
        tempInstrument.append(instrument20)
        
        tempInstrument.shuffle()
        return tempInstrument
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // UI design
        visualEffectView.isHidden = true //hide the effect ensure behind can be clicked
        button_ok.layer.borderColor = UIColor.white.cgColor // popup ok buttong effect
        addUnderlineLinetoTextField()
        self.textFieldbyUser.delegate = self
        
        // initialise the instruments
        instrumentlist = createArray()
        setImage()
    }
    
    // UI design draw the text field with no border but a line
    func addUnderlineLinetoTextField(){
        bottomLine.frame = CGRect(x: 0, y: textFieldbyUser.frame.height-2, width: textFieldbyUser.frame.width, height: 1)
        bottomLine.backgroundColor = UIColor.init(red: 214/255, green: 214/255, blue: 214/255, alpha: 1).cgColor
        textFieldbyUser.borderStyle = .none
        textFieldbyUser.layer.addSublayer(bottomLine)
    }
    
    func setImage(){
        button_Next.isHidden = true
        button_Done.isEnabled = true
        setBottomLine_label_color(DEFAULTSTATE)
        textFieldbyUser.isEnabled = true
        textFieldbyUser.text=""
        lifeCount = 3 //reset the life count every image have three chances
        if(helpCount>0){
            button_help.isEnabled = true
        }
        labelLifeCounter.text = "X \(lifeCount)"
        imageInstrument.image = (UIImage(named: instrumentlist[startindex].image)!)
        labelCounter.text = "\(String(startindex+1))/\(instrumentlist.count)"
        
    }
    
    // only set the image when next is pressed
    @IBAction func button_next(_ sender: UIButton) {
        setImage()
    }
    
    // this will show the ans to user
    @IBOutlet weak var button_help: UIButton!
    @IBAction func button_help(_ sender: UIButton) {
        setBottomLine_label_color(DEFAULTSTATE)  // change back bottom line to grey color and no label shown
        helpCount-=1
        labelHelpCounter.text="X \(helpCount)"
        textFieldbyUser.text = instrumentlist[startindex].name
        
        if(helpCount==0){
            button_help.isEnabled = false
        }
    }
    
    // when button done is pressed
    @IBAction func button_done(_ sender: UIButton) {
        validateUserInput()
    }
    
    // when return or enter is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        validateUserInput()
        textField.resignFirstResponder() //this code will hide the keyboard if enter pressed
        return true
    }
    
    func textField(_ textField: UITextField,shouldChangeCharactersIn range: NSRange,replacementString string: String) -> Bool {
        setBottomLine_label_color(DEFAULTSTATE) // change back to grey color when user typing and no label shown
        return true
    }
    
    // change bottom line color and label shown
    func setBottomLine_label_color(_ colorType:Int){
        switch colorType {
        case CORRECTANS:
            labelDisplayMessage.text = "* Your answer is correct! You have \(correctCount) correct now!"
            bottomLine.backgroundColor = UIColor.init(red: 0/255, green: 255/255, blue: 0/255, alpha: 1).cgColor
            labelDisplayMessage.textColor = UIColor.init(red: 0/255, green: 255/255, blue: 0/255, alpha: 1)
            labelDisplayMessage.isHidden = false
            textFieldbyUser.isEnabled = false
            button_help.isEnabled = false
            button_Done.isEnabled = false
            button_Next.isHidden = false
        case INCORRECTANS:
            labelDisplayMessage.text = "* Incorrect Answer"
            bottomLine.backgroundColor = UIColor.init(red: 255/255, green: 0/255, blue: 0/255, alpha: 1).cgColor //make the line red color
            labelDisplayMessage.textColor = UIColor.init(red: 255/255, green: 0/255, blue: 0/255, alpha: 1)
            labelDisplayMessage.isHidden = false
        case SHOWANS:
            labelDisplayMessage.text = "* The correct answer is \(instrumentlist[startindex].name)."
            bottomLine.backgroundColor = UIColor.init(red: 188/255, green: 138/255, blue: 13/255, alpha: 1).cgColor //make the line red color
            labelDisplayMessage.textColor = UIColor.init(red: 188/255, green: 138/255, blue: 13/255, alpha: 1)
            labelDisplayMessage.isHidden = false
            textFieldbyUser.isEnabled = false
            button_help.isEnabled = false
            button_Done.isEnabled = false
            button_Next.isHidden = false
        case EMPTYSTRING:
            labelDisplayMessage.text = "* Plase key in some words"
            bottomLine.backgroundColor = UIColor.init(red: 195/255, green: 140/255, blue: 130/255, alpha: 1).cgColor //make the line red color
            labelDisplayMessage.textColor = UIColor.init(red: 195/255, green: 140/255, blue: 130/255, alpha: 1)
            labelDisplayMessage.isHidden = false
        default:
            bottomLine.backgroundColor = UIColor.init(red: 214/255, green: 214/255, blue: 214/255, alpha: 1).cgColor
            labelDisplayMessage.isHidden = true
            
        }
    }
    
    func validateUserInput(){
        // to avoid empty and space string deduct the life
        if(textFieldbyUser.text!.trimmingCharacters(in: .whitespaces).isEmpty){
            setBottomLine_label_color(EMPTYSTRING)
        }
        else{
            // correct answer
            if(textFieldbyUser.text?.lowercased().trimmingCharacters(in: .whitespaces)==instrumentlist[startindex].name.lowercased()){
                correctCount+=1
                setBottomLine_label_color(CORRECTANS)
                validateLastInput()
            }
            // wrong answer
            else{
                lifeCount-=1
                labelLifeCounter.text = "X \(lifeCount)"
                if(lifeCount>0){setBottomLine_label_color(INCORRECTANS)}
                else {
                    setBottomLine_label_color(SHOWANS)
                    validateLastInput()
                }
                
            }
        }
    }
    func validateLastInput(){
        if(startindex+1==instrumentlist.count){
            button_Next.isHidden = true // hide the next button if last question
            let passGrade = (instrumentlist.count%2==1 ? (instrumentlist.count/2)+1 : instrumentlist.count/2)
            if(correctCount>=passGrade) {animatePopUp(USERWIN)}
            else {animatePopUp(USERLOSE)}
        }
        else{
            startindex+=1
        }
    }
    
    
    // DIY popup menu
    func animatePopUp(_ userResult:Int){
        if(userResult==USERWIN){
            labelPopupTitle.text = "Congratulation!"
            labelPopupContent.text = "You have achieved a score of \(correctCount)/\(instrumentlist.count) ."
            popUpImageView.image = (UIImage(named:"win"))
        }
        else{
            labelPopupTitle.text = "Oh nooo..."
            labelPopupContent.text = "You only have a score of \(correctCount)/\(instrumentlist.count)."
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

