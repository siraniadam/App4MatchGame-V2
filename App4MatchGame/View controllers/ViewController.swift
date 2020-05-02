//
//  ViewController.swift
//  App4MatchGame
//
//  Created by Nadia Mettioui on 20/04/2020.
//  Copyright © 2020 Nadia Mettioui. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var timingLabel: UILabel!
    
    var model = CardModel()
    var cardArray = [Card]()
    
    var firstFlippedCardIndex: IndexPath?
    
    
    var timer:Timer?
    var milliseconds: Float = 50 * 1000 // 10 sec
    // var soundManager = SoundManager()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Call the getCards method of the Card model
        cardArray = self.model.getCard()
        
        collectionView.dataSource = self
        collectionView?.delegate = self
        
        //create timer
        timer = Timer.scheduledTimer(timeInterval:
            0.001, target: self, selector: #selector(timerElapsed), userInfo: nil, repeats: true)
        // Problem qd on scroll le chrono stop
        RunLoop.main.add(timer!, forMode: .common)
        
    }
    
    override func viewDidAppear(_ animated: Bool) { // view appear lors que la vue apaparit user
       // soundManager.playSound(effect: .shuffle)
        
        SoundManager.playSound(effect: .shuffle)
    }
    //MARK: - Timer methods
    @objc func timerElapsed()
    {
        milliseconds -= 1
        
        // Convert to sec
        let seconds =  String(format: "%.2f", milliseconds / 1000) // cast en string et converti les milisecond en sec
        // setLabel
        timingLabel.text =  "Time Remaining : \(seconds)"
        // When timer = 0
        if milliseconds <= 0 {
            //Stop the Timer
            timer?.invalidate()
            timingLabel.textColor = .red
            //check if there aret any cards unmatched
            checkGameEnded()
        }
        
    }
    
    
    
    
    // MARK: - UICollectionView Protocol Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell  {
        // get a cardCollectionViewcell object
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath)
            as! CardCollectionViewCell//as! CardCollectionViewCell
        
        //Get the card that the collection view is trying to display
        let card = cardArray[indexPath.row]
        
        // Set that card for cell
        cell.setCard(card)
        
        return cell
    }
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Check if time is up
        
         
        
        if milliseconds <= 0 {
            return
        }
        // Get the cell thatt the user selected
        let cell = collectionView.cellForItem(at: indexPath) as! CardCollectionViewCell
        //  print(indexPath.row)
        // print(indexPath)
        // Get the card thatt the user selected
        let card = cardArray[indexPath.row]
        
        if card.isFlipped == false  && card.isMatched == false{
            //Flip the card
            cell.flip()
            
           SoundManager.playSound(effect: .flip)
            
            card.isFlipped = true
            
            // Determine if it s the First or Second Card that flipped over
            if firstFlippedCardIndex == nil {
                //this is the first card being flipped
                firstFlippedCardIndex = indexPath
            }
            else {
                //this is the second card being flipped
                checkForMAtches(indexPath)
                //  TODO: Perform the matching logic
            }
        }
        
        
        
        
    }// end didSelectItemAt
    
    
    
    
    // MARK: GameLogic Methods
    
    func checkForMAtches(_ secondFlippedCardindex: IndexPath) {
        
        // Get the cells for the two Cards that were revealed
        let cardOneCell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
        let cardTwoCell = collectionView.cellForItem(at: secondFlippedCardindex) as? CardCollectionViewCell
        //Get the cards for the two cards
        let cardOne = cardArray[firstFlippedCardIndex!.row]
        let cardTwo = cardArray[secondFlippedCardindex.row]
        
        //Compare the two card
        
        if cardOne.imageName == cardTwo.imageName {
            
            // it' s MAtch
            // Set teg status of the Card
            cardTwo.isMatched = true
            cardOne.isMatched = true
            SoundManager.playSound(effect: .match)
            // Remove the 2 Cards from grid
            cardTwoCell?.remove()
            cardOneCell?.remove()
            //check if there aret any cards unmatched
            checkGameEnded()
            
            
        } else {
            //it s not a match
            // set thet status of the two card
            cardOne.isFlipped = false
            cardTwo.isFlipped = false
            SoundManager.playSound(effect: .nomatch)
            
            // FlipBck
            cardOneCell?.flipBack()
            cardTwoCell?.flipBack()
        }
        // reinitialiser le track pour avertir que la first cars a ete flipped
        firstFlippedCardIndex = nil
        
        print(" \(cardOne.imageName) and  \(cardTwo.imageName)")
        
    }
    
    func checkGameEnded(){
        
        // Meassaging
        var title = ""
        var message = ""
        // Determine if ther any cards unmatched
        var isWon = true
        
        for card in cardArray {
            if card.isMatched == false {
                
                isWon = false
                break
            }
        }
        
        // if Not, then user has won , stopTimer
        if isWon == true {
            if milliseconds > 0 {
                timer?.invalidate()
            }
            // message Felicitations
            title = "Félicitations"
            message = "Vous avez gagné"
        }
        else {
            // ift there are inmatched cards , check if there s any time left
            if milliseconds > 0 {
                return
                
            }
            title = "Game Over"
            message = "Vous avez perdu"
            
        }
        // Show Won or Lost Messaging
        showAlert(title, message)
    }
    
    
    func showAlert(_ title: String, _ message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "ok", style: .default, handler: nil)
        alert.addAction(alertAction)
        present(alert,animated: true,completion: nil)
        
    }
    
    
}
// on cree une nnew file Card pour une meilleur organisation
//clasee CardModel {

//}
