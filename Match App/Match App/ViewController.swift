//
//  ViewController.swift
//  Match App
//
//  Created by Aaron Wang on 9/4/20.
//  Copyright © 2020 Aaron Wang. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    let model = CardModel()
    var cardsArray = [Card]()
    var firstFlippedCardIndex:IndexPath?
    var soundPlayer = SoundManager()
  
    var timer:Timer?
    var milliseconds:Int = 30*1000
        override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        cardsArray = model.getCards()
            collectionView.dataSource = self
            collectionView.delegate = self
            
            timer = Timer.scheduledTimer(timeInterval:  0.001, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
            RunLoop.main.add(timer!, forMode: .common)
    }
    override func viewDidAppear(_ animated: Bool) {
        soundPlayer.playSound(effect: .shuffle)
    }
    //MARK: - Timer Methods
    
    @objc func timerFired(){
        milliseconds -= 1
        let seconds:Double = Double(milliseconds)/1000.0
        timerLabel.text = String(format: "Time Remaining: %.2f", seconds)
        if milliseconds == 0{
            timerLabel.textColor = UIColor.red
            timer?.invalidate()
        }
        checkForGameEnd()
    }
    // MARK: - Collection View Delegate Methods

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cardCell = cell as? CardCollectionViewCell
        let card = cardsArray[indexPath.row]
        cardCell?.configureCell(card: card)
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if milliseconds <= 0{
            return
        }
        let cell = collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell
        
        if cell?.card?.isFlipped == false && cell?.card?.isFlipped == false{
            cell?.flipUp()
            soundPlayer.playSound(effect: .flip)

            if firstFlippedCardIndex == nil {
                firstFlippedCardIndex = indexPath
            } else {
               checkForMatch(indexPath)
            }
        }
    }
    // MARK: - Game Logic Methods
    func checkForMatch(_ secondFlippedCardIndex:IndexPath) {
        let cardOne = cardsArray[firstFlippedCardIndex!.row]
        let cardTwo = cardsArray[secondFlippedCardIndex.row]
        
        let cardOneCell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
        let cardTwoCell = collectionView.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell
        if cardOne.imageName == cardTwo.imageName {
            soundPlayer.playSound(effect: .match)

            cardOne.isMatched = true
            cardTwo.isMatched = true
            cardOneCell?.remove()
            cardTwoCell?.remove()
            checkForGameEnd()
        } else {
            soundPlayer.playSound(effect: .nomatch)
            cardOne.isFlipped = false
            cardTwo.isFlipped = false
            cardOneCell?.flipDown(time: 0.5)
            cardTwoCell?.flipDown(time: 0.5)
        }
        firstFlippedCardIndex = nil
    }
    func checkForGameEnd(){
        var hasWon = true
        for card in cardsArray {
            if card.isMatched == false{
                hasWon = false
                break
            }
        }
        if hasWon == true {
            showAlert(title: "Congratulations", message: "You've won the game!")
        } else {
            if milliseconds <= 0{
                showAlert(title: "Time's Up", message: "Sorry, better luck next time.")
                }
        }
        
    }
    func showAlert(title:String , message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
        
    }
}


