//
//  SelectPlayersViewController.m
//  Farkle
//
//  Created by Richard Velazquez on 3/24/16.
//  Copyright © 2016 Richard Velazquez. All rights reserved.
//

#import "SelectPlayersViewController.h"
#import "Player.h"


@interface SelectPlayersViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *playerListTableView;
@property NSMutableArray *playerNames;
@property NSMutableArray *players;
@property (weak, nonatomic) IBOutlet UITextField *enteredPlayerNameTextField;

@end

@implementation SelectPlayersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.playerListTableView.delegate = self;
    self.playerListTableView.dataSource = self;
    self.playerNames =[NSMutableArray arrayWithArray:@[@"Ricky", @"Michael", @"Jesus Christ"]];
    self.players = [NSMutableArray new];
    [self createPlayers];
    
    
}


-(void)createPlayers {
    for (NSString *name in self.playerNames) {
        Player *player = [[Player alloc]initWithName:name];
        [self.players addObject:player];
    }
}




-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.players.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELLID" forIndexPath:indexPath];
    Player *player = [self.players objectAtIndex:indexPath.row];
    cell.textLabel.text = player.name;

    
    return cell;
}

- (IBAction)onAddPlayerbuttonPressed:(UIButton *)sender {

    Player *player = [[Player alloc]initWithName: self.enteredPlayerNameTextField.text];
    [self.players addObject:player];
    [self.playerListTableView reloadData];
    [self.enteredPlayerNameTextField resignFirstResponder];
    
    self.enteredPlayerNameTextField.text = @"";
    
}


@end
