//
//  SFFeedCollectionViewCell.h
//  SharkFeed
//
//  Created by Brandon Askea on 9/19/16.
//  Copyright © 2016 Yahoo-Brandon_Askea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFFeedObject.h"

@interface SFFeedCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
-(void)configureCellWithFeedObject:(SFFeedObject *)object;
-(void)cancelImageDownload;
@end
