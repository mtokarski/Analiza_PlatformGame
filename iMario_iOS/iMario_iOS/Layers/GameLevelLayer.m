//
//  GameLevelLayer.m
//  iMario_iOS
//
//  Created by Michał Tokarski on 1/13/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "GameLevelLayer.h"
#import "Player.h"
#import "Goomba.h"

@interface GameLevelLayer()
{
    CCTMXTiledMap *map;
    CCTMXLayer *walls;
    Player *mario;
    Goomba *goomba1, *goomba2, *goomba3;
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
        
        
        // Goomba
        
        [[CCSpriteFrameCache sharedSpriteFrameCache]
         addSpriteFramesWithFile:@"Goomba_default.plist"];
        
        CCSpriteBatchNode *GoombaSpriteSheet = [CCSpriteBatchNode
                                                batchNodeWithFile:@"Goomba_default.png"];
        [self addChild:GoombaSpriteSheet];
        
        
        NSMutableArray *goombaAnimFrames = [NSMutableArray array];
        for(int i = 1; i <= 2; ++i) {
            [goombaAnimFrames addObject:
             [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
              [NSString stringWithFormat:@"Goomba%d.png", i]]];
        }
        
        CCAnimation *goombaAnim = [CCAnimation animationWithSpriteFrames:goombaAnimFrames delay:0.25f];

        
        // Goomba 1
        goomba1 = [[Goomba alloc] initWithSpriteFrameName:@"Goomba1.png"];
        goomba1.position = ccp(380, 55);
        [map addChild:goomba1 z:15];
        goomba1.walkAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:goombaAnim]];
        
        // Goomba 2
        goomba2 = [[Goomba alloc] initWithSpriteFrameName:@"Goomba1.png"];
        goomba2.position = ccp(510, 55);
        [map addChild:goomba2 z:15];
        goomba2.walkAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:goombaAnim]];
        
        // Goomba 2
        goomba3 = [[Goomba alloc] initWithSpriteFrameName:@"Goomba1.png"];
        goomba3.position = ccp(1300, 185);
        [map addChild:goomba3 z:15];
        goomba3.walkAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:goombaAnim]];

        // Goomba

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
    /*
    I know it is bad, but hey - it works so far
     
    I'd have to rebuild a bit to solve this.
    */
    
    // Goomba 1
    if (mario.position.x < goomba1.position.x && goomba1.position.x - mario.position.x < 240) {
        if (goomba1.Init) {
            goomba1.Init = NO;
            [self initGoomba:goomba1];
        }
    }
    if (mario.position.x > goomba1.position.x && mario.position.x - goomba1.position.x > 240) {
        //[map removeChild:goomba1 cleanup:YES];
        [goomba1 removeFromParentAndCleanup:YES];
    }
    // Goomba 2
    if (mario.position.x < goomba2.position.x && goomba2.position.x - mario.position.x < 240) {
        if (goomba2.Init) {
            goomba2.Init = NO;
            [self initGoomba:goomba2];
        }
    }
    if (mario.position.x > goomba2.position.x && mario.position.x - goomba2.position.x > 240) {
        [goomba2 removeFromParentAndCleanup:YES];
    }
    // Goomba 3
    if (mario.position.x < goomba3.position.x && goomba3.position.x - mario.position.x < 240) {
        if (goomba3.Init) {
            goomba3.Init = NO;
            [self initGoomba:goomba3];
        }
    }
    if (mario.position.x > goomba3.position.x && mario.position.x - goomba3.position.x > 240) {
        [goomba3 removeFromParentAndCleanup:YES];
    }
    
    
    [mario update:dt];
    [self checkForAndResolveCollisions:mario];
    
    [goomba1 update:dt];
    [self goombaCollisions:goomba1];
    
    [goomba2 update:dt];
    [self goombaCollisions:goomba2];
    
    [goomba3 update:dt];
    [self goombaCollisions:goomba3];
    
    [self setViewpointCenter:mario.position];
}

-(void)initGoomba:(Goomba *) g {
    g.backwardMarch = YES;
    [g runAction:g.walkAction];
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
        
        if (tilePos.y > (map.mapSize.height - 1)) {
            //fallen in a hole
            return nil;
        }
        
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


-(void)goombaCollisions:(Goomba *)g {
    
    NSArray *tiles = [self getSurroundingTilesAtPosition:g.position forLayer:walls ];
    
    g.onGround = NO;
    
    for (NSDictionary *dic in tiles) {
        CGRect pRect = [g collisionBoundingBox];
        
        int gid = [[dic objectForKey:@"gid"] intValue];
        if (gid) {
            CGRect tileRect = CGRectMake([[dic objectForKey:@"x"] floatValue], [[dic objectForKey:@"y"] floatValue], map.tileSize.width, map.tileSize.height);
            if (CGRectIntersectsRect(pRect, tileRect)) {
                CGRect intersection = CGRectIntersection(pRect, tileRect);
                int tileIndx = [tiles indexOfObject:dic];
                
                if (tileIndx == 0) {
                    //tile is directly below player
                    g.desiredPosition = ccp(g.desiredPosition.x, g.desiredPosition.y + intersection.size.height);
                    g.velocity = ccp(g.velocity.x, 0.0);
                    g.onGround = YES;
                } else if (tileIndx == 1) {
                    //tile is directly above player
                    g.desiredPosition = ccp(g.desiredPosition.x, g.desiredPosition.y - intersection.size.height);
                    g.velocity = ccp(g.velocity.x, 0.0);
                } else if (tileIndx == 2) {
                    //tile is left of player
                    g.desiredPosition = ccp(g.desiredPosition.x + intersection.size.width, g.desiredPosition.y);
                        g.backwardMarch = NO;
                        g.forwardMarch = YES;
                } else if (tileIndx == 3) {
                    //tile is right of player
                    g.desiredPosition = ccp(g.desiredPosition.x - intersection.size.width, g.desiredPosition.y);
                        g.forwardMarch = NO;
                        g.backwardMarch = YES;
                } else {
                    if (intersection.size.width > intersection.size.height) {
                        //tile is diagonal, but resolving collision vertially
                        g.velocity = ccp(g.velocity.x, 0.0);
                        float resolutionHeight;
                        if (tileIndx > 5) {
                            resolutionHeight = intersection.size.height;
                            g.onGround = YES;
                        } else {
                            resolutionHeight = -intersection.size.height;
                        }
                        g.desiredPosition = ccp(g.desiredPosition.x, g.desiredPosition.y + resolutionHeight);
                        
                    } else {
                        float resolutionWidth;
                        if (tileIndx == 6 || tileIndx == 4) {
                            resolutionWidth = intersection.size.width;
                        } else {
                            resolutionWidth = -intersection.size.width;
                        }
                        g.desiredPosition = ccp(g.desiredPosition.x + resolutionWidth, g.desiredPosition.y);
                    }
                }
            }
        }
    }
    g.position = g.desiredPosition;
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
