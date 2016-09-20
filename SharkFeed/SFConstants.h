//
//  SFConstants.h
//  SharkFeed
//
//  Created by Brandon Askea on 9/19/16.
//  Copyright © 2016 Yahoo-Brandon_Askea. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ThumbCompletion)(BOOL completed, UIImage* image);

#pragma mark - SFFeedViewController
static NSString * const kFeedCellIdentifier = @"FeedCell";
static double kImageFadeDuration = 0.18;

#pragma mark - Flickr API
static NSString * const kApikey = @"949e98778755d1982f537d56236bbb42";
static NSString * const kApiSearchText = @"shark";
static NSString * const kApiSearchEndPoint = @"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&text=%@&format=json&nojsoncallback=1&page=%@&extras=url_c,url_l"; // Format with kApiKey then kApiSearchText then page number
static NSString * const kApiDetailEndpoint = @"https://api.flickr.com/services/rest/?method=flickr.photos.getInfo&api_key=%@&photo_id=%@&format=json&nojsoncallback=1"; // Format with kApiKey then photo_id

static NSString * const kApiSearchReturnFieldPhotos = @"photos";
static NSString * const kApiSearchReturnFieldPhoto = @"photo"; // Each photo is an SFFeedObject

static NSString * const kApiSearchReturnFieldID = @"id";
static NSString * const kApiSearchReturnFieldTitle = @"title";
static NSString * const kApiSearchReturnFieldThumb = @"url_c";
static NSString * const kApiSearchReturnFieldFull = @"url_l";