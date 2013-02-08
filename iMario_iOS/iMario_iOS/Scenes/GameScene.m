//
//  GameScene.m
//  iMario_iOS
//
//  Created by Michał Tokarski on 1/13/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "GameScene.h"

@implementation GameScene

-(id)init {
    self = [super init];
    if (self != nil) {
        // Background Layer
        BackgroundLayer *backgroundLayer = [BackgroundLayer node];
        [self addChild:backgroundLayer z:0];
        // Gameplay Layer
        GameLevelLayer *gameLevelLayer = [GameLevelLayer node];
        [self addChild:gameLevelLayer z:5];
    }
    return self;
}

@end
