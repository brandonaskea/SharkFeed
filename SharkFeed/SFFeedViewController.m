//
//  SFFeedViewController.m
//  SharkFeed
//
//  Created by Brandon Askea on 9/19/16.
//  Copyright © 2016 Yahoo-Brandon_Askea. All rights reserved.
//

#import "SFFeedViewController.h"
#import "SFFetchedResultsController.h"
#import "SFFeedObject.h"
#import "SFFeedCollectionViewCell.h"
#import "SFWebService.h"
#import "SFConstants.h"

@interface SFFeedViewController () <UICollectionViewDataSource, UICollectionViewDelegate, SFFetchedResultsDelegate>

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic) SFFetchedResultsController *fetchedResultsController;
@property (nonatomic) SFWebService *webService;

@end

@implementation SFFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set Up Results Controller
    self.fetchedResultsController = [[SFFetchedResultsController alloc] initWithDelegate:self];
    
    // Set Up Web Service
    self.webService = [[SFWebService alloc] initWithFetchResultsController:self.fetchedResultsController];
}

-(void)viewDidAppear:(BOOL)animated {
    [self.webService loadNextPage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [self.fetchedResultsController flushThumbs];
    NSLog(@"FLUSHED!!!!!!!!!");
}

#pragma mark - SFFetchResultsDelegate
-(void)updateCollectionViewAtIndecies:(NSArray *)indecies {
    if ([self.fetchedResultsController numberOfObjects] > 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    }
}

#pragma mark - UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [self.fetchedResultsController numberOfObjects] - 1) {
        [self.webService loadNextPage];
    }
}

#pragma mark - UICollectionViewDatasource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.fetchedResultsController numberOfObjects];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SFFeedCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFeedCellIdentifier forIndexPath:indexPath];
    [cell configureCellWithFeedObject:[self.fetchedResultsController getObjectAtIndex:indexPath.row]];
    return cell;
}


@end
