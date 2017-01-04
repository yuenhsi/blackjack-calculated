//
//  ViewController.swift
//  blackjack-calculated
//
//  Created by Yuen Hsi Chang on 1/1/17.
//  Copyright © 2017 Yuen Hsi Chang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var dealerImageView: UIImageView!
    @IBOutlet weak var playerImageView: UIImageView!
    
    var numberOfPlayers: Int!
    var participantHands = [Hand]()
    var shoe: Shoe!
    var playerTurn: Bool!
    var validateGestures: Bool!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        validateGestures = false
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.hit)))
        self.view.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(self.stand)))
        startGame(extraPlayers: 0)
    }
    
    func startGame(extraPlayers: Int) {
        numberOfPlayers = extraPlayers + 1
        playerTurn = true
        pregame(extraPlayers: extraPlayers, numberOfDecks: 3)
        deal()
        startOthersTurn() // account for extra players
    }
    
    func pregame(extraPlayers: Int, numberOfDecks: Int) {
        shoe = Shoe(numberOfDecks: numberOfDecks)!
        shoe.shuffle()
        shoe.burn()
        if extraPlayers > 0 {
            for _ in 1 ... extraPlayers {
                participantHands.append(Hand(playerID: PlayerID.others))
            }

        }
        participantHands.append(Hand(playerID: PlayerID.player))
        participantHands.append(Hand(playerID: PlayerID.house))
    }
    
    func deal() {
        for _ in 1 ... 2 {
            for hand in participantHands {
                hand.addCard(card: shoe.draw(), vc: self)
            }
        }
    }
    
    func startOthersTurn() {
        for hand in participantHands {
            if hand.playerID == PlayerID.others {
                autoplay(hand: hand)
            }
            else if hand.playerID == PlayerID.player {
                validateGestures = true
            }
        }
    }
    
    func hit() {
        guard validateGestures == true else {
            return
        }
        // player's hand is always the second last item in hand array
        let hand = participantHands[participantHands.count - 2]
        hand.addCard(card: shoe.draw(), vc: self)
        if hand.getScore().min()! > 21 {
            validateGestures = false
            startDealerTurn()
        }
    }
    
    func stand() {
        guard validateGestures == true else {
            return
        }
        // player's hand is always the second last item in hand array
        validateGestures = false
        startDealerTurn()
    }
    
    func autoplay(hand: Hand) {
        return
    }
    
    func startDealerTurn() {
        showDealerHand()
        let hand = participantHands[participantHands.count - 1]
        while hand.getScore().min()! < 17 {
            hand.addCard(card: shoe.draw(), vc: self)
        }
        endGame()
    }
    
    func endGame() {
        var playerScore: Int!
        var dealerScore: Int!
        var gameOverText: String
        for hand in participantHands {
            if hand.playerID == PlayerID.player {
                playerScore = maxValidScore(scores: hand.getScore())
            }
            if hand.playerID == PlayerID.house {
                dealerScore = maxValidScore(scores: hand.getScore())
            }
        }
        if playerScore == -1 {
            gameOverText = "You busted!"
        } else if playerScore == dealerScore {
            gameOverText = "You're tied with the dealer; \(playerScore!) to \(dealerScore!)."
        } else if playerScore < dealerScore {
            gameOverText = "You've lost to the dealer; \(playerScore!) to \(dealerScore!)."
        } else {
            gameOverText = "You've beated the dealer; \(playerScore!) to \(dealerScore!)!"
        }
        
        let scoreLabel = UILabel()
        scoreLabel.text = gameOverText
        scoreLabel.frame = CGRect(x: 150, y: 150, width: 400, height: 20)
        view.addSubview(scoreLabel)
    }
    
    func updateBoard() {
        // populate imageViews
        for hand in participantHands {
            for (index, card) in hand.cards.enumerated() {
                var cardName: String
                if (index == 0 && hand.playerID == PlayerID.house) {
                    cardName = getFaceDownCardName()
                } else {
                    cardName = getCardName(card: card)
                }
                if hand.cardImage[index].image == nil {
                    hand.cardImage[index].image = UIImage(named: cardName)
                    view.addSubview(hand.cardImage[index])
                }
            }
        }
    }
    
    func showDealerHand() {
        let dealerHand = participantHands[participantHands.count - 1]
        dealerHand.cardImage[0].image = UIImage(named: getCardName(card: dealerHand.cards[0]))
    }
    
    func getFaceDownCardName() -> String {
        return "cardBack_blue3.png"
    }
    
    func getCardName(card: Card) -> String {
        return "card\(card.Suit.rawValue)\(card.Rank.rawValue).png"
    }
    
    func maxValidScore(scores: [Int]) -> Int {
        var max = -1
        for score in scores {
            if score <= 21 && score > max {
                max = score
            }
        }
        return max
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

