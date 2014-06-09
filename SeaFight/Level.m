//
//  Level.m
//  SeaFight
//
//  Created by Oleg Pochtovy on 06.06.14.
//
//

// class to implement multiple levels
// here we keep track all of the information that differentiates one level from another: the level number, how many seconds in between spawning enemies (harder levels will spawn enemy boats faster), and the background image (so we can easily differentiate levels)

#import "Level.h"

@implementation Level

- (id)initWithLevelNum:(int)levelNum secsPerSpawn:(float)secsPerSpawn backgroundImageName:(NSString *)backgroundImageName {
    if ((self = [super init])) {
        self.levelNum = levelNum;
        self.secsPerSpawn = secsPerSpawn;
        self.backgroundImageName = backgroundImageName;
    }
    return self;
}

@end
