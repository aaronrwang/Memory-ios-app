//
//  CardCollectionViewCell.swift
//  Match App
//
//  Created by Aaron Wang on 9/4/20.
//  Copyright © 2020 Aaron Wang. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var frontImageView: UIImageView!
    
    
    @IBOutlet weak var backImageView: UIImageView!
    
    var card:Card?
    
    func configureCell(card:Card) {
        
        self.card = card
        frontImageView.image = UIImage(named: card.imageName)
        if card.isMatched == true{
            backImageView.alpha = 0
            frontImageView.alpha = 0
        } else {
            backImageView.alpha = 1
            frontImageView.alpha = 1
        }
        if card.isFlipped == true{
            flipUp(speed: 0)
        } else {
            flipDown(speed: 0)
        }
    }
    
    func flipUp(speed: TimeInterval = 0.3) {
        UIView.transition(from: backImageView, to: frontImageView, duration: speed, options: [.showHideTransitionViews, .transitionFlipFromLeft], completion: nil)
        card?.isFlipped = true
    }
    func flipDown(speed: TimeInterval = 0.3, time: TimeInterval = 0) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+time){
            UIView.transition(from: self.frontImageView, to: self.backImageView, duration: speed, options: [.showHideTransitionViews, .transitionFlipFromLeft], completion: nil)
        }
        
        
        card?.isFlipped = false
    }
    func remove(){
        //makes image invisible
        backImageView.alpha = 0
        UIView.animate(withDuration: 0.3, delay: 0.5, options: .curveEaseOut, animations: {self.frontImageView.alpha = 0}, completion: nil)
        
    }
}
