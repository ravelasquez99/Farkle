//
//  Dice.h
//  Farkle
//
//  Created by Richard Velazquez on 3/26/16.
//  Copyright © 2016 Richard Velazquez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameBoardViewController.h"

@interface Dice : NSObject
@property UIImage *rolledImage;
@property UIImage *selectedImage;
@property int placeOnScreen;
@property int scoreRolled;
@property BOOL isSelected;

- (instancetype)initWithDefaultImage:(UIImage *)defaultImage selectedImage:(UIImage *)selectedImage andPlaceOnScreen:(int) placeOnScreen;

@end
