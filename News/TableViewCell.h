//
//  TableViewCell.h
//  News
//
//  Created by KASEY MOFFAT on 3/15/15.
//  Copyright (c) 2015 KASEY MOFFAT. All rights reserved.
//
// Grid view credit to https://github.com/ashfurrow/AFTabledCollectionView

#import <UIKit/UIKit.h>

static NSString *CollectionViewCellIdentifier = @"CollectionViewCellIdentifier";

@interface TableViewCell : UITableViewCell

@property (nonatomic, strong) UICollectionView *collectionView;

-(void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate index:(NSInteger)index;

@end
