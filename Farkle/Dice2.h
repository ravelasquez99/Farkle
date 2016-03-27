//
//  Dice2.h
//  Farkle
//
//  Created by Richard Velazquez on 3/27/16.
//  Copyright © 2016 Richard Velazquez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface Dice2 : NSObject
@property UIImage *rolledImage;
@property UIImage *selectedImage;
@property int placeOnScreen;
@property int scoreRolled;
@property int isSelected;

- (instancetype)initWithDefaultImage:(UIImage *)defaultImage selectedImage:(UIImage *)selectedImage andPlaceOnScreen:(int) placeOnScreen;

@end
