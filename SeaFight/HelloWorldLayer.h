//
//  HelloWorldLayer.h
//  SeaFight
//
//  Created by Oleg Pochtovy on 30.05.14.
//  Copyright __MyCompanyName__ 2014. All rights reserved.
//


#import <GameKit/GameKit.h>

// When we import this file, we import all the cocos2d classes
#import "cocos2d.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayerColor
{
    NSMutableArray *_submarines;
    NSMutableArray *_projectiles;
    int _submarinesDestroyed; // number of submarines the player has destroyed
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
