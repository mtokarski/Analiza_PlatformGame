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
#import "CCMenuItemSpriteHoldable.h"


@interface GameLevelLayer()
{
    CCMenuItemSpriteHoldable *leftBtn;
    CCMenuItemSpriteHoldable *rightBtn;
    CCMenuItemSpriteHoldable *jumpBtn;

    CCTMXTiledMap *map;
    CCTMXLayer *walls;
    Player *mario;
    Goomba *goomba1, *goomba2, *goomba3, *goomba4, *goomba5, *goomba6, *goomba7, *goomba8, *goomba9, *goomba10, *goomba11;
    BOOL gameOver;
    BOOL jumpAnimSwitch, walkAnimSwitch, backAnimSwitch;
}
@end

@implementation GameLevelLayer

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
    
	GameLevelLayer *layer = [GameLevelLayer node];
	[scene addChild: layer];
	return scene;
}

-(id) init
{
	if( (self=[super init]) ) {        
        self.isTouchEnabled = YES;
        
        jumpAnimSwitch = YES;
        walkAnimSwitch = YES;
        backAnimSwitch = YES;
        
        map = [[CCTMXTiledMap alloc] initWithTMXFile:@"Level1.tmx"];
        [self addChild:map];
        
        walls = [map layerNamed:@"Walls"];
        
// Create animation for Mario
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
        
        NSMutableArray *backAnimFrames = [NSMutableArray array];
        for(int i = 1; i <= 3; ++i) {
            [backAnimFrames addObject:
             [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
              [NSString stringWithFormat:@"Mario_Back%d.png", i]]];
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
        CCAnimation *backAnim = [CCAnimation animationWithSpriteFrames:backAnimFrames delay:0.15f];
        CCAnimation *jumpAnim = [CCAnimation animationWithSpriteFrames:jumpAnimFrames delay:0.15f];
        CCAnimation *idleAnim = [CCAnimation animationWithSpriteFrames:idleAnimFrames delay:0.15f];
        CCAnimation *deadAnim = [CCAnimation animationWithSpriteFrames:deadAnimFrames delay:0.15f];
// Animation created
        
        
// Goomba animation
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
// Goomba animation created

        
// Init some goombas
    // Goomba 1
        goomba1 = [[Goomba alloc] initWithSpriteFrameName:@"Goomba1.png"];
        goomba1.position = ccp(416, 55);
        [map addChild:goomba1 z:15];
        goomba1.walkAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:goombaAnim]];
    // Goomba 2
        goomba2 = [[Goomba alloc] initWithSpriteFrameName:@"Goomba1.png"];
        goomba2.position = ccp(704, 55);
        [map addChild:goomba2 z:15];
        goomba2.walkAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:goombaAnim]];
    // Goomba 3
        goomba3 = [[Goomba alloc] initWithSpriteFrameName:@"Goomba1.png"];
        goomba3.position = ccp(848, 55);
        [map addChild:goomba3 z:15];
        goomba3.walkAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:goombaAnim]];
    // Goomba 4
        goomba4 = [[Goomba alloc] initWithSpriteFrameName:@"Goomba1.png"];
        goomba4.position = ccp(1296, 185);
        [map addChild:goomba4 z:15];
        goomba4.walkAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:goombaAnim]];
    // Goomba 5
        goomba5 = [[Goomba alloc] initWithSpriteFrameName:@"Goomba1.png"];
        goomba5.position = ccp(1328, 185);
        [map addChild:goomba5 z:15];
        goomba5.walkAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:goombaAnim]];
    // Goomba 6
        goomba6 = [[Goomba alloc] initWithSpriteFrameName:@"Goomba1.png"];
        goomba6.position = ccp(1536, 55);
        [map addChild:goomba6 z:15];
        goomba6.walkAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:goombaAnim]];
    // Goomba 7
        goomba7 = [[Goomba alloc] initWithSpriteFrameName:@"Goomba1.png"];
        goomba7.position = ccp(1632, 55);
        [map addChild:goomba7 z:15];
        goomba7.walkAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:goombaAnim]];
    // Goomba 8
        goomba8 = [[Goomba alloc] initWithSpriteFrameName:@"Goomba1.png"];
        goomba8.position = ccp(1936, 55);
        [map addChild:goomba8 z:15];
        goomba8.walkAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:goombaAnim]];
    // Goomba 9
        goomba9 = [[Goomba alloc] initWithSpriteFrameName:@"Goomba1.png"];
        goomba9.position = ccp(2064, 55);
        [map addChild:goomba9 z:15];
        goomba9.walkAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:goombaAnim]];
    // Goomba 10
        goomba10 = [[Goomba alloc] initWithSpriteFrameName:@"Goomba1.png"];
        goomba10.position = ccp(2720, 55);
        [map addChild:goomba10 z:15];
        goomba10.walkAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:goombaAnim]];
    // Goomba11
        goomba11 = [[Goomba alloc] initWithSpriteFrameName:@"Goomba1.png"];
        goomba11.position = ccp(2832, 55);
        [map addChild:goomba11 z:15];
        goomba11.walkAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:goombaAnim]];

        
// Create player
        mario = [[Player alloc] initWithSpriteFrameName:@"Mario_Idle.png"];
        mario.position = ccp(100, 55);
        [map addChild:mario z:15];
        
        mario.walkAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:walkAnim]];
        walkAnim.restoreOriginalFrame = NO;
        
        mario.backAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:backAnim]];
        walkAnim.restoreOriginalFrame = NO;
        
        mario.jumpAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:jumpAnim]];
        jumpAnim.restoreOriginalFrame = NO;
        
        mario.idleAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:idleAnim]];
        idleAnim.restoreOriginalFrame = NO;
        
        mario.deadAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:deadAnim]];
        deadAnim.restoreOriginalFrame = NO;
// Player created
        

// Interface
        leftBtn = [CCMenuItemSpriteHoldable itemWithNormalSprite:[CCSprite spriteWithFile:@"left.png"] selectedSprite:[CCSprite spriteWithFile:@"left.png"] target:self selector:@selector(leftButtonPressed)];
        rightBtn = [CCMenuItemSpriteHoldable itemWithNormalSprite:[CCSprite spriteWithFile:@"right.png"] selectedSprite:[CCSprite spriteWithFile:@"right.png"] target:self selector:@selector(rightButtonPressed)];
        jumpBtn	= [CCMenuItemSpriteHoldable itemWithNormalSprite:[CCSprite spriteWithFile:@"jump.png"] selectedSprite:[CCSprite spriteWithFile:@"jump.png"] target:self selector:@selector(jumpButtonPressed)];
        
        CCMenu *directionalMenu = [CCMenu menuWithItems:leftBtn, rightBtn, nil];
        [directionalMenu alignItemsHorizontallyWithPadding:30];
        [directionalMenu setPosition:ccp(120,250)];
        [self addChild:directionalMenu];
        
        CCMenu *buttonsMenu = [CCMenu menuWithItems:jumpBtn,nil];
        [buttonsMenu alignItemsHorizontallyWithPadding:0];
        [buttonsMenu setPosition:ccp(480-90,250)];
        [self addChild:buttonsMenu];
        
        [self schedule:@selector(update:)];
	}
	return self;
}   // Quite a long Init



// Update - it's ALIVE !

-(void)update:(ccTime)dt
{
    if (gameOver) {
        return;
    }
    
// Handle movement
    if (jumpBtn.buttonHeld) {
        if (jumpAnimSwitch) {
            [mario stopAllActions];
            [mario runAction:mario.jumpAction];
            jumpAnimSwitch = NO;
        }
        mario.mightAsWellJump = YES;
    } else {
        mario.mightAsWellJump = NO;
    }
    if (rightBtn.buttonHeld) {
        if (walkAnimSwitch) {
            [mario stopAllActions];
            [mario runAction:mario.walkAction];
            walkAnimSwitch = NO;
            backAnimSwitch = YES;
        }
        mario.backwardMarch = NO;
        mario.forwardMarch = YES;
    } else {
        mario.forwardMarch = NO;
        //walkAnimSwitch = YES;
    }
    if (leftBtn.buttonHeld) {
        if (backAnimSwitch) {
            [mario stopAllActions];
            [mario runAction:mario.backAction];
            backAnimSwitch = NO;
            walkAnimSwitch = YES;
        }
        mario.forwardMarch = NO;
        mario.backwardMarch = YES;
    } else {
        mario.backwardMarch = NO;
        //walkAnimSwitch = YES;
    }
// Not the best, but works quite well
    
    
    [mario update:dt];
    [self checkForAndResolveCollisions:mario];
    
    [goomba1 update:dt];
    [self goombaCollisions:goomba1];
    [goomba2 update:dt];
    [self goombaCollisions:goomba2];
    [goomba3 update:dt];
    [self goombaCollisions:goomba3];
    [goomba4 update:dt];
    [self goombaCollisions:goomba4];
    [goomba5 update:dt];
    [self goombaCollisions:goomba5];
    [goomba6 update:dt];
    [self goombaCollisions:goomba6];
    [goomba7 update:dt];
    [self goombaCollisions:goomba7];
    [goomba8 update:dt];
    [self goombaCollisions:goomba8];
    [goomba9 update:dt];
    [self goombaCollisions:goomba9];
    [goomba10 update:dt];
    [self goombaCollisions:goomba10];
    [goomba11 update:dt];
    [self goombaCollisions:goomba11];
    
    [self handleGoombasLikeABoss:goomba1 with:mario];
    [self handleGoombasLikeABoss:goomba2 with:mario];
    [self handleGoombasLikeABoss:goomba3 with:mario];
    [self handleGoombasLikeABoss:goomba4 with:mario];
    [self handleGoombasLikeABoss:goomba5 with:mario];
    [self handleGoombasLikeABoss:goomba6 with:mario];
    [self handleGoombasLikeABoss:goomba7 with:mario];
    [self handleGoombasLikeABoss:goomba8 with:mario];
    [self handleGoombasLikeABoss:goomba9 with:mario];
    [self handleGoombasLikeABoss:goomba10 with:mario];
    [self handleGoombasLikeABoss:goomba11 with:mario];
    
    [self setViewpointCenter:mario.position];
}

// Some tile checking for physics

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
// End



// Goomba stuff

-(void)initGoomba:(Goomba *) g {
    g.backwardMarch = YES;
    [g runAction:g.walkAction];
}

-(void)handleGoombasLikeABoss:(Goomba *)g with:(Player *)p {
    
    if (p.position.x < g.position.x && g.position.x - p.position.x < 240) {
        if (g.Init) {
            g.Init = NO;
            [self initGoomba:g];
        }
    }
    if (p.position.x > g.position.x && p.position.x - g.position.x > 240) {
        [g removeFromParentAndCleanup:YES];
    }
    CGRect pRect = [p collisionBoundingBox];
    CGRect gRect = [g collisionBoundingBox];
    if (CGRectIntersectsRect(pRect, gRect)) {
        if (abs(p.position.x - g.position.x) <= 8 && p.position.y > g.position.y) {
            [g removeFromParentAndCleanup:YES];
            g.Dead = YES;
        } else if (!(g.Dead)) {
            [self gameOver:0];
        }
    }
}

-(void)goombaCollisions:(Goomba *)g {
    
    NSArray *tiles = [self GOOMBAgetSurroundingTilesAtPosition:g.position forLayer:walls ];
    
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
                }
            }
        }
    }
    g.position = g.desiredPosition;
}

-(NSArray *)GOOMBAgetSurroundingTilesAtPosition:(CGPoint)position forLayer:(CCTMXLayer *)layer {
    
    CGPoint plPos = [self tileCoordForPosition:position];
    
    NSMutableArray *gids = [NSMutableArray array];
    
    for (int i = 0; i < 9; i++) {
        int c = i % 3;
        int r = (int)(i / 3);
        CGPoint tilePos = ccp(plPos.x + (c - 1), plPos.y + (r - 1));
        
        if (tilePos.y > (map.mapSize.height - 1)) {
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
    
    return (NSArray *)gids;
}
// Goomba stuff ends here



// Player physics

-(NSArray *)getSurroundingTilesAtPosition:(CGPoint)position forLayer:(CCTMXLayer *)layer {
    
    CGPoint plPos = [self tileCoordForPosition:position];
    
    NSMutableArray *gids = [NSMutableArray array];
    
    for (int i = 0; i < 9; i++) {
        int c = i % 3;
        int r = (int)(i / 3);
        CGPoint tilePos = ccp(plPos.x + (c - 1), plPos.y + (r - 1));
        
        if (tilePos.y > (map.mapSize.height - 1)) {  // falling goomba causes Game Over :(
            [self gameOver:0];
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



// Player movement

/*
 I need to create Hud layer for this with sprite based buttons or something. Now button handling is not there. I need to finish mechanics first to make sure game runs fine - it would be impossible to test multi-touch controls (based on buttons) with iOS Simulator.
*/
/*
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
*/
// Movement handling ends here



// Game state handler - sort of :)

-(void)gameOver:(BOOL)won {
	gameOver = YES;
	NSString *gameText;
	
	if (won) {
		gameText = @"You Won!";
	} else {
        [mario stopAllActions];
        [mario runAction:mario.deadAction];
		gameText = @"You have Died!";
	}
	
    CCLabelTTF *diedLabel = [[CCLabelTTF alloc] initWithString:gameText fontName:@"Marker Felt" fontSize:40];
    diedLabel.position = ccp(240, 200);
    
    [self addChild:diedLabel];
}

// Controls selectors
-(void)leftButtonPressed {
    [mario stopAllActions];
    [mario runAction:mario.idleAction];
    backAnimSwitch = YES;
}

-(void)rightButtonPressed {
    [mario stopAllActions];
    [mario runAction:mario.idleAction];
    walkAnimSwitch = YES;
}

-(void)jumpButtonPressed {
    [mario stopAllActions];
    [mario runAction:mario.idleAction];
    jumpAnimSwitch = YES;
}

@end
