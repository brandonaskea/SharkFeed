//
//  SFLightBoxView.m
//  SharkFeed
//
//  Created by Brandon Askea on 9/19/16.
//  Copyright © 2016 Yahoo-Brandon_Askea. All rights reserved.
//

#import "SFLightBoxView.h"
#import "SFConstants.h"

@interface SFLightBoxView () {
    
}

@property (nonatomic) NSLayoutConstraint *topConstraint;
@property (nonatomic) NSLayoutConstraint *leftConstraint;
@property (nonatomic) NSLayoutConstraint *rightConstraint;
@property (nonatomic) NSLayoutConstraint *bottomConstraint;
@property (nonatomic) NSLayoutConstraint *widthConstraint;
@property (nonatomic) NSLayoutConstraint *heightConstraint;

@property (nonatomic) SFFeedObject * object;

@property (nonatomic) BOOL isAnimating;

@end

@implementation SFLightBoxView

-(void)configureLightBoxWithConstraintsTop:(NSLayoutConstraint *)top left:(NSLayoutConstraint *)left bottom:(NSLayoutConstraint *)bottom right:(NSLayoutConstraint *)right width:(NSLayoutConstraint *)width height:(NSLayoutConstraint *)height {
    
    // Only present once built and selection made
    self.hidden = YES;
    self.isAnimating = NO;
    
    // Assign constraints for placement and animation
    self.topConstraint = top;
    self.leftConstraint = left;
    self.bottomConstraint = bottom;
    self.rightConstraint = right;
    
    // Register for animate out notification
    [self registerForNotifications];
}

-(void)registerForNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(animateOutward) name:kNotificationKeyLightBoxUnLoad object:nil];
}

-(void)unregisterForNotifications{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationKeyLightBoxUnLoad object:nil];
}

-(void)buildLightBoxWithObject:(SFFeedObject *)object fromRect:(CGRect)rect {
    
    /*  
        This will set up the UI for the Lightbox
        It will consist of a background (self),
        A UIStackView that will hold the image in
        the center with a unconstrained frame (it
        will expand/contract) and any details about
        the image below in a fixed height container
     */
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationKeyLightBoxLoad object:object];
    
    
    // Custom animation for transition to LightBox
    [self.superview bringSubviewToFront:self];
    [self animateInwardFromRect:rect];

}

-(void)animateOutward {
    
    self.widthConstraint.constant = 0;
    self.heightConstraint.constant = 0;
    
    [UIView animateWithDuration:kLightBoxFadeDuration delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.alpha = 0;
        [self.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

-(void)animateInwardFromRect:(CGRect)rect {
    
    // Only peform if we are not already in progress
    if (self.isAnimating == NO) {
        
        // Calculate the distance between the X and Y and the constaints
        CGFloat tapX = CGRectGetMidX(rect);
        CGFloat tapY = CGRectGetMidY(rect);
        CGFloat positionX = self.leftConstraint.constant;
        CGFloat positionY = self.topConstraint.constant;
        
        CGFloat moveToX;
        CGFloat moveToY;
        
        if (tapX <= positionX) {
            // Move Left
            moveToX = positionX - tapX;
        }
        else {
            // Move Right
            moveToX = positionX + tapX;
        }
        
        if (tapY <= positionY) {
            // Move Up
            moveToY = positionY - tapY;
        }
        else {
            // Move Down
            moveToY = positionY + tapY;
        }
        
        
        // Update Position With New x and y
        self.topConstraint.constant = moveToY;
        self.bottomConstraint.constant = moveToY;
        self.leftConstraint.constant = moveToX;
        self.rightConstraint.constant = moveToX;
        [self.superview layoutIfNeeded];
        
        
        // Animate the LightBox From new position to Full Screen
        self.topConstraint.constant = kNavBarHeight;
        self.leftConstraint.constant = 0;
        self.bottomConstraint.constant = 0;
        self.rightConstraint.constant = 0;
        
        
        self.hidden = NO;
        
        
        // Fade in the LightBox and animate transition
        [UIView animateWithDuration:kLightBoxFadeDuration delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.alpha = 1;
            [self.superview layoutIfNeeded];
        } completion:^(BOOL finished) {
            
        }];

    }
}

@end
