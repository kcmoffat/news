//
//  CollectionViewCell.m
//  News
//
//  Created by KASEY MOFFAT on 3/16/15.
//  Copyright (c) 2015 KASEY MOFFAT. All rights reserved.
//

#import "CollectionViewCell.h"

@interface CollectionViewCell ()
@property (strong, nonatomic) UIImage *image;
@end

@implementation CollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.bounds.size.width, self.contentView.bounds.size.height)];
        [self.imageView setContentMode:UIViewContentModeScaleAspectFill];
        self.imageView.clipsToBounds = YES;
        
        [self.contentView addSubview:self.imageView];
        
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.contentView.bounds.size.width, self.contentView.bounds.size.height)];
        self.label.numberOfLines = 0;
        self.label.textColor = [UIColor whiteColor];
        [self.contentView addSubview:self.label];
    }
    return self;
}

//- (void)setImageData:(NSData *)imageData {
//    _imageData = imageData;
//    [self drawImage:imageData];
//}

//- (void)drawImage:(NSData *)imageData {
//    UIImage *image = [[UIImage alloc] initWithData:imageData];
//    CGSize imageSize = self.contentView.bounds.size;
//    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0f);
//    CGRect imageRect = CGRectMake(0, 0, imageSize.width, imageSize.height);
//    [image drawInRect:imageRect];
//    self.image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//}

-(void)prepareForReuse {
//    self.imageView.image = nil;
//    self.imageData = nil;
//    self.image = nil;
    self.label.text = @"";
}

@end
