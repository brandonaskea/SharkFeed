//
//  SFFeedCollectionViewCell.m
//  SharkFeed
//
//  Created by Brandon Askea on 9/19/16.
//  Copyright © 2016 Yahoo-Brandon_Askea. All rights reserved.
//

#import "SFFeedCollectionViewCell.h"
#import "SFConstants.h"

@interface SFFeedCollectionViewCell () {
    
}

@property (nonatomic) NSURLSession *session;

@end

@implementation SFFeedCollectionViewCell

-(void)configureCellWithFeedObject:(SFFeedObject *)object {
    
    self.contentView.clipsToBounds = YES;
    self.contentView.layer.cornerRadius = kFeedCellCornerRadius;
    self.imageView.alpha = 0;
    
    // If we already have the image we will place it
    if (object.thumbImg) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.imageView.image = object.thumbImg;
            
            // Fade in if didn't already
            if (object.didPresentImage == NO) {
                [UIView animateWithDuration:kImageFadeDuration animations:^{
                    self.imageView.alpha = 1;
                } completion:^(BOOL finished) {
                    if (finished) {
                        object.didPresentImage = YES;
                    }
                }];
            }
            else {
                self.imageView.alpha = 1;
            }
            
        });
    }
    
    // If there is a missing image, display bundle image
    if (object.isMissingImage) {
        dispatch_async(dispatch_get_main_queue(), ^{
           self.imageView.image = [UIImage imageNamed:kMissingImage];
            self.imageView.alpha = 1;
        });
    }
    
}

-(void)prepareForReuse {
    [super prepareForReuse];
    self.imageView.image = nil;
}

-(void)cancelImageDownload {
    [self.session invalidateAndCancel];
}

@end
