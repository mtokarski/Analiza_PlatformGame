//
//  CCMenuItemSpriteHoldable.h
//  iMario_iOS
//
//  Created by Michał Tokarski on 2/8/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface CCMenuItemSpriteHoldable : CCMenuItemSprite {
    BOOL buttonHeld;
}

@property (readonly, nonatomic) BOOL buttonHeld;

-(void)selected;
-(void)unselected;

@end
