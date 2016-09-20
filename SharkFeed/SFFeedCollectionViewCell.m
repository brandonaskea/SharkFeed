//
//  SFFeedCollectionViewCell.m
//  SharkFeed
//
//  Created by Brandon Askea on 9/19/16.
//  Copyright © 2016 Yahoo-Brandon_Askea. All rights reserved.
//

#import "SFFeedCollectionViewCell.h"
#import "SFConstants.h"

@implementation SFFeedCollectionViewCell

-(void)configureCellWithFeedObject:(SFFeedObject *)object {
    
    self.imageView.alpha = 0;
    
    // If we already have the image we will place it there
    if (object.thumbImg) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = object.thumbImg;
            self.imageView.alpha = 1;
        });
    }
    else {
        // Otherwise, make call to download image
        [self downloadImageWithURL:object.thumbURL andCompletion:^(BOOL success, UIImage *image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (success == YES) {
                    self.imageView.image = image;
                    object.thumbImg = image;
                    
                    // Fade in imageView
                    [UIView animateWithDuration:kImageFadeDuration animations:^{
                        self.imageView.alpha = 1;
                    }];
                }
                else {
                    object.isMissingImage = YES;
                }
            });
        }];
    }
    
}

-(void)downloadImageWithURL:(NSString *)urlString andCompletion:(ThumbCompletion)completion {
    
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    NSURLRequest *downloadThumbRequest = [NSURLRequest requestWithURL:url];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:downloadThumbRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            completion(YES,[UIImage imageWithData:data]);
        }
        else {
            completion(NO,nil);
        }
    }]resume];
    [session finishTasksAndInvalidate];
}

-(void)prepareForReuse {
    self.imageView.image = nil;
}

@end
