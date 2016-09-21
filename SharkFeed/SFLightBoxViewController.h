//
//  SFLightBoxViewController.h
//  SharkFeed
//
//  Created by Brandon Askea on 9/20/16.
//  Copyright © 2016 Yahoo-Brandon_Askea. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFLightBoxViewController : UIViewController

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *titleContainerHeightConstraint;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *callToActionContainerHeightConstraint;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) IBOutlet UIButton *downloadImageButton;

@property (strong, nonatomic) IBOutlet UIButton *doneButton;

@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
