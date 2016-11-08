//
//  GameBrain.swift
//  threedrGridGame
//
//  Created by Vidhur Voora on 11/7/16.
//  Copyright © 2016 Vidhur Voora. All rights reserved.
//

import UIKit

//Main logic for running the game
// Could have setup as a Struct instead of Class since it mostly deals with values
class GameBrain: NSObject {
  
  //shared instance
  static let sharedInstance =  GameBrain()
  
  var gameTracker:GameTracker =  GameTracker()
  var gameScore:GameScore = GameScore()
  
  let gameMatrixRows = 5
  let gameMatrixCols = 5
  
  var isPlayer1Turn = true;
  
  //random initial treasure position
  func fetchNewTreasurePosition() -> (row:Int,col:Int) {
    var randomRow:Int = 0
    var randomCol:Int = 0
    while  randomRow == 0
      || randomRow == gameMatrixRows-1 {
          randomRow = Int(arc4random())%gameMatrixRows
    }
    while randomCol == 0
      || randomCol == gameMatrixCols-1 {
        randomCol = Int(arc4random())%gameMatrixCols
    }
    return (randomRow,randomCol)
  }
  
  //random initial player position
  func fetchNewPlayerPositions() -> Array<(Int,Int)> {
    
    var p1Row:Int = Int(arc4random())%2;
    var p1Col:Int = Int(arc4random())%2;

    p1Row = (p1Row == 0 ) ? 0 : gameMatrixRows-1
    p1Col = (p1Col == 0 ) ? 0 : gameMatrixCols-1
    
    var p2Row:Int = p1Row
    var p2Col:Int = p1Col
    
    while ( p1Row == p2Row && p1Col == p2Col ) {
      
      p2Row = Int(arc4random())%2;
      p2Col = Int(arc4random())%2;
      p2Row = (p2Row == 0 ) ? 0 : gameMatrixRows-1
      p2Col = (p2Col == 0 ) ? 0 : gameMatrixCols-1
    }
    
    return [(p1Row,p1Col),(p2Row,p2Col)]
  }
  
  //reset game
  func reset() {
    gameTracker = GameTracker()
    setupNewGame()
  }

  //sets new game positions
  func setupNewGame() {
    
    //set treasure position
    let treasurePos:(Int,Int) = fetchNewTreasurePosition();
    gameTracker.treasurePos = treasurePos;
    
    //set player 1 & player 2 position
    let playerPos = fetchNewPlayerPositions();
    gameTracker.player1Pos = playerPos[0]
    gameTracker.player1Path.append(playerPos[0]);
    gameTracker.player2Pos = playerPos[1]
    gameTracker.player2Path.append(playerPos[1]);

  }
  
  //directions
  func moveRight(pos:(row:Int,col:Int))->(rowPos:Int,colPos:Int) {
    return (pos.row,pos.col+1)
  }
  
  func moveLeft(pos:(row:Int,col:Int))->(rowPos:Int,colPos:Int) {
    return (pos.row,pos.col-1)
  }
  
  func moveDown(pos:(row:Int,col:Int))->(rowPos:Int,colPos:Int) {
    return (pos.row+1,pos.col)
  }
  
  func moveUp(pos:(row:Int,col:Int))->(rowPos:Int,colPos:Int) {
    return (pos.row-1,pos.col)
  }
  
  
  func isPosInPlayer1Path(pos:(row:Int,col:Int)) -> Bool {
    for (row,col) in gameTracker.player1Path {
      if ( pos.row == row &&
        pos.col == col) {
        return true;
      }
    }
    return false;
  }
  
  func indexOfPosInPath(items: Array<(Int,Int)>,pos:(Int,Int)) -> Int {
    var index = 0
    for (row,col) in items {
      if ( pos.0 == row &&
        pos.1 == col) {
        return index;
      }
      index += 1
    }
    return index;
  }
  
  func removePosFromPath(items: Array<(Int,Int)>,pos:(Int,Int)) -> Array<(Int,Int)> {
    var newPath:Array<(Int,Int)> = Array()
    
    for (row,col) in items {
      if ( !(pos.0 == row &&
        pos.1 == col)) {
        newPath.append((row,col))
      }
    }
    return newPath;
  }
  
  
  func isPosInPlayer2Path(pos:(row:Int,col:Int)) -> Bool {
    for (row,col) in gameTracker.player2Path {
      if ( pos.row == row &&
        pos.col == col) {
        return true;
      }
    }
    return false;
  }
  
  func movePlayer()
  {
    if ( isPlayer1Turn ) {
      movePlayer1()
      isPlayer1Turn = false
    }
    else {
      movePlayer2()
      isPlayer1Turn = true
    }
  }
  
  func movePlayer1()
  {
    var waitingToMove = true
    
    while (waitingToMove) {
      let direction = Int(arc4random())%4
      var pos:(Int,Int)
      switch direction {
      case 0:
        pos = moveUp(pos: (row:gameTracker.player1Pos.rowPos,col:gameTracker.player1Pos.colPos) )
      case 1:
        pos = moveDown(pos: (row:gameTracker.player1Pos.rowPos,col:gameTracker.player1Pos.colPos) )
      case 2:
        pos = moveLeft(pos: (row:gameTracker.player1Pos.rowPos,col:gameTracker.player1Pos.colPos) )
      case 3:
        pos = moveRight(pos: (row:gameTracker.player1Pos.rowPos,col:gameTracker.player1Pos.colPos) )
      default:
        pos = (row:gameTracker.player1Pos.rowPos,col:gameTracker.player1Pos.colPos)
      }
      
      if  pos.0 >= 0 && pos.0 <= gameMatrixRows-1 &&
        pos.1 >= 0 && pos.1 <= gameMatrixCols-1 &&
        !isPosInPlayer2Path(pos: (row: pos.0, col: pos.1)){
        
        if ( isPosInPlayer1Path(pos: (row: pos.0, col: pos.1))) {
          //if already existing remove it from the path
          gameTracker.player1Path = removePosFromPath(items: gameTracker.player1Path, pos: gameTracker.player1Pos)
        }
        
        gameTracker.player1Pos = pos
        gameTracker.player1Path.append(pos)
        //check if treasure path
        if ( pos.0 == gameTracker.treasurePos.rowPos &&
          pos.1 == gameTracker.treasurePos.colPos) {
          gameTracker.gameOver = true;
          gameScore.player1 += 1
        }
        waitingToMove = false
      }
    }
  }
  
  func movePlayer2()
  {
    var waitingToMove = true
    
    while (waitingToMove) {
      let direction = Int(arc4random())%4
      var pos:(Int,Int)
      switch direction {
      case 0:
        pos = moveUp(pos: (row:gameTracker.player2Pos.rowPos,col:gameTracker.player2Pos.colPos) )
      case 1:
        pos = moveDown(pos: (row:gameTracker.player2Pos.rowPos,col:gameTracker.player2Pos.colPos) )
      case 2:
        pos = moveLeft(pos: (row:gameTracker.player2Pos.rowPos,col:gameTracker.player2Pos.colPos) )
      case 3:
        pos = moveRight(pos: (row:gameTracker.player2Pos.rowPos,col:gameTracker.player2Pos.colPos) )
      default:
        pos = (row:gameTracker.player2Pos.rowPos,col:gameTracker.player2Pos.colPos)
      }
      
      if  pos.0 >= 0 && pos.0 <= gameMatrixRows-1 &&
        pos.1 >= 0 && pos.1 <= gameMatrixCols-1 &&
         !isPosInPlayer1Path(pos: (row: pos.0, col: pos.1)){
        
        if ( isPosInPlayer2Path(pos: (row: pos.0, col: pos.1))) {
          //if already existing remove it from the path
          gameTracker.player2Path = removePosFromPath(items: gameTracker.player2Path, pos: gameTracker.player2Pos)
        
        }
        
        gameTracker.player2Pos = pos
        gameTracker.player2Path.append(pos)
        if ( pos.0 == gameTracker.treasurePos.rowPos &&
          pos.1 == gameTracker.treasurePos.colPos) {
          gameTracker.gameOver = true;
          gameScore.player2 += 1
        }
        waitingToMove = false
      }
    }
  }

}
