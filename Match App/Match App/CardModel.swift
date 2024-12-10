//
//  CardModel.swift
//  Match App
//
//  Created by Aaron Wang on 9/4/20.
//  Copyright © 2020 Aaron Wang. All rights reserved.
//

import Foundation

class CardModel {
    func getCards() -> [Card]{
        var generatedCards = [Card]()
        var dupeCheck = [Int]()
         while generatedCards.count < 16 {
            let randomNumber = Int.random(in: 1...13)
            if dupeCheck.contains(randomNumber) == false{
                dupeCheck += [randomNumber]
                let cardOne = Card()
                let cardTwo = Card()
                cardOne.imageName = "card\(randomNumber)"
                cardTwo.imageName = "card\(randomNumber)"
                generatedCards += [cardOne, cardTwo]
                print(randomNumber)
            }
        }
        generatedCards.shuffle()
        return generatedCards
    }
}
