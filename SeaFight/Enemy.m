//
//  Enemy.m
//  SeaFight
//
//  Created by Oleg Pochtovy on 06.06.14.
//  Copyright 2014 __MyCompanyName__. All rights reserved.
//

// class Enemy for creating two (or more) types of enemy boats: a weak and fast boat and strong and slow submarine

#import "Enemy.h"

@implementation Enemy

- (id)initWithFile:(NSString *)file hp:(int)hp minMoveDuration:(int)minMoveDuration maxMoveDuration:(int)maxMoveDuration {
    if ((self = [super initWithFile:file])) {
        self.hp = hp;
        self.minMoveDuration = minMoveDuration;
        self.maxMoveDuration = maxMoveDuration;
    }
    return self;
}

@end

@implementation WeakAndFastBoat

- (id)init {
    if ((self = [super initWithFile:@"boat.png" hp:1 minMoveDuration:3 maxMoveDuration:5])) {
    }
    return self;
}

@end

@implementation StrongAndSlowSubmarine

- (id)init {
    if ((self = [super initWithFile:@"submarine.png" hp:3 minMoveDuration:7 maxMoveDuration:12])) {
    }
    return self;
}

@end
