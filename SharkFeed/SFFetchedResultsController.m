//
//  SFFetchedResultsController.m
//  SharkFeed
//
//  Created by Brandon Askea on 9/19/16.
//  Copyright © 2016 Yahoo-Brandon_Askea. All rights reserved.
//

#import "SFFetchedResultsController.h"

@interface SFFetchedResultsController ()
@property (strong) NSMutableArray *feedObjects;
@property (weak) id<SFFetchedResultsDelegate> delegate;
@end

@implementation SFFetchedResultsController



-(id)initWithDelegate:(id)del {
    self = [super init];
    if (self) {
        self.feedObjects = [NSMutableArray new];
        self.delegate = del;
    }
    return self;
}

-(void)appendFeedObjectsWithPage:(NSArray *)pageObjects {
    
    /* 
        After the SFWebService retreives the new
        page, SFWebService will call to append 
        the feedObjects with the new page of 
        SFFeedObjects
    */
    
    [self.feedObjects addObjectsFromArray:pageObjects];
    
    // Tell the collectionView to reload the indecies of all the objects
    // Build Indecies
    NSMutableArray *indeciesToReload = [NSMutableArray new];
    for (int i = 0; i < self.feedObjects.count; i++) {
        NSIndexPath *idx = [NSIndexPath indexPathForItem:i inSection:0];
        [indeciesToReload addObject:idx];
    }
    
    // Update collectionView
    [self.delegate updateCollectionViewAtIndecies:indeciesToReload];
}

-(SFFeedObject *)getObjectAtIndex:(NSUInteger)idx {
    return [self.feedObjects objectAtIndex:idx];
}

-(NSUInteger)numberOfObjects {
    return self.feedObjects.count;
}

-(void)flushThumbs {
    for (SFFeedObject *object in self.feedObjects) {
        [object flushThumb];
    }
}

@end
