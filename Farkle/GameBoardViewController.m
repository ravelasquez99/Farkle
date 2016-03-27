//
//  GameBoardViewController.m
//  Farkle
//
//  Created by Richard Velazquez on 3/26/16.
//  Copyright © 2016 Richard Velazquez. All rights reserved.
//

#import "GameBoardViewController.h"
#import "Dice.h"

@interface GameBoardViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *turnLabel;
@property (weak, nonatomic) IBOutlet UITableView *playersTableView;
@property (weak, nonatomic) IBOutlet UIButton *keepScoreButton;
@property (weak, nonatomic) IBOutlet UIImageView *dice1;
@property (weak, nonatomic) IBOutlet UIImageView *dice2;
@property (weak, nonatomic) IBOutlet UIImageView *dice3;
@property (weak, nonatomic) IBOutlet UIImageView *dice4;
@property (weak, nonatomic) IBOutlet UIImageView *dice5;
@property (weak, nonatomic) IBOutlet UIImageView *dice6;


@property Player *playerUp;
@property NSUInteger turnCounter;



@property NSMutableArray *diceArray;
@property NSMutableArray *rolledNumbers;



@end

@implementation GameBoardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    self.playersTableView.backgroundColor = [UIColor lightGrayColor];
    
    self.playerUp = [self.playersForGame objectAtIndex:0];
    self.turnLabel.text = [NSString stringWithFormat:@"%@'s turn",self.playerUp.name];
    self.turnLabel.backgroundColor = [UIColor grayColor];
    
    //initial game setup
    self.turnCounter = 1;
    [self.keepScoreButton setEnabled:NO];
    self.diceArray = [NSMutableArray new];
    [self createDice];

}

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
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.playersTableView dequeueReusableCellWithIdentifier:@"PLAYERCELL"];
    Player *player = [self.playersForGame objectAtIndex:indexPath.row];
    cell.textLabel.text = player.name;
    cell.backgroundColor = [UIColor lightGrayColor];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.playersForGame.count;
}


#pragma Game Mechanics

-(void)changeturn {
    if (self.turnCounter == self.playersForGame.count) {
        self.turnCounter = 1;
    } else {
        self.turnCounter++;
    }
    
    Player *nextPlayerUp = [self.playersForGame objectAtIndex:self.turnCounter-1];
    self.turnLabel.text = [NSString stringWithFormat:@"%@'s turn",nextPlayerUp.name];
    [self.playersTableView reloadData];
    
    
}

- (IBAction)onChangeturnPressed:(UIButton *)sender {
    [self changeturn];
}


- (IBAction)onRolldicePressed:(UIButton *)sender {
    
    self.rolledNumbers = [NSMutableArray new];
    NSNumber *number = [NSNumber new];
    
    //creates an array of random numbers and adds them to rolled numbers
    for (int i = 0; i <=5; i++) {
        int randomNumber = (arc4random_uniform (6) +1);
        number = [NSNumber numberWithInt:randomNumber];
        [self.rolledNumbers addObject:number];
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

    
   
    
}






//(arc4random_uniform (5) +1);
//        [die setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%i", randomNumber]] forState:UIControlStateNormal];
//        die.currentDieFace = randomNumber;
//    }
//}


@end
