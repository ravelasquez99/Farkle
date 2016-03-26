//
//  GameBoardViewController.m
//  Farkle
//
//  Created by Richard Velazquez on 3/26/16.
//  Copyright © 2016 Richard Velazquez. All rights reserved.
//

#import "GameBoardViewController.h"

@interface GameBoardViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *turnLabel;
@property (weak, nonatomic) IBOutlet UITableView *playersTableView;
@property Player *playerUp;
@property NSUInteger turnCounter;


@end

@implementation GameBoardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.playersTableView.backgroundColor = [UIColor lightGrayColor];
    
    self.playerUp = [self.playersForGame objectAtIndex:0];
    self.turnLabel.text = [NSString stringWithFormat:@"%@'s turn",self.playerUp.name];
    self.turnLabel.backgroundColor = [UIColor grayColor];
    
    //sets turn counter to 0
    self.turnCounter = 1;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

//add triggering event to call this method


@end
