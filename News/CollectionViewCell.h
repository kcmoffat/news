//
//  CollectionViewCell.h
//  News
//
//  Created by KASEY MOFFAT on 3/16/15.
//  Copyright (c) 2015 KASEY MOFFAT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) UIImageView *imageView;

-(void)updateTitleLabel:(NSString *)string;
@end
