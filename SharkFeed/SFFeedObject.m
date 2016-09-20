//
//  SFFeedObject.m
//  SharkFeed
//
//  Created by Brandon Askea on 9/19/16.
//  Copyright © 2016 Yahoo-Brandon_Askea. All rights reserved.
//

#import "SFFeedObject.h"

@implementation SFFeedObject

-(void)configureNewObject {
    self.flickrID = @"";
    self.title = @"";
    self.thumbURL = @"";
    self.thumbImg = nil;
    self.imgURL = @"";
    self.isMissingImage = NO; // Absence of image in Flickr. Failure to load.
}

-(void)flushThumb {
    self.thumbImg = nil;
}

@end
