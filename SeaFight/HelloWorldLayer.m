//
//  HelloWorldLayer.m
//  SeaFight
//
//  Created by Oleg Pochtovy on 30.05.14.
//  Copyright __MyCompanyName__ 2014. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#import "SimpleAudioEngine.h"
#import "GameOverLayer.h"

#import "Enemy.h"
#import "LevelManager.h"

#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation HelloWorldLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" we need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super initWithColor:ccc4(150, 235, 150, 255)]) )
    {
        CGSize winSize = [CCDirector sharedDirector].winSize;
        
        // here we take the background image from the class LevelManager depending on number of level (current level)
        CCSprite *background = [CCSprite spriteWithFile:[LevelManager sharedInstance].curLevel.backgroundImageName];
        background.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild:background];
        
        CCSprite *player = [CCSprite spriteWithFile:@"ship.png"];
        player.position = ccp(winSize.width/2, winSize.height*3/4);
        [self addChild:player];
	}
    // here time we add enemy submarine depends on curLevel from LevelManager
    [self schedule:@selector(gameLogic:) interval:[LevelManager sharedInstance].curLevel.secsPerSpawn];
    [self schedule:@selector(update:)];
    
    // we have to enable touches on our layer (for shooting with projectiles)
    [self setIsTouchEnabled:YES];
    
    _submarines = [[NSMutableArray alloc] init];
    _projectiles = [[NSMutableArray alloc] init];
    
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"background-music-aac.caf"];
	return self;
}

- (void)gameLogic:(ccTime)dt
{
    [self addSubmarine];
}

// here we add submarine
- (void)addSubmarine
{
    Enemy *submarine = nil;
    if (arc4random() % 2 == 0) {
        submarine = [[[WeakAndFastBoat alloc] init] autorelease];
    } else {
        submarine = [[[StrongAndSlowSubmarine alloc] init] autorelease];
    }
    submarine.tag = 1;
    [_submarines addObject:submarine];
    
    // Determine where to spaw the submarine along the Y axis - random
    CGSize winSize = [CCDirector sharedDirector].winSize;
    int minY = submarine.contentSize.height / 2;
    int maxY = winSize.height * 3/5;
    int rangeY = maxY - minY;
    int actualY = (arc4random() % rangeY) + minY;
    
    // Create the submarine slightly off-screen along the right edge and along a random position along the Y axis as calculated above
    submarine.position = ccp(winSize.width + submarine.contentSize.width/2, actualY);
    [self addChild:submarine];
    
    // Determine speed of the submarine - random
    int minDuration = submarine.minMoveDuration;
    int maxDuration = submarine.maxMoveDuration;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    
    // Create the actions
    CCMoveTo *actionMove = [CCMoveTo actionWithDuration:actualDuration position:ccp(-submarine.contentSize.width/2, actualY)];
    CCCallBlockN *actionMoveDone = [CCCallBlockN actionWithBlock: ^(CCNode *node) {
        [node removeFromParentAndCleanup:YES];
        CCScene *gameOverScreen = [GameOverLayer sceneWithWon:NO];
        [[CCDirector sharedDirector] replaceScene:gameOverScreen];
        [_submarines removeObject:node];
    }];
    [submarine runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
}

// next we implement the ccTouchesEnded method, which is called whenever the user completes a touch - to shoot a projectile in enemy
- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // choose one of the touches to work with
    UITouch *touch = [touches anyObject];
    CGPoint location = [self convertTouchToNodeSpace:touch];
    
    // set up initial location of projectile
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    CCSprite *projectile = [CCSprite spriteWithFile:@"projectile.png"];
    projectile.tag = 2;
    [_projectiles addObject:projectile];
    
    projectile.position = ccp(winSize.width/2, winSize.height*3/4 - 25.0f);
    
    // determine offset of location to projectile
    CGPoint offset = ccpSub(location, projectile.position);
    
    // ok to add "projectile" now - we've double checked position
    [self addChild:projectile];
    int realX = projectile.position.x;
    int realY = -projectile.contentSize.height/2;
    CGPoint realDest = ccp(realX, realY);
    float realMoveDuration = 2;
    
    // move projectile to actual endpoint
    [projectile runAction:[CCSequence actions:
                           [CCMoveTo actionWithDuration:realMoveDuration position:realDest],
                           [CCCallBlockN actionWithBlock:^(CCNode *node) {
        [node removeFromParentAndCleanup:YES];
        [_projectiles removeObject:node];
    }], nil]];
    
    [[SimpleAudioEngine sharedEngine] playEffect:@"pew-pew-lei.caf"];
}

// method to detect when our projectiles intersect our targets
- (void)update:(ccTime)dt {
    NSMutableArray *projectilesToDelete = [[NSMutableArray alloc] init];
    for (CCSprite *projectile in _projectiles) {
        BOOL submarineHit = FALSE;
        NSMutableArray *submarinesToDelete = [[NSMutableArray alloc] init];
        for (Enemy *submarine in _submarines) {
            
            if (CGRectIntersectsRect(projectile.boundingBox, submarine.boundingBox)) {
                submarineHit = TRUE;
                submarine.hp--;
                if (submarine.hp <= 0) {
                    [submarinesToDelete addObject:submarine];
                }
                break;
            }
        }
        
        for (CCSprite *submarine in submarinesToDelete) {
            [_submarines removeObject:submarine];
            [self removeChild:submarine cleanup:YES];
            _submarinesDestroyed++;
            if (_submarinesDestroyed > 20) {
                CCScene *gameOverScene = [GameOverLayer sceneWithWon:YES];
                [[CCDirector sharedDirector] replaceScene:gameOverScene];
            }
        }
        
        if (submarineHit) {
            [projectilesToDelete addObject:projectile];
            [[SimpleAudioEngine sharedEngine] playEffect:@"explosion.caf"];
        }
        [submarinesToDelete release];
    }
    
    for (CCSprite *projectile in projectilesToDelete) {
        [_projectiles removeObject:projectile];
        [self removeChild:projectile cleanup:YES];
    }
    [projectilesToDelete release];
}

// on "dealloc" we need to release all our retained objects
- (void) dealloc
{
	// in case we have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
    
    [_submarines release];
    _submarines = nil;
    [_projectiles release];
    _projectiles = nil;
    
	[super dealloc];
}

#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}
@end
