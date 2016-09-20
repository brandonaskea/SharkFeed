//
//  SFWebService.m
//  SharkFeed
//
//  Created by Brandon Askea on 9/19/16.
//  Copyright © 2016 Yahoo-Brandon_Askea. All rights reserved.
//

#import "SFWebService.h"
#import "SFConstants.h"
#import "SFFeedObject.h"

@interface SFWebService ()

@property (nonatomic) SFFetchedResultsController *fetchedResultsController;
@property (assign) NSInteger currentPage;

@end

@implementation SFWebService

-(id)initWithFetchResultsController:(SFFetchedResultsController *)frc {
    
    self = [super init];
    
    if (self) {
        self.fetchedResultsController = frc;
        self.currentPage = 0;
    }
    
    return self;
}

-(void)loadNextPage {
    
    // Format Next Page
    NSInteger nextPage = self.currentPage += 1;
    NSString *page = [NSString stringWithFormat:@"%ld",nextPage];
    
    // Construct Call
    NSString *urlString = [NSString stringWithFormat:kApiSearchEndPoint, kApikey, kApiSearchText, page];
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // Make Call
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (data) {
            
            // Parse JSON into array of SFFeedObjects
            NSMutableArray *pageObjects = [NSMutableArray new];
            
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            
            if (json[kApiSearchReturnFieldPhotos]) {
                
                NSDictionary *photosDic = json[kApiSearchReturnFieldPhotos]; // A dictionary containing all the photos and meta
                
                for (NSString *key in photosDic.allKeys) {
                    

                    if ([key isEqualToString:kApiSearchReturnFieldPhoto]) {
                        
                        for (NSDictionary *photoDic in photosDic[key]) {
                            
                            // Parse photo into SFFeedObject
                            SFFeedObject *object = [SFFeedObject new];
                            [object configureNewObject];
                            
                            // ID
                            if (photoDic[kApiSearchReturnFieldID]) {
                                object.flickrID = photoDic[kApiSearchReturnFieldID];
                            }
                            // TITLE
                            if (photoDic[kApiSearchReturnFieldTitle]) {
                                object.title = photoDic[kApiSearchReturnFieldTitle];
                            }
                            // THUMB IMG
                            if (photoDic[kApiSearchReturnFieldThumb]) {
                                object.thumbURL = photoDic[kApiSearchReturnFieldThumb];
                            }
                            // FULL IMG
                            if (photoDic[kApiSearchReturnFieldFull]) {
                                object.imgURL = photoDic[kApiSearchReturnFieldFull];
                            }
                            
                            // Add to page collection
                            [pageObjects addObject:object];
                            NSLog(@"%@",object.title);
                        }
                        
                    }
                    
                }
                
                [self.fetchedResultsController appendFeedObjectsWithPage:pageObjects];
            }
            
        }

    }]resume];
    [session finishTasksAndInvalidate];
    
}

@end
