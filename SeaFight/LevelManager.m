//
//  LevelManager.m
//  SeaFight
//
//  Created by Oleg Pochtovy on 06.06.14.
//
//

// class LevelManager keeps track of all of the levels, as well as which level we are currently on

#import "LevelManager.h"

@implementation LevelManager {
    NSArray *_levels; // class keeps an array of the levels
    int _curLevelIdx; // class keeps an index to the current level
}

// this class is a singleton, created/accessed through the static sharedInstance method
+ (LevelManager *)sharedInstance {
    static dispatch_once_t once;
    static LevelManager *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    if ((self = [super init])) {
        _curLevelIdx = 0;
        Level *level1 = [[[Level alloc] initWithLevelNum:1 secsPerSpawn:2 backgroundImageName:@"background1.png"] autorelease];
        Level *level2 = [[[Level alloc] initWithLevelNum:2 secsPerSpawn:1 backgroundImageName:@"background2.png"] autorelease];
        _levels = [@[level1, level2] retain];
    }
    return self;
}

- (Level *)curLevel {
    if (_curLevelIdx >= _levels.count) {
        return nil;
    }
    return _levels[_curLevelIdx];
}

- (void)nextLevel {
    _curLevelIdx++;
}

- (void)reset {
    _curLevelIdx = 0;
}

- (void)dealloc {
    [_levels release];
    _levels = nil;
    [super dealloc];
}

@end
