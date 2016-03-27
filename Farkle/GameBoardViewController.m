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
@property NSMutableArray *diceWithScores;
@property NSMutableArray *selectedDiceArray;


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
    self.selectedDiceArray = [NSMutableArray new];
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
    self.rollScore = 0;
    self.selectedDiceArray = [NSMutableArray new];


    
    self.scoreLabel.text = [NSString stringWithFormat:@"Score to add:"];
    
    
}

//triger from the button being pressed
- (IBAction)onChangeturnPressed:(UIButton *)sender {
    [self changeturn];
}


//code to run when the roll dice is pressed
- (IBAction)onRolldicePressed:(UIButton *)sender {
    
    self.rollScore = 0;
    
    self.rolledNumbers = [NSMutableArray new];
    NSNumber *number = [NSNumber new];
    
    //creates an array of random numbers and adds them to rolled numbers
    for (int i = 0; i <=5; i++) {
        int randomNumber = (arc4random_uniform (6) +1);
        number = [NSNumber numberWithInt:randomNumber];
        [self.rolledNumbers addObject:number];
        NSLog(@"%i is the %i random number",randomNumber, i);
        
        Dice *dice = [self.diceArray objectAtIndex:i];
        if (dice.isSelected) {
        } else {
        dice.scoreRolled = randomNumber;
        }
    }
    
    
    self.rollScore = [self ScoreToAdd];
    self.scoreLabel.text = [NSString stringWithFormat:@"Score to add: %i",self.rollScore];
    if (self.rollScore == 0) {
        self.scoreLabel.text = @"Farcle!";
    }
    
    self.diceWithScores = [NSMutableArray new];
    
    //creates the die images
    
    Dice *firstDice = [self.diceArray objectAtIndex:0];
    if (firstDice.isSelected) {
        NSLog(@"The first dice was selected");
        NSNumber *number = [NSNumber numberWithInt:firstDice.scoreRolled];
        NSString *dieOneImageName = [NSString stringWithFormat:@"saved%@", number];
        self.dice1.image = [UIImage imageNamed:dieOneImageName];
    }else {
        NSNumber *numberOne = [self.rolledNumbers objectAtIndex:0];
    NSString *dieOneImageName = [NSString stringWithFormat:@"%@", numberOne];
    self.dice1.image = [UIImage imageNamed:dieOneImageName];
    }
    
    
    Dice *secondDice = [self.diceArray objectAtIndex:1];
    if (secondDice.isSelected) {
        NSLog(@"The second dice was selected");
        NSNumber *number = [NSNumber numberWithInt:secondDice.scoreRolled];
        NSString *dieTwoImageName = [NSString stringWithFormat:@"saved%@", number];
        self.dice2.image = [UIImage imageNamed:dieTwoImageName];
    }else {
        NSNumber *number = [self.rolledNumbers objectAtIndex:1];
        NSString *dieImageName = [NSString stringWithFormat:@"%@", number];
        self.dice1.image = [UIImage imageNamed:dieImageName];
    }
    
    
    Dice *thirdDice = [self.diceArray objectAtIndex:2];
    if (thirdDice.isSelected) {
        NSLog(@"The third dice was selected");
        NSNumber *number = [NSNumber numberWithInt:thirdDice.scoreRolled];
        NSString *dieName = [NSString stringWithFormat:@"saved%@", number];
        self.dice3.image = [UIImage imageNamed:dieName];
    }else {
        NSNumber *number = [self.rolledNumbers objectAtIndex:2];
        NSString *dieImageName = [NSString stringWithFormat:@"%@", number];
        self.dice3.image = [UIImage imageNamed:dieImageName];
    }
    
    Dice *fourthDice = [self.diceArray objectAtIndex:3];
    if (fourthDice.isSelected) {
        NSLog(@"The fourth dice was selected");
        NSNumber *number = [NSNumber numberWithInt:fourthDice.scoreRolled];
        NSString *dieName = [NSString stringWithFormat:@"saved%@", number];
        self.dice4.image = [UIImage imageNamed:dieName];
    }else {
        NSNumber *number = [self.rolledNumbers objectAtIndex:3];
        NSString *dieImageName = [NSString stringWithFormat:@"%@", number];
        self.dice4.image = [UIImage imageNamed:dieImageName];
    }

    
    
    Dice *fifthDice = [self.diceArray objectAtIndex:4];
    if (fifthDice.isSelected) {
        NSLog(@"The fifth dice was selected");
        NSNumber *number = [NSNumber numberWithInt:fifthDice.scoreRolled];
        NSString *dieName = [NSString stringWithFormat:@"saved%@", number];
        self.dice5.image = [UIImage imageNamed:dieName];
    }else {
        NSNumber *number = [self.rolledNumbers objectAtIndex:4];
        NSString *dieImageName = [NSString stringWithFormat:@"%@", number];
        self.dice5.image = [UIImage imageNamed:dieImageName];
    }

    
    
    Dice *sixthDice = [self.diceArray objectAtIndex:5];
    if (sixthDice.isSelected) {
        NSLog(@"The sixth dice was selected");
        NSNumber *number = [NSNumber numberWithInt:sixthDice.scoreRolled];
        NSString *dieName = [NSString stringWithFormat:@"saved%@", number];
        self.dice6.image = [UIImage imageNamed:dieName];
    }else {
        NSNumber *number = [self.rolledNumbers objectAtIndex:5];
        NSString *dieImageName = [NSString stringWithFormat:@"%@", number];
        self.dice6.image = [UIImage imageNamed:dieImageName];
    }

    
    
}

//adds the scores from all the checks
-(int)ScoreToAdd {
    int oneScore = [self checkOnes];
    if (oneScore > 0) {
        [self checkForDieinRolledNumbersWithNSNumber:[NSNumber numberWithInt:1]];
    }
    int twoScore = [self checkTwos];
    if (twoScore > 0) {
        [self checkForDieinRolledNumbersWithNSNumber:[NSNumber numberWithInt:2]];
    }
    int threeScore = [self checkThrees];
    if (threeScore > 0) {
        [self checkForDieinRolledNumbersWithNSNumber:[NSNumber numberWithInt:3]];
    }
    int fourScore = [self checkFours];
    if (fourScore > 0) {
        [self checkForDieinRolledNumbersWithNSNumber:[NSNumber numberWithInt:4]];
    }
    int fiveScore = [self checkFives];
    if (fiveScore > 0) {
        [self checkForDieinRolledNumbersWithNSNumber:[NSNumber numberWithInt:5]];
    }
    int sixScore = [self checkSixes];
    if (sixScore > 0) {
        [self checkForDieinRolledNumbersWithNSNumber:[NSNumber numberWithInt:6]];
    }
    
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

-(void)checkForDieinRolledNumbersWithNSNumber:(NSNumber *)number {
    for (Dice *die in self.diceArray) {
        NSNumber *dieNumber = [NSNumber numberWithInt:die.scoreRolled];
        if (dieNumber == number) {
            die.isSelected = YES;
            [self.selectedDiceArray addObject:die];
        }
    }
    
    
}


@end

//Dice *firstDice = [self.diceArray objectAtIndex:0];
//if (firstDice.isSelected) {
//    NSNumber *number = [NSNumber numberWithInt:firstDice.scoreRolled];
//    NSString *dieOneImageName = [NSString stringWithFormat:@"saved%@", number];
//    self.dice1.image = [UIImage imageNamed:dieOneImageName];
//    [self.diceArray removeObject:firstDice];
//    self.diceAbleToRoll = self.diceAbleToRoll - 1;
//}else {
//    NSNumber *numberOne = [self.rolledNumbers objectAtIndex:0];
//    NSString *dieOneImageName = [NSString stringWithFormat:@"%@", numberOne];
//    self.dice1.image = [UIImage imageNamed:dieOneImageName];
//}
//
//
//NSNumber *numberTwo = [self.rolledNumbers objectAtIndex:1];
//NSString *dieTwoImageName = [NSString stringWithFormat:@"%@", numberTwo];
//self.dice2.image = [UIImage imageNamed:dieTwoImageName];
//
//
//NSNumber *numberThree = [self.rolledNumbers objectAtIndex:2];
//NSString *dieThreeImageName = [NSString stringWithFormat:@"%@", numberThree];
//self.dice3.image = [UIImage imageNamed:dieThreeImageName];
//
//NSNumber *numberFour = [self.rolledNumbers objectAtIndex:3];
//NSString *dieFourImageName = [NSString stringWithFormat:@"%@", numberFour];
//self.dice4.image = [UIImage imageNamed:dieFourImageName];
//
//
//NSNumber *numberFive = [self.rolledNumbers objectAtIndex:4];
//NSString *dieFiveImageName = [NSString stringWithFormat:@"%@", numberFive];
//self.dice5.image = [UIImage imageNamed:dieFiveImageName];
//
//
//NSNumber *numberSix = [self.rolledNumbers objectAtIndex:5];
//NSString *dieSixImageName = [NSString stringWithFormat:@"%@", numberSix];
//self.dice6.image = [UIImage imageNamed:dieSixImageName];

