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
    }
    return self;
}

@end
