//
//  SFFeedObject.h
//  SharkFeed
//
//  Created by Brandon Askea on 9/19/16.
//  Copyright © 2016 Yahoo-Brandon_Askea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SFFeedObject : NSObject

@property (nonatomic) NSString *flickrID;

@property (nonatomic) NSString *thumbURL; // Thumb Image

@property (nonatomic) NSString *imgURL;   // Full Image

@property (nonatomic) NSString *title;

@property (nonatomic) UIImage *thumbImg;

@property (assign) BOOL isMissingImage;

-(void)configureNewObject;
-(void)flushThumb;

@end
