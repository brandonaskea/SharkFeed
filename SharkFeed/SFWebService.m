//
//  SFWebService.m
//  SharkFeed
//
//  Created by Brandon Askea on 9/19/16.
//  Copyright © 2016 Yahoo-Brandon_Askea. All rights reserved.
//

#import "SFWebService.h"
#import "SFFeedObject.h"

@interface SFWebService ()

@property (nonatomic) SFFetchedResultsController *fetchedResultsController;
@property (assign) NSInteger currentPage;
@property (nonatomic) NSURLSession *session;
@property (nonatomic) NSMutableIndexSet *indeciesCurrentlyDownloading;

@end

@implementation SFWebService

-(id)initWithFetchResultsController:(SFFetchedResultsController *)frc {
    
    self = [super init];
    
    if (self) {
        self.indeciesCurrentlyDownloading = [[NSMutableIndexSet alloc]init];
        self.fetchedResultsController = frc;
        self.currentPage = 0;
    }
    
    return self;
}

-(void)refresh {
    [self.indeciesCurrentlyDownloading removeAllIndexes];
    self.currentPage = 0;
    [self loadNextPage];
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
    self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (data) {
            
            // Parse JSON into array of SFFeedObjects
            NSMutableArray *pageObjects = [NSMutableArray new];
            
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            
            if (json[kApiSearchReturnFieldPhotos]) {
                
                NSDictionary *photosDic = json[kApiSearchReturnFieldPhotos]; // A dictionary containing all the photos and meta
                
                for (NSString *key in photosDic.allKeys) {
                    

                    if ([key isEqualToString:kApiSearchReturnFieldPhoto]) {
                        
                        NSUInteger idx = 0;
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
                            // INDEX
                            object.idx = idx;
                            
                            // Add to page collection
                            [pageObjects addObject:object];
                            
                            idx += 1;
                        }
                        
                    }
                    
                }
                
                [self.fetchedResultsController appendFeedObjectsWithPage:pageObjects];
            }
            
        }

    }]resume];
    [self.session finishTasksAndInvalidate];
    
}

-(void)downloadImageWithURL:(NSString *)urlString forIndex:(NSUInteger)idx andCompletion:(PhotoCompletion)completion {
    
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    NSURLRequest *downloadThumbRequest = [NSURLRequest requestWithURL:url];
    
    self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[self.session dataTaskWithRequest:downloadThumbRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            completion(YES,[UIImage imageWithData:data], idx);
        }
        else {
            completion(NO,nil,0);
        }
    }]resume];
    [self.session finishTasksAndInvalidate];
}

-(void)downloadingImageForIndex:(NSUInteger)idx {
    [self.indeciesCurrentlyDownloading addIndex:idx];
}

-(BOOL)isDownloadingImageForIndex:(NSUInteger)idx {
    return [self.indeciesCurrentlyDownloading containsIndex:idx];
}

@end
