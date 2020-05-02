//
//  CardCollectionViewCell.swift
//  App4MatchGame
//
//  Created by Nadia Mettioui on 20/04/2020.
//  Copyright © 2020 Nadia Mettioui. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var frontImageView: UIImageView!
    @IBOutlet weak var backImageView: UIImageView!
    var card : Card?
    
    func setCard(_ card: Card)  {
        //Keep track of the cars taht gets passed in
        self.card = card
        
        frontImageView.image = UIImage(named: card.imageName)
        
        //check if the cards are matched
        if  card.isMatched == true {
            backImageView.alpha = 0
            frontImageView.alpha = 0
            
            return
        }
        else {
               backImageView.alpha = 1
               frontImageView.alpha = 1
            
        }
        
        //Determine if the card is in a flipped card up state or flipped card down state
        if card.isFlipped == true {
            // Make sure that frontImage is on top
            UIView.transition(from: backImageView, to: frontImageView, duration: 0, options: [.transitionFlipFromLeft,.showHideTransitionViews], completion: nil)
            
            
        }
        else {
            // Make sure that backImage is on top => duration is 0 =W on doit pas voir l effet
            UIView.transition(from: frontImageView, to: backImageView, duration: 0, options: [.showHideTransitionViews, .transitionFlipFromLeft], completion: nil)
            
        }
        
    }
    func flip() {
        UIView.transition(from: backImageView, to: frontImageView, duration: 0.8, options: [.transitionFlipFromLeft,.showHideTransitionViews], completion: nil)
    }
    func flipBack() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            UIView.transition(from: self.frontImageView, to: self.backImageView, duration: 0.3, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
            
        }
        
    }
    
    func remove() {
        // remove both imageview from being visible
        backImageView.alpha = 0
        // TODO: Animate it
        UIView.animate(withDuration: 0.3, delay: 0.5, options: .curveEaseOut, animations: {
            self.frontImageView.alpha = 0
        }, completion: nil)
        
    }
    
}

