//
//  SFWebService.h
//  SharkFeed
//
//  Created by Brandon Askea on 9/19/16.
//  Copyright © 2016 Yahoo-Brandon_Askea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFFetchedResultsController.h"

@interface SFWebService : NSObject
-(id)initWithFetchResultsController:(SFFetchedResultsController *)fetchedResultsController;
-(void)loadNextPage;
@end
