//
//  Card.swift
//  App4MatchGame
//
//  Created by Nadia Mettioui on 20/04/2020.
//  Copyright © 2020 Nadia Mettioui. All rights reserved.
//

import Foundation


class CardModel {
    
    func getCard() -> [Card] //  genere 2 card X8 => les mets dans un array et puis return  un array de card
    {
        // Declare an array to store numvbres we( ve already generated
        var generatedNumbersArray =  [Int]()
        // Declare a array to store the generated cards
        var generateCardsArray = [Card]()
        
        // Ramdomly generate pairs of cards
        while generatedNumbersArray.count < 8 {
            //get random number
            let randomNumber = arc4random_uniform(13) + 1
            if generatedNumbersArray.contains(Int(randomNumber)) == false {
                //Log the nb
                print("génére un chiffre au hasard \(randomNumber)")
                // Store the number into the generateNumberArray
                generatedNumbersArray.append(Int(randomNumber))
                
                
                
                
                //create the first card object
                let cardOne = Card()
                
                cardOne.imageName = "card\(randomNumber)"
                generateCardsArray.append(cardOne)
                
                //create the second card object
                let cardTwo = Card()
                cardTwo.imageName = "card\(randomNumber)"
                
                generateCardsArray.append(cardTwo)
                
                // Optional : make it so we only unique pairs of cards
            }
        }
        //  randomize the array
        
        for i in 0 ... generateCardsArray.count-1 {
            
            // find a randomize index to swap
            let randomNumber = Int(arc4random_uniform(UInt32(generateCardsArray.count)))
            // swap the cards
            let temporyStorage = generateCardsArray[i]
            generateCardsArray[i] =  generateCardsArray[randomNumber]
            generateCardsArray[randomNumber] =  temporyStorage
            
            
            
            
        }
        //return the array
        return generateCardsArray
    }
    
    
}
