//
//  Player.m
//  iMario_iOS
//
//  Created by Michał Tokarski on 1/14/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Player.h"


@implementation Player

@synthesize velocity = _velocity;
@synthesize desiredPosition = _desiredPosition;
@synthesize onGround = _onGround;

@synthesize lives = _lives;
@synthesize coins = _coins;

@synthesize walkAction = _walkAction;
@synthesize backAction = _backAction;
@synthesize jumpAction = _jumpAction;
@synthesize idleAction = _idleAction;
@synthesize deadAction = _deadAction;

@synthesize forwardMarch = _forwardMarch;
@synthesize backwardMarch = _backwardMarch;
@synthesize mightAsWellJump = _mightAsWellJump;

-(id)initWithSpriteFrameName:(NSString *)spriteFrameName
{
    if (self = [super initWithSpriteFrameName:spriteFrameName]) {
        self.velocity = ccp(0.0, 0.0);
        self.lives = 3;
        self.coins = 0;
    }
    return self;
}

-(void)update:(ccTime)dt {
    CGPoint gravity = ccp(0.0, -450.0);
    CGPoint gravityStep = ccpMult(gravity, dt);
    
    CGPoint forwardMove = ccp(800.0, 0.0);
    CGPoint forwardStep = ccpMult(forwardMove, dt);
    
    CGPoint backwardMove = ccp(-800.0, 0.0);
    CGPoint backwardStep = ccpMult(backwardMove, dt);
    
    self.velocity = ccpAdd(self.velocity, gravityStep);
    self.velocity = ccp(self.velocity.x * 0.90, self.velocity.y);
    
    CGPoint jumpForce = ccp(0.0, 310.0);
    float jumpCutoff = 150.0;
    
    if (self.mightAsWellJump && self.onGround) {
        self.velocity = ccpAdd(self.velocity, jumpForce);
    } else if (!self.mightAsWellJump && self.velocity.y > jumpCutoff) {
        self.velocity = ccp(self.velocity.x, jumpCutoff);
    }
    
    if (self.forwardMarch) {
        self.velocity = ccpAdd(self.velocity, forwardStep);
    }
    if (self.backwardMarch) {
        self.velocity = ccpAdd(self.velocity, backwardStep);
    }
    
    CGPoint minMovement = ccp(-90.0, -450.0);
    CGPoint maxMovement = ccp(90.0, 250.0);
    self.velocity = ccpClamp(self.velocity, minMovement, maxMovement);
    
    CGPoint stepVelocity = ccpMult(self.velocity, dt);
    
    self.desiredPosition = ccpAdd(self.position, stepVelocity);
}

-(CGRect)collisionBoundingBox {
    CGRect collisionBox = CGRectInset(self.boundingBox, 1, 0);
    CGPoint diff = ccpSub(self.desiredPosition, self.position);
    CGRect returnBoundingBox = CGRectOffset(collisionBox, diff.x, diff.y);
    return returnBoundingBox;
}

@end
