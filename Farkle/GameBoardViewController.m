//
//  GameBoardViewController.m
//  Farkle
//
//  Created by Richard Velazquez on 3/26/16.
//  Copyright © 2016 Richard Velazquez. All rights reserved.
//

#import "GameBoardViewController.h"
#import "Dice.h"


#pragma Properties
//sets the delegate and data source for the table view with the table view outlet setup

@interface GameBoardViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *playersTableView;

//sets a property for the current turn label so I can set who's turn it is
@property (weak, nonatomic) IBOutlet UILabel *turnLabel;

//adds the outlet for the UI button to keep the score you have. that way I can enable and disable it accordingly
@property (weak, nonatomic) IBOutlet UIButton *keepScoreButton;

//sets up the image outlets for the dice so the user can react accordingly
@property (weak, nonatomic) IBOutlet UIImageView *dice1;
@property (weak, nonatomic) IBOutlet UIImageView *dice2;
@property (weak, nonatomic) IBOutlet UIImageView *dice3;
@property (weak, nonatomic) IBOutlet UIImageView *dice4;
@property (weak, nonatomic) IBOutlet UIImageView *dice5;
@property (weak, nonatomic) IBOutlet UIImageView *dice6;

//these properties are neccesarry to run the game
@property int rollScore; //score of players role so we can add it to the score if kept label
@property Player *playerUp;
@property NSUInteger playerTurnInArrayCounter;
@property NSMutableArray *diceArray; //array of my dice properties
@property NSMutableArray *rolledNumbers; //array used to collect the results of the dice roll
@property int diceAbleToRoll;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;



@end

@implementation GameBoardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    self.playersTableView.backgroundColor = [UIColor lightGrayColor];
    
    self.playerUp = [self.playersForGame objectAtIndex:0];
    self.turnLabel.text = [NSString stringWithFormat:@"%@'s turn",self.playerUp.name];
    self.turnLabel.backgroundColor = [UIColor grayColor];
    
    //initial game setup
    self.playerTurnInArrayCounter = 1; //when the game starts the first player in the array is up
    [self.keepScoreButton setEnabled:NO];
    self.diceArray = [NSMutableArray new];
    [self createDice];
    self.diceAbleToRoll = 6;//sets the initial setting to 6. when a turn change happens this will be reset to 6

}

//creates the initial dice array
- (void)createDice {
    for (int i = 0; i <= 5; i++) {
        NSString *defaultImageName =[NSString stringWithFormat:@"%i",i];
        NSString *selectedImageName = [NSString stringWithFormat:@"saved%i",i];
        UIImage *defaultImage = [UIImage imageNamed:defaultImageName];
        UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
        
        Dice *dice = [[Dice alloc]initWithDefaultImage:defaultImage selectedImage:selectedImage andPlaceOnScreen:i];
        [self.diceArray addObject:dice];
    }

}

#pragma PlayerList Setup
//sets up the player table view cell. still need to add flexible row height and player score
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //says which cell we are working with
    UITableViewCell *cell = [self.playersTableView dequeueReusableCellWithIdentifier:@"PLAYERCELL"];
    
    //creates a temporary player object
    Player *player = [self.playersForGame objectAtIndex:indexPath.row];
    
    //sets the text to the players name
    cell.textLabel.text = player.name;
    
    //sets backround color for the cells
    cell.backgroundColor = [UIColor lightGrayColor];
    return cell;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.playersForGame.count;
}


#pragma Game Mechanics


-(void)changeturn {
    //if you reach the end of the circle reset it to one
    if (self.playerTurnInArrayCounter == self.playersForGame.count) {
        self.playerTurnInArrayCounter = 1;
    } else {
        self.playerTurnInArrayCounter++;
    }
    //says which player is next
    Player *nextPlayerUp = [self.playersForGame objectAtIndex:self.playerTurnInArrayCounter-1];
    self.turnLabel.text = [NSString stringWithFormat:@"%@'s turn",nextPlayerUp.name];
    
    //reloads the table view data with the scores. (not implemented yet)
    [self.playersTableView reloadData];
    
    //resets the dice available
    self.diceAbleToRoll = 6;
    
    self.scoreLabel.text = [NSString stringWithFormat:@"Score to add:"];
    
    
}

//triger from the button being pressed
- (IBAction)onChangeturnPressed:(UIButton *)sender {
    [self changeturn];
}


//code to run when the roll dice is pressed
- (IBAction)onRolldicePressed:(UIButton *)sender {
    
    self.rolledNumbers = [NSMutableArray new];
    NSNumber *number = [NSNumber new];
    
    //creates an array of random numbers and adds them to rolled numbers
    for (int i = 0; i <=self.diceAbleToRoll-1; i++) {
        int randomNumber = (arc4random_uniform (self.diceAbleToRoll) +1);
        number = [NSNumber numberWithInt:randomNumber];
        [self.rolledNumbers addObject:number];
        
        Dice *dice = [self.diceArray objectAtIndex:i];
        dice.scoreRolled = randomNumber;
    }
    
    //creates the die images
    NSNumber *numberOne = [self.rolledNumbers objectAtIndex:0];
    NSString *dieOneImageName = [NSString stringWithFormat:@"%@", numberOne];
    self.dice1.image = [UIImage imageNamed:dieOneImageName];
    
    
    NSNumber *numberTwo = [self.rolledNumbers objectAtIndex:1];
    NSString *dieTwoImageName = [NSString stringWithFormat:@"%@", numberTwo];
    self.dice2.image = [UIImage imageNamed:dieTwoImageName];

    
    NSNumber *numberThree = [self.rolledNumbers objectAtIndex:2];
    NSString *dieThreeImageName = [NSString stringWithFormat:@"%@", numberThree];
    self.dice3.image = [UIImage imageNamed:dieThreeImageName];
    
    NSNumber *numberFour = [self.rolledNumbers objectAtIndex:3];
    NSString *dieFourImageName = [NSString stringWithFormat:@"%@", numberFour];
    self.dice4.image = [UIImage imageNamed:dieFourImageName];

    
    NSNumber *numberFive = [self.rolledNumbers objectAtIndex:4];
    NSString *dieFiveImageName = [NSString stringWithFormat:@"%@", numberFive];
    self.dice5.image = [UIImage imageNamed:dieFiveImageName];

    
    NSNumber *numberSix = [self.rolledNumbers objectAtIndex:5];
    NSString *dieSixImageName = [NSString stringWithFormat:@"%@", numberSix];
    self.dice6.image = [UIImage imageNamed:dieSixImageName];
    
    self.rollScore = [self ScoreToAdd];
    self.scoreLabel.text = [NSString stringWithFormat:@"Score to add: %i",self.rollScore];
    
    
    //set roll score back to 0 for next turn
    self.rollScore = 0;
    
}

//adds the scores from all the checks
-(int)ScoreToAdd {
    int oneScore = [self checkOnes];
    int twoScore = [self checkTwos];
    int threeScore = [self checkThrees];
    int fourScore = [self checkFours];
    int fiveScore = [self checkFives];
    int sixScore = [self checkSixes];
    
    int finalScore = oneScore + twoScore + threeScore + fourScore + fiveScore + sixScore;
    
    if (finalScore == 0) {
        self.scoreLabel.text = @"FARKLE!";
    } else {
        [self.keepScoreButton setEnabled:YES];
    }
    return finalScore;
}

-(int)checkOnes {
    int numberToCheck = 1;
    int countOfOnes = 0;
    
    for (Dice *die in self.diceArray) {
        if (die.scoreRolled ==  numberToCheck) {
            countOfOnes = countOfOnes + 1;
        }else {}
    }
    
    int tripleScore = 1000;
    
    if (countOfOnes > 0 && countOfOnes <3) {
        int scoreToAdd = countOfOnes * 100;
        return scoreToAdd;
    } else if (countOfOnes == 3) {
        int scoreToAdd = tripleScore;
        return scoreToAdd;
    }else if (countOfOnes == 4){ // * 2
        int scoreToAdd = tripleScore * 2;
        return scoreToAdd;
    }else if (countOfOnes == 5){ // * 4
        int scoreToAdd = tripleScore * 4;
        return scoreToAdd;
    }else if (countOfOnes == 6){// * 8
        int scoreToAdd = tripleScore * 8;
        return scoreToAdd;
    }else {
        return 0;
    }
    
    
}

-(int)checkTwos {
    int numberToCheck = 2;
    int count = 0;
    
    for (Dice *die in self.diceArray) {
        if (die.scoreRolled ==  numberToCheck) {
            count = count + 1;
        }else {}
    }
    
    int tripleScore = 200;
    
    if (count == 3) {
        int scoreToAdd = tripleScore;
        return scoreToAdd;
    }else if (count == 4){ // * 2
        int scoreToAdd = tripleScore * 2;
        return scoreToAdd;
    }else if (count == 5){ // * 4
        int scoreToAdd = tripleScore * 4;
        return scoreToAdd;
    }else if (count == 6){// * 8
        int scoreToAdd = tripleScore * 8;
        return scoreToAdd;
    }else {
        return 0;
    }
    
}

-(int)checkThrees {
    int numberToCheck = 3;
    int count = 0;
    
    for (Dice *die in self.diceArray) {
        if (die.scoreRolled ==  numberToCheck) {
            count = count + 1;
        }else {}
    }
    
    int tripleScore = 300;
    
    if (count == 3) {
        int scoreToAdd = tripleScore;
        return scoreToAdd;
    }else if (count == 4){ // * 2
        int scoreToAdd = tripleScore * 2;
        return scoreToAdd;
    }else if (count == 5){ // * 4
        int scoreToAdd = tripleScore * 4;
        return scoreToAdd;
    }else if (count == 6){// * 8
        int scoreToAdd = tripleScore * 8;
        return scoreToAdd;
    }else {
        return 0;
    }
    
}

-(int)checkFours {
    int numberToCheck = 4;
    int count = 0;
    
    for (Dice *die in self.diceArray) {
        if (die.scoreRolled ==  numberToCheck) {
            count = count + 1;
        }else {}
    }
    
    int tripleScore = 400;
    
    if (count == 3) {
        int scoreToAdd = tripleScore;
        return scoreToAdd;
    }else if (count == 4){ // * 2
        int scoreToAdd = tripleScore * 2;
        return scoreToAdd;
    }else if (count == 5){ // * 4
        int scoreToAdd = tripleScore * 4;
        return scoreToAdd;
    }else if (count == 6){// * 8
        int scoreToAdd = tripleScore * 8;
        return scoreToAdd;
    }else {
        return 0;
    }
    
}


-(int)checkFives {
    int numberToCheck = 5;
    int count = 0;
    
    for (Dice *die in self.diceArray) {
        if (die.scoreRolled ==  numberToCheck) {
            count = count + 1;
        }else {}
    }
    
    int tripleScore = 500;
    
    if (count > 0 && count <3) {
        int scoreToAdd = count * 50;
        return scoreToAdd;
    }else if (count == 3) {
        int scoreToAdd = tripleScore;
        return scoreToAdd;
    }else if (count == 4){ // * 2
        int scoreToAdd = tripleScore * 2;
        return scoreToAdd;
    }else if (count == 5){ // * 4
        int scoreToAdd = tripleScore * 4;
        return scoreToAdd;
    }else if (count == 6){// * 8
        int scoreToAdd = tripleScore * 8;
        return scoreToAdd;
    }else {
        return 0;
    }
    
}

-(int)checkSixes {
    int numberToCheck = 6;
    int count = 0;
    
    for (Dice *die in self.diceArray) {
        if (die.scoreRolled ==  numberToCheck) {
            count = count + 1;
        }else {}
    }
    
    int tripleScore = 600;
    
    if (count == 3) {
        int scoreToAdd = tripleScore;
        return scoreToAdd;
    }else if (count == 4){ // * 2
        int scoreToAdd = tripleScore * 2;
        return scoreToAdd;
    }else if (count == 5){ // * 4
        int scoreToAdd = tripleScore * 4;
        return scoreToAdd;
    }else if (count == 6){// * 8
        int scoreToAdd = tripleScore * 8;
        return scoreToAdd;
    }else {
        return 0;
    }
    
}




-(void)deselectDice {
    //going to take in some sort of argument. deselect the dice and reload the images
}




@end
