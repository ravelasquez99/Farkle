//
//  Players.h
//  Farkle
//
//  Created by Richard Velazquez on 3/24/16.
//  Copyright © 2016 Richard Velazquez. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Player : NSObject
@property NSString *name;
@property NSInteger score;
- (instancetype)initWithName:(NSString *)name;

@end
