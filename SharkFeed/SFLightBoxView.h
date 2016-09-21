//
//  SFLightBoxView.h
//  SharkFeed
//
//  Created by Brandon Askea on 9/19/16.
//  Copyright © 2016 Yahoo-Brandon_Askea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFFeedObject.h"

@interface SFLightBoxView : UIView

-(void)configureLightBoxWithConstraintsTop:(NSLayoutConstraint *)top left:(NSLayoutConstraint *)left bottom:(NSLayoutConstraint *)bottom right:(NSLayoutConstraint *)right width:(NSLayoutConstraint *)width height:(NSLayoutConstraint *)height;

-(void)buildLightBoxWithObject:(SFFeedObject *)object fromRect:(CGRect)rect;

@end
