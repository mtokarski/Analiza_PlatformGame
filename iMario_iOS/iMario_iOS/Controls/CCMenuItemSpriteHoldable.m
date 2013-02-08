//
//  CCMenuItemSpriteHoldable.m
//  iMario_iOS
//
//  Created by Michał Tokarski on 2/8/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "CCMenuItemSpriteHoldable.h"


@implementation CCMenuItemSpriteHoldable

@synthesize buttonHeld;

-(void) selected
{
	[super selected];
	[self setOpacity:128];
    buttonHeld = YES;
}

-(void) unselected
{
	[super unselected];
	[self setOpacity:1000];
    buttonHeld = NO;
}

@end