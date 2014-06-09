//
//  GameOverLayer.h
//  SeaFight
//
//  Created by Oleg Pochtovy on 30.05.14.
//  Copyright 2014 __MyCompanyName__. All rights reserved.
//

// finally scene - we have won or lost

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameOverLayer : CCLayerColor {
}

+ (CCScene *)sceneWithWon:(BOOL)won;
- (id)initWithWon:(BOOL)won;

@end
