//
//  AboutLayer.m
//  iMario_iOS
//
//  Created by Michał Tokarski on 1/13/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "AboutLayer.h"
#import "CCControlButton.h"
#import "CCBReader.h"

@implementation AboutLayer

-(void)backButtonPressed:(id)sender {
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[CCBReader sceneWithNodeGraphFromFile:@"MainMenuScene.ccbi"]]];
}

@end
