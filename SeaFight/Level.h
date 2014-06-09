//
//  Level.h
//  SeaFight
//
//  Created by Oleg Pochtovy on 06.06.14.
//
//

// class to implement multiple levels
// here we keep track all of the information that differentiates one level from another: the level number, how many seconds in between spawning enemies (harder levels will spawn enemy boats faster), and the background image name (so we can easily differentiate levels)

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Level : NSObject

@property (nonatomic, assign) int levelNum;
@property (nonatomic, assign) float secsPerSpawn;
@property (nonatomic, assign) NSString *backgroundImageName;

- (id)initWithLevelNum:(int)levelNum secsPerSpawn:(float)secsPerSpawn backgroundImageName:(NSString *)backgroundImageName;

@end
