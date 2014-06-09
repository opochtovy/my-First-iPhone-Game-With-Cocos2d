//
//  Enemy.h
//  SeaFight
//
//  Created by Oleg Pochtovy on 06.06.14.
//  Copyright 2014 __MyCompanyName__. All rights reserved.
//

// class Enemy for creating two (or more) types of enemy boats: a weak and fast boat and strong and slow submarine

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Enemy : CCSprite {
    
}

@property (nonatomic, assign) int hp; // helthy points - how many times should we fall into enemy of that type
@property (nonatomic, assign) int minMoveDuration;
@property (nonatomic, assign) int maxMoveDuration;

- (id)initWithFile:(NSString *)file hp:(int)hp minMoveDuration:(int)minMoveDuration maxMoveDuration:(int)maxMoveDuration;

@end

@interface WeakAndFastBoat : Enemy
@end

@interface StrongAndSlowSubmarine : Enemy
@end
