//
//  Dice2.m
//  Farkle
//
//  Created by Richard Velazquez on 3/27/16.
//  Copyright © 2016 Richard Velazquez. All rights reserved.
//

#import "Dice2.h"

@implementation Dice2
- (instancetype)initWithDefaultImage:(UIImage *)defaultImage selectedImage:(UIImage *)selectedImage andPlaceOnScreen:(int) placeOnScreen
{
    self = [super init];
    if (self) {
        self.rolledImage = defaultImage;
        self.selectedImage = selectedImage;
        self.placeOnScreen = placeOnScreen;
        self.scoreRolled = 0;
        self.isSelected = 0;
        
    }
    return self;
}

@end
