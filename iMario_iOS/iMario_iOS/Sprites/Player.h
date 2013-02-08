//
//  Player.h
//  iMario_iOS
//
//  Created by Michał Tokarski on 1/14/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Player : CCSprite {
    
}

@property (nonatomic, assign) CGPoint velocity;
@property (nonatomic, assign) CGPoint desiredPosition;
@property (nonatomic, assign) BOOL onGround;

@property (nonatomic, assign) int lives;
@property (nonatomic, assign) int coins;

@property (nonatomic, retain) CCAction *walkAction;
@property (nonatomic, retain) CCAction *backAction;
@property (nonatomic, retain) CCAction *jumpAction;
@property (nonatomic, retain) CCAction *idleAction;
@property (nonatomic, retain) CCAction *deadAction;

@property (nonatomic, assign) BOOL forwardMarch;
@property (nonatomic, assign) BOOL backwardMarch;
@property (nonatomic, assign) BOOL mightAsWellJump;

-(void)update:(ccTime)dt;
-(CGRect)collisionBoundingBox;

@end
