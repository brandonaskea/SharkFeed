//
//  SFLightBoxViewController.m
//  SharkFeed
//
//  Created by Brandon Askea on 9/20/16.
//  Copyright © 2016 Yahoo-Brandon_Askea. All rights reserved.
//

#import "SFLightBoxViewController.h"
#import "SFConstants.h"
#import "SFFeedObject.h"
#import "UIColor+SFColors.h"

@interface SFLightBoxViewController ()

@end

@implementation SFLightBoxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.activityIndicator.hidden = YES;
    
    // Set Up UI
    [self setUpUI];
    
    // Register for notification to load detail
    [self registerForNotifications];
}

-(void)setUpUI {
    
    // Set colors
    [self.doneButton setTitleColor:[UIColor darkBlue] forState:UIControlStateNormal];
    [self.downloadImageButton setTitleColor:[UIColor darkBlue] forState:UIControlStateNormal];
    self.titleLabel.textColor = [UIColor lightBlue];
}

-(void)registerForNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadLightBoxWithObject:) name:kNotificationKeyLightBoxLoad object:nil];
}

-(void)unregisterForNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationKeyLightBoxLoad object:nil];
}

-(void)loadLightBoxWithObject:(NSNotification *)notification {
    
    SFFeedObject *object = (SFFeedObject *)notification.object;
    
    // Hide image view until we have image
    self.imageView.alpha = 0;
    
    // Set title for photo
    self.titleLabel.text = object.title;
    
    
    // Animate activity indicator
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
    
    // Download large image from Flickr
    NSURL *url = [NSURL URLWithString:[object.imgURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    NSURLRequest *fullImgRequest = [NSURLRequest requestWithURL:url];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:fullImgRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (data) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                // Retreive Image
                self.imageView.image = [UIImage imageWithData:data];
                
                
                // Stop acitivty indicator
                self.activityIndicator.hidden = YES;
                [self.activityIndicator stopAnimating];
                
                
                // Fade in imageView with image
                [UIView animateWithDuration:kImageFadeDuration animations:^{
                    self.imageView.alpha = 1;
                }];
                
            });
        }
        
    }]resume];
    [session finishTasksAndInvalidate];
    
}

#pragma mark - Button Actions
- (IBAction)doneButtonTapped:(id)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationKeyLightBoxUnLoad object:nil];
}

- (IBAction)downloadButtonTapped:(id)sender {
    UIImageWriteToSavedPhotosAlbum(self.imageView.image, nil, nil, nil);
    UIAlertController *savedPhotoAlert = [UIAlertController alertControllerWithTitle:@"Image Saved!" message:@"You will find this image saved to your device's photo gallery" preferredStyle:UIAlertControllerStyleAlert];
    [savedPhotoAlert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [savedPhotoAlert removeFromParentViewController];
    }]];
    [self presentViewController:savedPhotoAlert animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
