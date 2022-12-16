//
//  PlayerWithScore.swift
//  PinochleScorerUI
//
//  Created by Tom Trompeter on 10/13/22.
//

import Foundation

struct PlayerWithScore {
    let playerName: String
    let playerScore: Int
}


//        What you need is to use custom class or structure and make array of it then find max score and after that filter your array with max score.
//        struct Player {
//            let name: String
//            let score: Int
//        }
//        Now create array of this Player structure
//        var players = [Player(name: "Bill", score: 10), Player(name: "Bob", score: 15), Player(name: "Sam", score: 12), Player(name: "Dave", score: 15)]
//        let maxScore = players.max(by: { $0.0.score < $0.1.score })?.score ?? 0
//        To get the array of player with max score use filter on array like this.
//        let allPlayerWithMaxScore = players.filter { $0.score == maxScore }
//        To get the array of index for player having high score use filter on array like this.
//        let indexForPlayerWithMaxScore = players.indices.filter { players[$0].score == maxScore }
//        print(indexForPlayerWithMaxScore) //[1, 3]
