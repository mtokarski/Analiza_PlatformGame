//
//  Goomba.h
//  iMario_iOS
//
//  Created by Michał Tokarski on 2/6/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Goomba : CCSprite {
    
}

@property (nonatomic, assign) CGPoint velocity;
@property (nonatomic, assign) CGPoint desiredPosition;
@property (nonatomic, assign) BOOL onGround;

@property (nonatomic, retain) CCAction *walkAction;

@property (nonatomic, assign) BOOL forwardMarch;
@property (nonatomic, assign) BOOL backwardMarch;

@property (nonatomic, assign) BOOL Init;
@property (nonatomic, assign) BOOL Dead;

-(void)update:(ccTime)dt;
-(CGRect)collisionBoundingBox;

@end
