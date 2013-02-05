//
//  BackgroundLayer.m
//  iMario_iOS
//
//  Created by Michał Tokarski on 1/14/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "BackgroundLayer.h"


@implementation BackgroundLayer

-(id) init
{
	if( (self=[super init]) ) {
        CCLayerColor *blueSky = [[CCLayerColor alloc] initWithColor:ccc4(92, 148, 252, 255)];
        [self addChild:blueSky];
        
        CCSprite *left = [[CCSprite alloc] initWithFile:@"left.png" ];
        left.position = ccp(60, 280);
        [self addChild:left];
        
        CCSprite *right = [[CCSprite alloc] initWithFile:@"right.png" ];
        right.position = ccp(180, 280);
        [self addChild:right];
        
        CCSprite *jump = [[CCSprite alloc] initWithFile:@"jump.png" ];
        jump.position = ccp(420, 280);
        [self addChild:jump];
    }
    return self;
}

@end
