//
//  Dice.m
//  Farkle
//
//  Created by Richard Velazquez on 3/26/16.
//  Copyright © 2016 Richard Velazquez. All rights reserved.
//

#import "Dice.h"

@implementation Dice

- (instancetype)initWithDefaultImage:(UIImage *)defaultImage selectedImage:(UIImage *)selectedImage andPlaceOnScreen:(int) placeOnScreen
{
    self = [super init];
    if (self) {
        self.rolledImage = defaultImage;
        self.selectedImage = selectedImage;
        self.placeOnScreen = placeOnScreen;
        self.scoreRolled = 0;
        self.isSelected = NO;
        
    }
    return self;
}


@end
