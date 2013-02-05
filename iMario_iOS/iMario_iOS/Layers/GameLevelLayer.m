//
//  GameLevelLayer.m
//  iMario_iOS
//
//  Created by Michał Tokarski on 1/13/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "GameLevelLayer.h"
#import "Player.h"

@interface GameLevelLayer()
{
    CCTMXTiledMap *map;
    CCTMXLayer *walls;
    Player *mario;
}

@end

@implementation GameLevelLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameLevelLayer *layer = [GameLevelLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init
{
	if( (self=[super init]) ) {
        self.isTouchEnabled = YES;
        
        map = [[CCTMXTiledMap alloc] initWithTMXFile:@"Level1.tmx"];
        [self addChild:map];
        
        walls = [map layerNamed:@"Walls"];
        
        
        // Create animation
        [[CCSpriteFrameCache sharedSpriteFrameCache]
         addSpriteFramesWithFile:@"mario_default.plist"];
        
        CCSpriteBatchNode *spriteSheet = [CCSpriteBatchNode
                                          batchNodeWithFile:@"mario_default.png"];
        [self addChild:spriteSheet];
        
        NSMutableArray *walkAnimFrames = [NSMutableArray array];
        for(int i = 1; i <= 3; ++i) {
            [walkAnimFrames addObject:
             [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
              [NSString stringWithFormat:@"Mario_Walk%d.png", i]]];
        }
        
        NSMutableArray *jumpAnimFrames = [NSMutableArray array];
            [jumpAnimFrames addObject:
             [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
              [NSString stringWithFormat:@"Mario_Jump.png"]]];
        
        NSMutableArray *idleAnimFrames = [NSMutableArray array];
        [idleAnimFrames addObject:
         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
          [NSString stringWithFormat:@"Mario_Idle.png"]]];
        
        NSMutableArray *deadAnimFrames = [NSMutableArray array];
        [deadAnimFrames addObject:
         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
          [NSString stringWithFormat:@"Mario_Dead.png"]]];
        
        CCAnimation *walkAnim = [CCAnimation animationWithSpriteFrames:walkAnimFrames delay:0.15f];
        CCAnimation *jumpAnim = [CCAnimation animationWithSpriteFrames:jumpAnimFrames delay:0.15f];
        CCAnimation *idleAnim = [CCAnimation animationWithSpriteFrames:idleAnimFrames delay:0.15f];
        CCAnimation *deadAnim = [CCAnimation animationWithSpriteFrames:deadAnimFrames delay:0.15f];
        // Animation created

        mario = [[Player alloc] initWithSpriteFrameName:@"Mario_Idle.png"];
        mario.position = ccp(100, 55);
        [map addChild:mario z:15];
        
        mario.walkAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:walkAnim]];
        walkAnim.restoreOriginalFrame = NO;
        
        mario.jumpAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:jumpAnim]];
        jumpAnim.restoreOriginalFrame = NO;
        
        mario.idleAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:idleAnim]];
        idleAnim.restoreOriginalFrame = NO;
        
        mario.deadAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:deadAnim]];
        deadAnim.restoreOriginalFrame = NO;
        
        // [mario runAction:mario.walkAction];
        
        [self schedule:@selector(update:)];
	}
	return self;
}

-(void)update:(ccTime)dt
{
    [mario update:dt];
    [self checkForAndResolveCollisions:mario];
    [self setViewpointCenter:mario.position];
}

- (CGPoint)tileCoordForPosition:(CGPoint)position
{
    float x = floor(position.x / map.tileSize.width);
    float levelHeightInPixels = map.mapSize.height * map.tileSize.height;
    float y = floor((levelHeightInPixels - position.y) / map.tileSize.height);
    return ccp(x, y);
}

-(CGRect)tileRectFromTileCoords:(CGPoint)tileCoords
{
    float levelHeightInPixels = map.mapSize.height * map.tileSize.height;
    CGPoint origin = ccp(tileCoords.x * map.tileSize.width, levelHeightInPixels - ((tileCoords.y + 1) * map.tileSize.height));
    return CGRectMake(origin.x, origin.y, map.tileSize.width, map.tileSize.height);
}

-(NSArray *)getSurroundingTilesAtPosition:(CGPoint)position forLayer:(CCTMXLayer *)layer {
    
    CGPoint plPos = [self tileCoordForPosition:position];
    
    NSMutableArray *gids = [NSMutableArray array];
    
    for (int i = 0; i < 9; i++) {
        int c = i % 3;
        int r = (int)(i / 3);
        CGPoint tilePos = ccp(plPos.x + (c - 1), plPos.y + (r - 1));
        
        int tgid = [layer tileGIDAt:tilePos];
        
        CGRect tileRect = [self tileRectFromTileCoords:tilePos];
        
        NSDictionary *tileDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [NSNumber numberWithInt:tgid], @"gid",
                                  [NSNumber numberWithFloat:tileRect.origin.x], @"x",
                                  [NSNumber numberWithFloat:tileRect.origin.y], @"y",
                                  [NSValue valueWithCGPoint:tilePos],@"tilePos",
                                  nil];
        [gids addObject:tileDict];
        
    }
    
    [gids removeObjectAtIndex:4];
    [gids insertObject:[gids objectAtIndex:2] atIndex:6];
    [gids removeObjectAtIndex:2];
    [gids exchangeObjectAtIndex:4 withObjectAtIndex:6];
    [gids exchangeObjectAtIndex:0 withObjectAtIndex:4];
    
    for (NSDictionary *d in gids) {
        NSLog(@"%@", d);
    }
    
    return (NSArray *)gids;
}

-(void)checkForAndResolveCollisions:(Player *)p {
    
    NSArray *tiles = [self getSurroundingTilesAtPosition:p.position forLayer:walls ];
    
    p.onGround = NO;
    
    for (NSDictionary *dic in tiles) {
        CGRect pRect = [p collisionBoundingBox];
        
        int gid = [[dic objectForKey:@"gid"] intValue];
        if (gid) {
            CGRect tileRect = CGRectMake([[dic objectForKey:@"x"] floatValue], [[dic objectForKey:@"y"] floatValue], map.tileSize.width, map.tileSize.height);
            if (CGRectIntersectsRect(pRect, tileRect)) {
                CGRect intersection = CGRectIntersection(pRect, tileRect);
                int tileIndx = [tiles indexOfObject:dic];
                
                if (tileIndx == 0) {
                    //tile is directly below player
                    p.desiredPosition = ccp(p.desiredPosition.x, p.desiredPosition.y + intersection.size.height);
                    p.velocity = ccp(p.velocity.x, 0.0);
                    p.onGround = YES;
                } else if (tileIndx == 1) {
                    //tile is directly above player
                    p.desiredPosition = ccp(p.desiredPosition.x, p.desiredPosition.y - intersection.size.height);
                    p.velocity = ccp(p.velocity.x, 0.0);
                } else if (tileIndx == 2) {
                    //tile is left of player
                    p.desiredPosition = ccp(p.desiredPosition.x + intersection.size.width, p.desiredPosition.y);
                } else if (tileIndx == 3) {
                    //tile is right of player
                    p.desiredPosition = ccp(p.desiredPosition.x - intersection.size.width, p.desiredPosition.y);
                } else {
                    if (intersection.size.width > intersection.size.height) {
                        //tile is diagonal, but resolving collision vertially
                        p.velocity = ccp(p.velocity.x, 0.0);
                        float resolutionHeight;
                        if (tileIndx > 5) {
                            resolutionHeight = intersection.size.height;
                            p.onGround = YES;
                        } else {
                            resolutionHeight = -intersection.size.height;
                        }
                        p.desiredPosition = ccp(p.desiredPosition.x, p.desiredPosition.y + resolutionHeight);
                        
                    } else {
                        float resolutionWidth;
                        if (tileIndx == 6 || tileIndx == 4) {
                            resolutionWidth = intersection.size.width;
                        } else {
                            resolutionWidth = -intersection.size.width;
                        }
                        p.desiredPosition = ccp(p.desiredPosition.x + resolutionWidth, p.desiredPosition.y);
                    }
                }
            }
        }
    }
    p.position = p.desiredPosition;
}

// movement
- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *t in touches) {
        CGPoint touchLocation = [self convertTouchToNodeSpace:t];
        if (touchLocation.x > 240) {
            mario.mightAsWellJump = YES;
            [mario stopAllActions];
            [mario runAction:mario.jumpAction];
        } else if (touchLocation.x < 240 && touchLocation.x > 120) {
            if (mario.scaleX == -1.0) { mario.scaleX = 1.0; }
            mario.forwardMarch = YES;
                [mario stopAllActions];
                [mario runAction:mario.walkAction];
        } else if (touchLocation.x < 120) {
            if (mario.scaleX == 1.0) { mario.scaleX = -1.0; }
            mario.backwardMarch = YES;
                [mario stopAllActions];
                [mario runAction:mario.walkAction];
        }
    }
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *t in touches) {
        
        CGPoint touchLocation = [self convertTouchToNodeSpace:t];
        
        //get previous touch and convert it to node space
        CGPoint previousTouchLocation = [t previousLocationInView:[t view]];
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        previousTouchLocation = ccp(previousTouchLocation.x, screenSize.height - previousTouchLocation.y);
        
        if (touchLocation.x < 120 && previousTouchLocation.x < 240 && previousTouchLocation.x > 120) {
            mario.forwardMarch = NO;
            
            if (mario.scaleX == 1.0) { mario.scaleX = -1.0; }
            mario.backwardMarch = YES;
                [mario stopAllActions];
                [mario runAction:mario.walkAction];
        } else if (previousTouchLocation.x < 120 && touchLocation.x > 120 && touchLocation.x < 240) {
            if (mario.scaleX == -1.0) { mario.scaleX = 1.0; }
            mario.forwardMarch = YES;
                [mario stopAllActions];
                [mario runAction:mario.walkAction];
            
            mario.backwardMarch = NO;
        }
    }
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    for (UITouch *t in touches) {
        CGPoint touchLocation = [self convertTouchToNodeSpace:t];
        if (touchLocation.x <= 240 && touchLocation.x > 120) {
            mario.forwardMarch = NO;
                [mario stopAllActions];
                [mario runAction:mario.idleAction];
        }
        if (touchLocation.x <= 120) {
            mario.backwardMarch = NO;
                [mario stopAllActions];
                [mario runAction:mario.idleAction];
        }
        if (touchLocation.x > 240) {
            mario.mightAsWellJump = NO;
                [mario stopAllActions];
                [mario runAction:mario.idleAction];
        }
    }
}

-(void)setViewpointCenter:(CGPoint) position {
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    int x = MAX(position.x, winSize.width / 2);
    int y = MAX(position.y, winSize.height / 2);
    x = MIN(x, (map.mapSize.width * map.tileSize.width)
            - winSize.width / 2);
    y = MIN(y, (map.mapSize.height * map.tileSize.height)
            - winSize.height/2);
    CGPoint actualPosition = ccp(x, y);
    
    CGPoint centerOfView = ccp(winSize.width/2, winSize.height/2);
    CGPoint viewPoint = ccpSub(centerOfView, actualPosition);
    map.position = viewPoint;
}

@end
