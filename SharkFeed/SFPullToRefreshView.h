//
//  SFPullToRefreshView.h
//  SharkFeed
//
//  Created by Brandon Askea on 9/20/16.
//  Copyright © 2016 Yahoo-Brandon_Askea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFConstants.h"

@protocol SFPullToRefreshDelegate <NSObject>

-(void)refreshCollectionViewWithCompletion:(RefreshCompletion)completion;
-(void)resetCollectionViewOffset;

@end

@interface SFPullToRefreshView : UIView

@property (assign) BOOL isRefreshing;

-(void)configureWithDelegate:(id)del icon:(UIImageView *)icon label:(UILabel *)label andHeightConstraint:(NSLayoutConstraint *)height iconHeightConstraint:(NSLayoutConstraint *)iconHeight iconWidthConstraint:(NSLayoutConstraint *)iconWidth;
-(void)updateHeightConstraintWithConstant:(CGFloat)constraintConstant;

@end
