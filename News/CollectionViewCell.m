//
//  CollectionViewCell.m
//  News
//
//  Created by KASEY MOFFAT on 3/16/15.
//  Copyright (c) 2015 KASEY MOFFAT. All rights reserved.
//

#import "CollectionViewCell.h"

@interface CollectionViewCell ()
@end

@implementation CollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupImageView];
        [self setupTitleLabel];
    }
    return self;
}

-(void)setupTitleLabel {
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, self.contentView.bounds.size.width-5, self.contentView.bounds.size.height-5)];
    self.label.numberOfLines = 0;
    self.label.textColor = [UIColor whiteColor];
    [self.contentView addSubview:self.label];
}

-(void)updateTitleLabel:(NSString *)string {
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};
    NSMutableAttributedString *mutAttrStr = [[NSMutableAttributedString alloc] initWithString:string attributes:attributes];
    
    self.label.attributedText = mutAttrStr;
//    [self.label sizeToFit];
}

-(void)setupImageView {
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.bounds.size.width, self.contentView.bounds.size.height)];
    [self.imageView setContentMode:UIViewContentModeScaleAspectFill];
    self.imageView.clipsToBounds = YES;
    [self.contentView addSubview:self.imageView];
}

-(void)prepareForReuse {
    self.imageView.image = nil;
    self.label.text = @"";
}

@end
