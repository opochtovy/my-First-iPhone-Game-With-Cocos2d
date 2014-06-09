//
//  LevelManager.h
//  SeaFight
//
//  Created by Oleg Pochtovy on 06.06.14.
//
//

// class LevelManager keeps track of all of the levels, as well as which level we are currently on

#import <Foundation/Foundation.h>
#import "Level.h"

@interface LevelManager : NSObject

+ (LevelManager *)sharedInstance; // this class is a singleton, created/accessed through the static sharedInstance method
- (Level *)curLevel; // method to get the current level
- (void)nextLevel; // method to advance to the next level
- (void)reset; // method to reset back to the beginning

@end
