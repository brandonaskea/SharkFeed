//
//  SFPullToRefreshView.m
//  SharkFeed
//
//  Created by Brandon Askea on 9/20/16.
//  Copyright © 2016 Yahoo-Brandon_Askea. All rights reserved.
//

#import "SFPullToRefreshView.h"
#import "SFWebService.h"

@interface SFPullToRefreshView () {
    
}

@property (nonatomic) UILabel *label;
@property (nonatomic) UIImageView *icon;

@property (nonatomic) NSLayoutConstraint *heightConstraint;
@property (nonatomic) NSLayoutConstraint *iconWidthConstraint;
@property (nonatomic) NSLayoutConstraint *iconHeightConstraint;

@property (weak, nonatomic) id<SFPullToRefreshDelegate>delegate;

@end

@implementation SFPullToRefreshView

-(void)configureWithDelegate:(id)del icon:(UIImageView *)icon label:(UILabel *)label andHeightConstraint:(NSLayoutConstraint *)height iconHeightConstraint:(NSLayoutConstraint *)iconHeight iconWidthConstraint:(NSLayoutConstraint *)iconWidth {
    //self.clipsToBounds = NO; // Should I allow?
    self.hidden = YES;
    self.icon = icon;
    self.label = label;
    self.label.alpha = 0;
    self.icon.alpha = 0;
    self.isRefreshing = NO;
    self.delegate = del;
    self.heightConstraint = height;
}

-(void)updateHeightConstraintWithConstant:(CGFloat)constraintConstant {
    
    
    /*
        Expand the SFPullToRefreshView with the
        height constraint. The constant will be 
        supplied by the collectionView's content
        y offset. Once the supplied constant goes 
        beyond the threshold, we ask delegate to 
        fetch all new data. Upon completion we will
        collapse the SFPullToRefreshView.
     */
    
    
    // Only if currently not refreshing
    if (self.isRefreshing == NO) {
        
        // Hide
        if (constraintConstant < 1) {
            self.hidden = YES;
        }
        else {
            self.hidden = NO;
        }
        
        // Fade In Icon
        CGFloat iconAlpha = (constraintConstant / kPullToRefreshRefreshThreshold);
        self.icon.alpha = iconAlpha;
        
        // Expand the view
        if (constraintConstant < kPullToRefreshRefreshThreshold) {
            self.heightConstraint.constant = constraintConstant;
        }
        
        // Fade in Icon
        if (constraintConstant < kPullToRefreshIconHeightThreshold) {
            self.iconHeightConstraint.constant += constraintConstant;
        }
        
        
        // Check for beyond the threshold to refresh collectionView
        if (constraintConstant >= kPullToRefreshRefreshThreshold && self.isRefreshing == NO) {
            
            // Mark as currently refreshing
            self.isRefreshing = YES;
            
            // Update labe to indicate data retreival began
            [self updateLabel];
            
            // Ask delegate to refresh collectionView data
            [self.delegate refreshCollectionViewWithCompletion:^(BOOL completed) {
                
                if (completed) {
                    
                    // Collapse SFPullToRefreshView now refresh is complete
                    self.isRefreshing = NO;
                    [self collapse];
                }
                
            }];
        }
        
        
        // Make Updates to superview
        [self.superview layoutIfNeeded];

    }
}

-(void)collapse {
    
    // Tell delegate to reset collectiomView Y offset to 0
    // This will also collapse the SFPullToRefreshView
    [self.delegate resetCollectionViewOffset];
    
    // In the event the pull to refresh persists onscreen
    [UIView animateWithDuration:0.12 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.heightConstraint.constant = 0;
        self.icon.alpha = 0;
        self.label.alpha = 0;
        [self.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (finished) {
            self.hidden = YES;
        }
    }];
}

-(void)updateLabel {
    self.label.text = @"Refreshing Sharks...";
    [UIView animateWithDuration:0.12 animations:^{
        self.label.alpha = 1;
    }];
}

@end
