//
//  Players.h
//  Farkle
//
//  Created by Richard Velazquez on 3/24/16.
//  Copyright © 2016 Richard Velazquez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SelectPlayersViewController.h"

@interface Player : NSObject
@property NSString *name;
@property int score;
@property BOOL isSelected;
- (instancetype)initWithName:(NSString *)name;

@end
