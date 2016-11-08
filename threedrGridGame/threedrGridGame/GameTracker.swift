//
//  GameTracker.swift
//  threedrGridGame
//
//  Created by Vidhur Voora on 11/7/16.
//  Copyright © 2016 Vidhur Voora. All rights reserved.
//

import Foundation

//Data struct to keep track of the game
struct GameTracker {
  var treasurePos:(rowPos:Int,colPos:Int) = (0,0)
  var player1Pos:(rowPos:Int,colPos:Int) = (0,0)
  var player2Pos:(rowPos:Int,colPos:Int) = (0,0)
  var player1Path:Array<(rowPos:Int,colPos:Int)> = Array()
  var player2Path:Array<(rowPos:Int,colPos:Int)> = Array()
  var gameOver = false
  
}

//Keeps track of the score
struct GameScore {
  var player1 = 0
  var player2 = 0
}
