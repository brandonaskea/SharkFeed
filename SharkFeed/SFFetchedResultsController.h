//
//  SFFetchedResultsController.h
//  SharkFeed
//
//  Created by Brandon Askea on 9/19/16.
//  Copyright © 2016 Yahoo-Brandon_Askea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFFeedObject.h"

@protocol SFFetchedResultsDelegate <NSObject>
-(void)updateCollectionViewAtIndecies:(NSArray *)indecies;
@end

@interface SFFetchedResultsController : NSObject
-(SFFeedObject *)getObjectAtIndex:(NSUInteger)idx;
-(NSUInteger)numberOfObjects;
-(void)appendFeedObjectsWithPage:(NSArray *)pageObjects;
-(void)flushThumbs;
-(id)initWithDelegate:(id)del;
@end
