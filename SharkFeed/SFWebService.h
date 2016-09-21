//
//  SFWebService.h
//  SharkFeed
//
//  Created by Brandon Askea on 9/19/16.
//  Copyright © 2016 Yahoo-Brandon_Askea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFFetchedResultsController.h"
#import "SFConstants.h"

@interface SFWebService : NSObject
-(id)initWithFetchResultsController:(SFFetchedResultsController *)fetchedResultsController;
-(void)downloadImageWithURL:(NSString *)urlString forIndex:(NSUInteger)idx andCompletion:(PhotoCompletion)completion;
-(void)loadNextPage;
-(void)refresh;
-(void)downloadingImageForIndex:(NSUInteger)idx;
-(BOOL)isDownloadingImageForIndex:(NSUInteger)idx;
@end
