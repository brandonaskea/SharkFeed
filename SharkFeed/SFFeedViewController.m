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
#import "SFLightBoxView.h"
#import "SFPullToRefreshView.h"
#import "UIColor+SFColors.h"

@interface SFFeedViewController () <UICollectionViewDataSource, UICollectionViewDelegate, SFFetchedResultsDelegate, SFPullToRefreshDelegate>



@property (strong, nonatomic) IBOutlet UIView *launchBackground;
@property (strong, nonatomic) IBOutlet UIImageView *logo;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *logoTopConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *logoWidthConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *logoHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *logoVerticalCenterConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *logoHorizontalCenterConstraint;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) IBOutlet UIView *navBar;

@property (strong, nonatomic) IBOutlet SFPullToRefreshView *pullToRefresh;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *pullToRefreshHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *pullToRefreshIconHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *pullToRefreshIconWidthConstraint;
@property (strong, nonatomic) IBOutlet UIImageView *pullToRefreshIcon;
@property (strong, nonatomic) IBOutlet UILabel *pullToRefreshLabel;


@property (strong, nonatomic) IBOutlet SFLightBoxView *lightBox;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lightBoxTopConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lightBoxLeftConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lightBoxBottomConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lightBoxRightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lightBoxHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lightBoxWidthConstraint;


@property (nonatomic) SFFetchedResultsController *fetchedResultsController;
@property (nonatomic) SFWebService *webService;
@property (nonatomic) RefreshCompletion refreshCompletion;

@end

@implementation SFFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set Up UI
    [self setUpUI];
    
    // Set Up Results Controller
    self.fetchedResultsController = [[SFFetchedResultsController alloc] initWithDelegate:self];
    
    // Set Up Web Service
    self.webService = [[SFWebService alloc] initWithFetchResultsController:self.fetchedResultsController];
    
    // Set Up Light Box
    [self.lightBox configureLightBoxWithConstraintsTop:self.lightBoxTopConstraint left:self.lightBoxLeftConstraint bottom:self.lightBoxBottomConstraint right:self.lightBoxRightConstraint width:self.lightBoxWidthConstraint height:self.lightBoxHeightConstraint];
    
    // Set Up Pull To Refresh
    [self.pullToRefresh configureWithDelegate:self icon:self.pullToRefreshIcon label:self.pullToRefreshLabel andHeightConstraint:self.pullToRefreshHeightConstraint iconHeightConstraint:self.pullToRefreshIconHeightConstraint iconWidthConstraint:self.pullToRefreshIconWidthConstraint];
    
}

-(BOOL)prefersStatusBarHidden {
    return YES;
}

-(void)setUpUI {
    self.view.backgroundColor = [UIColor lightBlue];
    self.navBar.backgroundColor = [UIColor darkBlue];
    
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.backgroundView.backgroundColor = [UIColor clearColor];
    self.collectionView.canCancelContentTouches = NO;
    
    // Collection View Flow Layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = kFeedCellPadding;
    layout.minimumInteritemSpacing = kFeedCellPadding;
    layout.itemSize = CGSizeMake(kFeedCellHW - kFeedCellInsets, kFeedCellHW - kFeedCellInsets);
    layout.sectionInset = UIEdgeInsetsMake(kFeedCellInsets, kFeedCellInsets, 0, kFeedCellInsets);
    [self.collectionView setCollectionViewLayout:layout];
    
    
}

-(void)viewDidAppear:(BOOL)animated {
    
    [self.activityIndicator startAnimating];
    
    [self animateLaunchScreen];
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
            [self.activityIndicator stopAnimating];
            self.activityIndicator.hidden = YES;
            [self.collectionView reloadData];
            if (self.refreshCompletion) {
                self.refreshCompletion(YES);
                self.refreshCompletion = nil;
            }
        });
    }
}

#pragma mark - SFPullToRefreshDelegate
-(void)refreshCollectionViewWithCompletion:(RefreshCompletion)completion {
    
    // Flush the fetchResultsController feedObjects
    [self.fetchedResultsController flushAllObjects];

    
    // Reload CollectionView
    [self.collectionView reloadData];
    
    
    // Display activity indicator
    [self.activityIndicator startAnimating];
    self.activityIndicator.hidden = NO;
    
    
    // Make the call to refresh collectionView
    self.refreshCompletion = completion;
    [self.webService refresh];
}

-(void)resetCollectionViewOffset {
    [self.collectionView setContentOffset:CGPointZero];
}

#pragma mark - UIScrollView/CollectionViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (self.pullToRefresh.isRefreshing) {
        if (scrollView.contentOffset.y < kPullToRefreshRefreshThreshold) {
            [scrollView setContentOffset:CGPointMake(0, kPullToRefreshRefreshThreshold)];
        }
    }
    else {
        if (scrollView.contentOffset.y < 0) {
            [self.pullToRefresh updateHeightConstraintWithConstant:fabs(scrollView.contentOffset.y)];
        }
    }
}

#pragma mark - UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    /*
        React to user selection of a photo
        Find the rect of the cell selected
        and present the LightBox view fade
        in transition for more details on
        feed object
     */
    
    
    // Retreive the rect of the cell selected
    UICollectionViewLayoutAttributes *cellAttributes = [collectionView layoutAttributesForItemAtIndexPath:indexPath];
    CGRect rect = cellAttributes.frame;
    
    
    // Retreive the object that was selected
    SFFeedObject *object = [self.fetchedResultsController getObjectAtIndex:indexPath.row];
    
    
    // Build LightBox for selection
    [self.lightBox buildLightBoxWithObject:object fromRect:rect];
}

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(SFFeedCollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    // If we are about to load a cell, begin grabbing the image for that cell
    if (!cell.imageView.image && [self.webService isDownloadingImageForIndex:indexPath.row] == NO && self.pullToRefresh.isRefreshing == NO) {
        
        SFFeedObject *object = [self.fetchedResultsController getObjectAtIndex:indexPath.row];
        
        [self.webService downloadingImageForIndex:indexPath.row];
        [self.webService downloadImageWithURL:object.thumbURL forIndex:indexPath.row andCompletion:^(BOOL completed, UIImage *image, NSUInteger idx) {
            
            if (completed) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    // Inform the fetchedResultsController the image is downloaded
                    [self.fetchedResultsController assignImage:image forIndex:idx];
                    
                    // Reload Cell with new image
                    [collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:idx inSection:0]]];
                });
            }
            
        }];
    }
    
    
    // If the collectionView has scrolled to the end, load next page
    if (indexPath.row == [self.fetchedResultsController numberOfObjects] - 1) {
        [self.webService loadNextPage];
    }
}

#pragma mark - UICollectionViewDatasource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.pullToRefresh.isRefreshing) {
        return 0;
    }
    return [self.fetchedResultsController numberOfObjects];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SFFeedCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFeedCellIdentifier forIndexPath:indexPath];
    if ([self.fetchedResultsController getObjectAtIndex:indexPath.row]) {
        [cell configureCellWithFeedObject:[self.fetchedResultsController getObjectAtIndex:indexPath.row]];
    }
    return cell;
}

-(void)animateLaunchScreen {
    
    // Bounce Logo Up
    self.logoWidthConstraint.constant = self.logoWidthConstraint.constant * kLaunchImageBounce;
    [UIView animateWithDuration:0.30 delay:1.25 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        [self.view layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        
        if (finished) {
            // Bounce Logo Down
            self.logoWidthConstraint.constant = self.logoWidthConstraint.constant / kLaunchImageBounce;
            [UIView animateWithDuration:0.20 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                
                [self.view layoutIfNeeded];
                
            } completion:^(BOOL finished) {
                
                if (finished ) {
                    // Bounch Logo Up
                    self.logoWidthConstraint.constant = self.logoWidthConstraint.constant * kLaunchImageBounce;
                    [UIView animateWithDuration:0.16 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                        
                        [self.view layoutIfNeeded];
                        
                    } completion:^(BOOL finished) {
                        
                        if (finished) {
                            // Bounce Down
                            self.logoWidthConstraint.constant = self.logoWidthConstraint.constant / kLaunchImageBounce;
                            [UIView animateWithDuration:0.26 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                                
                                [self.view layoutIfNeeded];
                                
                            } completion:^(BOOL finished) {
                                
                                if (finished) {
                                    
                                    // Fade out launch background
                                    // And place logo up top
                                    [self.view removeConstraint:self.logoHorizontalCenterConstraint];
                                    [self.view removeConstraint:self.logoVerticalCenterConstraint];
                                    self.logoTopConstraint.priority = 500;
                                    self.logoTopConstraint.constant = 0;
                                    self.logoHeightConstraint.constant = kNavBarHeight;
                                    [UIView animateWithDuration:0.35 delay:0.20 options:UIViewAnimationOptionCurveEaseOut animations:^{
                                        
                                        [self.view layoutIfNeeded];
                                        self.launchBackground.alpha = 0;
                                        
                                    } completion:^(BOOL finished) {
                                        
                                        if (finished) {
                                            // Fetch Shark Images
                                            [self.webService loadNextPage];
                                        }
                                        
                                    }];
                                }
                                
                            }];
                        }
                        
                    }];
                }
                
            }];
        }
    }];
}


@end
