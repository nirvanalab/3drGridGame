//
//  GridGameViewController.swift
//  threedrGridGame
//
//  Created by Vidhur Voora on 11/7/16.
//  Copyright © 2016 Vidhur Voora. All rights reserved.
//

import UIKit

class GridGameViewController: UIViewController {

  
  @IBOutlet weak var gridCollectionView: UICollectionView!
  
  @IBOutlet weak var player1ScoreLbl: UILabel!
  
  @IBOutlet weak var player2ScoreLbl: UILabel!
  
  
  @IBOutlet weak var autoStartSwitch: UISwitch!
  @IBOutlet weak var gameOverLbl: UILabel!
  let gameBrain = GameBrain.sharedInstance;
  
  var isPlayer1Turn = true;
  var gameTimer:Timer = Timer();
  var shouldSetup = true
  
  @IBOutlet weak var startGameBtn: UIButton!
  
    override func viewDidLoad() {
        super.viewDidLoad()

      //setup new game;
      gameBrain.setupNewGame();
      gridCollectionView.reloadData();
      self.shouldSetup = false
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  func movePlayer()  {
    
    if (gameBrain.gameTracker.gameOver) {
      gameOver()
      return
    }
    if ( isPlayer1Turn ) {
      gameBrain.movePlayer1()
      isPlayer1Turn = false
    }
    else {
      gameBrain.movePlayer2()
      isPlayer1Turn = true
    }
    
    self.gridCollectionView.reloadData()
  }
  
  func gameOver() {
    gameTimer.invalidate()
    self.gameOverLbl.isHidden = false;
    self.startGameBtn.isHidden = false;
    self.startGameBtn.isHidden = false;
    self.shouldSetup = true;
    self.player1ScoreLbl.text = String(gameBrain.gameScore.player1)
    self.player2ScoreLbl.text = String (gameBrain.gameScore.player2)
    if ( autoStartSwitch.isOn ) {
       startNewGame()
    }
   
  }
  
  func startNewGame() {
    if ( shouldSetup ) {
      gameBrain.reset()
      self.gridCollectionView.reloadData()
      shouldSetup = false
    }
    
    self.gameOverLbl.isHidden = true;
    self.startGameBtn.isHidden = true;
    gameTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.movePlayer), userInfo: nil, repeats: true);
  }
  
  @IBAction func startBtnClicked(_ sender: UIButton) {
    startNewGame()
  }
  
  
}
extension GridGameViewController : UICollectionViewDataSource,UICollectionViewDelegate {
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return gameBrain.gameMatrixCols
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    return gameBrain.gameMatrixRows
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridGameCellID",
                                                  for: indexPath) as! GridGameCollectionViewCell
    cell.circleView.layer.cornerRadius = cell.circleView.frame.width/2;
    cell.circleView.backgroundColor = UIColor(red: 255/255, green: 212/255, blue: 90/255, alpha: 1.0)
    cell.imageView.isHidden = true
    
    let pos:(Int,Int) = (indexPath.row,indexPath.section)
    
    if ( pos.0 == gameBrain.gameTracker.treasurePos.rowPos &&
        pos.1 == gameBrain.gameTracker.treasurePos.colPos) {
      cell.imageView.image = UIImage(named: "treasure")
      cell.imageView.isHidden = false;
    }
    
    if (pos.0 == gameBrain.gameTracker.player1Pos.rowPos &&
      pos.1 == gameBrain.gameTracker.player1Pos.colPos) {
       cell.imageView.image = UIImage(named: "panda")
      cell.imageView.isHidden = false;
    }
    
    if (pos.0 == gameBrain.gameTracker.player2Pos.rowPos &&
      pos.1 == gameBrain.gameTracker.player2Pos.colPos) {
      cell.imageView.image = UIImage(named: "bunny")
      cell.imageView.isHidden = false;
    }
    
    
    let player1Path = gameBrain.gameTracker.player1Path
    for (rowPos,colPos) in player1Path {
      if ( pos.0 == rowPos && pos.1 == colPos ) {
        cell.circleView.backgroundColor =  UIColor.orange
        break
      }
    }
    
    let player2Path = gameBrain.gameTracker.player2Path
    for (rowPos,colPos) in player2Path {
      if ( pos.0 == rowPos && pos.1 == colPos ) {
        cell.circleView.backgroundColor =  UIColor.red
        break
      }
    }
    
    return cell
  }
}
