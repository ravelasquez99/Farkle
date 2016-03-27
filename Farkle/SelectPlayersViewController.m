//
//  SelectPlayersViewController.m
//  Farkle
//
//  Created by Richard Velazquez on 3/24/16.
//  Copyright © 2016 Richard Velazquez. All rights reserved.
//

#import "SelectPlayersViewController.h"
#import "Player.h"
#import "GameBoardViewController.h"



@interface SelectPlayersViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *playerListTableView;
@property NSMutableArray *playerNames;
@property NSMutableArray *players;
@property NSMutableArray *selectedPlayers;
@property NSMutableArray *bgColors;
@property (weak, nonatomic) IBOutlet UITextField *enteredPlayerNameTextField;
@property (weak, nonatomic) IBOutlet UIButton *startGamebutton;

@end

@implementation SelectPlayersViewController


#pragma ViewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.playerListTableView.delegate = self;
    self.playerListTableView.dataSource = self;
    self.playerNames =[NSMutableArray arrayWithArray:@[@"Ricky", @"Michael", @"Jesus Christ"]];
    self.players = [NSMutableArray new];

    [self createPlayers];
    
    self.selectedPlayers = [NSMutableArray new];
    
    [self.startGamebutton setEnabled:NO];
    
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    self.selectedPlayers = [NSMutableArray new];
    
    for (Player *player in self.players) {
        player.isSelected = NO;
    }
    
    [self.startGamebutton setEnabled:NO];
    [self.playerListTableView reloadData];
    
}


-(void)createPlayers {
    for (NSString *name in self.playerNames) {
        Player *player = [[Player alloc]initWithName:name];
        [self.players addObject:player];
    }
}




#pragma Cell Setup
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.players.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELLID" forIndexPath:indexPath];
    Player *player = [self.players objectAtIndex:indexPath.row];
    cell.textLabel.text = player.name;
    
    if (player.isSelected) {
        cell.backgroundColor = [UIColor blueColor];
    }else {
        cell.backgroundColor = [UIColor clearColor];
    }

    
    return cell;
}


#pragma Adding players
- (IBAction)onAddPlayerbuttonPressed:(UIButton *)sender {

    Player *player = [[Player alloc]initWithName: self.enteredPlayerNameTextField.text];
    [self.players addObject:player];
    [self.playerListTableView reloadData];
    [self.enteredPlayerNameTextField  resignFirstResponder];
    
    
    self.enteredPlayerNameTextField.text = @"";
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Player *player = [self.players objectAtIndex:indexPath.row];
    
    
    if (player.isSelected) {
        player.isSelected = NO;
        [self.selectedPlayers removeObject:player];
        
    } else {
        player.isSelected = YES;
        [self.selectedPlayers addObject:player];
    }
    
    
    [self.playerListTableView reloadData];
    [self checkIfGameCanStart];

}



#pragma Segues
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    GameBoardViewController *destVC = segue.destinationViewController;
    destVC.playersForGame = self.selectedPlayers;
    
}


-(void)checkIfGameCanStart {
    if (self.selectedPlayers.count > 1 && self.selectedPlayers.count < 11) {
        [self.startGamebutton setEnabled:YES];
    } else {
        [self.startGamebutton setEnabled:NO];
    }
}



@end
