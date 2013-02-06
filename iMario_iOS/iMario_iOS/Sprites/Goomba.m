//
//  Goomba.m
//  iMario_iOS
//
//  Created by Michał Tokarski on 2/6/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Goomba.h"


@implementation Goomba

@synthesize velocity = _velocity;
@synthesize desiredPosition = _desiredPosition;
@synthesize onGround = _onGround;

@synthesize walkAction = _walkAction;

@synthesize forwardMarch = _forwardMarch;
@synthesize backwardMarch = _backwardMarch;

@synthesize Init = _Init;

-(id)initWithSpriteFrameName:(NSString *)spriteFrameName
{
    if (self = [super initWithSpriteFrameName:spriteFrameName]) {
        self.velocity = ccp(0.0, 0.0);
        self.Init = YES;
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
    self.velocity = ccp(self.velocity.x, self.velocity.y);
    
    if (self.forwardMarch) {
        self.velocity = ccpAdd(self.velocity, forwardStep);
    }
    if (self.backwardMarch) {
        self.velocity = ccpAdd(self.velocity, backwardStep);
    }
    
    CGPoint minMovement = ccp(-30.0, -450.0);
    CGPoint maxMovement = ccp(30.0, 250.0);
    self.velocity = ccpClamp(self.velocity, minMovement, maxMovement);
    
    CGPoint stepVelocity = ccpMult(self.velocity, dt);
    
    self.desiredPosition = ccpAdd(self.position, stepVelocity);
}

-(CGRect)collisionBoundingBox {
    CGRect collisionBox = CGRectInset(self.boundingBox, 3, 0);
    CGPoint diff = ccpSub(self.desiredPosition, self.position);
    CGRect returnBoundingBox = CGRectOffset(collisionBox, diff.x, diff.y);
    return returnBoundingBox;
}

@end