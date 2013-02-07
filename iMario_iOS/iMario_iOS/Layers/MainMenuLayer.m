//
//  MainMenuLayer.m
//  iMario_iOS
//
//  Created by Michał Tokarski on 1/13/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "MainMenuLayer.h"
#import "CCControlButton.h"
#import "CCBReader.h"
#import "GameScene.h"

#define PLAY_BUTTON_TAG 1
#define ABOUT_BUTTON_TAG 2

@implementation MainMenuLayer

-(void)buttonPressed:(id)sender {
    CCControlButton *button = (CCControlButton*) sender;
    switch (button.tag) {
        case PLAY_BUTTON_TAG:
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[GameScene node] withColor:ccWHITE]];
            break;
        case ABOUT_BUTTON_TAG:
            [[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:1.0 scene:[CCBReader sceneWithNodeGraphFromFile:@"AboutScene.ccbi"]]];
            break;
    }
}

@end
